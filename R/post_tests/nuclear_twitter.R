library(tidyverse)
library(lubridate)
library(rtweet)
library(ggthemes)
library(ggrepel)
library(tidytext)
library(maps)
library(ggmap)
library(sf)
library(igraph)
library(tidygraph)

# Sys.setlocale(locale = "english")

rate_limit() %>% View

# lists ==================================================================================
twitter_lists <- tribble(
         ~slug,                                         ~owner_user,
  "nuclear-nonproliferation",                           "TJinDC",
  "cns-tweeters",                                       "mhanham",
  "csis-experts",                                       "CSIS",
  "nuclear-nat-sec-nk",                                 "Jordiew",
  "nuke-nonpro",                                        "NuclearAnthro",
  "arms-race",                                          "thoughtsbytess",
  "nuke-twittah",                                       "Cala_Lesina",
  "nuclear-issues",                                     "sbplama",
  "nuclear-issues",                                     "BMadisonMount",
  "nuclear-weapons",                                    "seb_bw"
)

# get list members =======================================================================
slugs <- twitter_lists %>%
  pull(slug)

owner_users <- twitter_lists %>% 
  pull(owner_user)

users_df <- map2_df(.x = slugs, .y =  owner_users, 
                 ~ lists_members(slug = .x, owner_user = .y))

# filter users ===========================================================================
filtered_users_df <- users_df %>%
  filter(!protected) %>% # otherwise shit fails everywhere... and privacy i guess
  group_by(user_id) %>%
  add_count() %>%
  ungroup() %>%
  arrange(desc(followers_count)) %>%
  distinct(user_id, .keep_all = TRUE) %>%
  filter(n > 1) %>%
  mutate_if(is.character, enc2utf8)

# who, when =======================================================================
filtered_users_df %>% 
  rename(`Account Created` = created_at,
         `No. Statuses` = statuses_count,
         `No. Followers` = followers_count,
         `No. Friends` = friends_count,
         `Screen Name` = screen_name) %>%
  ggplot(aes(`Account Created`, `No. Statuses`,
             size = `No. Followers`,
             color = `No. Friends`)) +
  geom_point() +
  geom_text_repel(aes(label = ifelse(`No. Statuses` > 12000, `Screen Name`, "")),
                  color = "black", size = 3) +
  scale_color_continuous_tableau() +
  theme_gdocs() +
  labs(title = "Nuclear Twitter Accounts: Summary Statistics",
       subtitle = "Labeled users are those with more than 12000 tweets.",
       caption = "@syknapptic")

# user_ids ===============================================================================
user_ids <- filtered_users_df %>%
  pull(user_id)

# timelines ==============================================================================
tweet_counts <- filtered_users_df %>%
  select(user_id, statuses_count) %>%
  mutate(tweet_count = ifelse(statuses_count > 2500, 2500, statuses_count)) %>%
  select(user_id, tweet_count) %>%
  filter(tweet_count > 0) %>%
  arrange(desc(tweet_count))

sleep_timeline <- function(user_ids, n){
  if(rate_limit()$remaining[49] < 500){
    print("Sleeping for 15 minutes")
    Sys.sleep(902)
  } else {
    print(paste("user_id:", user_ids))
    timeline <<- get_timeline(user_ids, n = n)
    print(paste("n:", n))
  }
  return(timeline)
}

timelines <- map2_df(.x = tweet_counts$user_id,
                     .y = tweet_counts$tweet_count,
                     ~ sleep_timeline(.x, n = .y))

# write_rds(timelines, "data/timelines.rds")

# mutate_if(is.character, str_replace_all, "[^a-zA-Z0-9\\s]", "")
# retweet_regex <- "(^.*(RT|@).*?:)"
link_regex <- "http.*$"
retweet_regex <- "(^.*(RT|@).*?:)"
# junk_regex <- "http.*$|[^a-zA-Z0-9\\s\\.']|(^.*(RT|@).*?:)"
junk_regex <- "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d\\.]+|&amp;|&lt;|&gt;|\\bRT\\b|https"
token_regex <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"

tweet_text <- timelines %>%
  filter(!is_retweet) %>%
  select(status_id, created_at, user_id, screen_name, text) %>%
  mutate(text = str_replace_all(text, junk_regex, "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = token_regex) %>%
  filter(!word %in% stop_words$word,
         str_detect(word, "[a-z]"))

frequency <- tweet_text %>% 
  group_by(user_id) %>% 
  count(word, sort = TRUE) %>% 
  left_join(tweet_text %>% 
              group_by(user_id) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)

words_by_time <- tweet_text %>%
  filter(!str_detect(word, "^@")) %>%
  mutate(time_floor = floor_date(created_at, unit = "1 month")) %>%
  count(time_floor, user_id, screen_name, word) %>%
  ungroup() %>%
  group_by(user_id, screen_name, time_floor) %>%
  mutate(time_total = sum(n)) %>%
  group_by(word) %>%
  mutate(word_total = sum(n)) %>%
  ungroup() %>%
  rename(count = n) %>%
  filter(word_total > 30) 

nested_data <- words_by_time %>%
  nest(-word, -user_id, -screen_name) 

nested_models <- nested_data %>%
  # select(-user_id) %>%
  # head() %>%
  mutate(models = purrr::map(data, ~ glm(cbind(count, time_total) ~ time_floor,
                                  data = .x,
                                  family = "binomial")))

slopes <- nested_models %>%
  unnest(purrr::map(models, tidy)) %>%
  filter(term == "time_floor") %>%
  mutate(adjusted.p.value = p.adjust(p.value))

top_slopes <- slopes %>% 
  filter(adjusted.p.value < 0.1)

top_slopes2 <- top_slopes %>% 
  filter(word == "policy")
  top_n(15)
  # filter(adjusted.p.value < 1E-12)

gg <- words_by_time %>%
  inner_join(top_slopes2, by = c("word", "user_id")) %>%
  ggplot() +
  geom_line(aes(time_floor, count/time_total, color = word), size = 1.3) +
  labs(x = NULL, y = "Word frequency")

gg +
  geom_vline(linetype = "dashed", size = 10,
             xintercept = as.Date("2016-11-08", format = "%Y-%m-%d"))

# tf_idf =================================================================================
tf_idf <- tweet_text %>%
  unnest_tokens(word, clean_text) %>%
  # anti_join(stop_words) %>%
  filter(!str_detect(word, "^(\\d+|al|amp|ha|v)$")) %>% 
  count(status_id, word, sort = TRUE) %>%
  bind_tf_idf(word, status_id, n) %>%
  arrange(desc(tf_idf))
  
tf_idf %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  group_by(status) %>% 
  top_n(15) %>% 
  ungroup %>%
  ggplot(aes(word, tf_idf, fill = book)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~book, ncol = 2, scales = "free") +
  coord_flip()
  

# hastags ================================================================================
hashtags <- timelines %>%
  select(screen_name, hashtags) %>%
  unnest() %>% 
  drop_na()

hashtags %>%
  select(hashtags) %>%
  group_by(hashtags) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

# retweets ===============================================================================
retweets <- timelines %>%
  filter(is_retweet)

retweets 

# mentions ===============================================================================
mentions <- timelines %>%
  # select(user_id, mentions_user_id) %>% 
  select(screen_name, mentions_screen_name) %>%
  unnest() %>%
  drop_na()

mentions %>%
  select(mentions_screen_name) %>%
  add_count() %>%
  arrange(desc(n))
  group_by_all() %>%
  add_count() %>% View()
# network ================================================================================
followers_el <- user_ids %>%
  map_df(~ 
           get_followers(.x, retryonratelimit = TRUE) %>%
           mutate(ego = .x,
                  edge_type = "follower") %>%
           rename(alter = user_id) %>%
           select(ego, alter, edge_type)
  )

friends_el <- user_ids %>%
  map_df(
    ~ get_friends(.x, retryonratelimit = TRUE) %>%
      mutate(ego = .x, edge_type = "friend") %>%
      rename(alter = user_id) %>%
      select(ego, alter, edge_type)
  )

full_el <- bind_rows(followers_el, friends_el)

attrs <- full_el %>%
  select(ego, alter) %>%
  stack() %>%
  select(-ind) %>%
  distinct() %>%
  pull() %>%
  lookup_users() %>%
  rename(aka = name,
         name = screen_name) 

clean_attrs <- attrs %>%
  mutate(account_created_at = as.Date(account_created_at)) %>%
  mutate(nuclear_twitter_club = ifelse(user_id %in% user_ids, TRUE, FALSE))

g <- graph_from_data_frame(full_el, directed = FALSE, 
                           vertices = clean_attrs) %>%
  as_tbl_graph() %>%
  mutate(color = ifelse(nuclear_twitter_club, "salmon", "green")) %>%
  activate(edges) %>%
  mutate(color = ifelse(edge_type == "follower", "lightblue", "yellow"))


plot(g, vertex.label = NA, asp = 0, vertex.size = 2)




# oh gawd why ============================================================================


# cities_regex <- maps::world.cities %>%
#   pull(name) %>%
#   str_replace_all("\\s|-", "\\\\b\\(\\\\s|-\\)\\\\b") %>%
#   str_replace_all("^|$", "\\\\b") %>%
#   unique() %>%
#   paste0("(", ., ")") %>%
#   str_c(collapse = "|")

loc_commas <- filtered_users_df %>%
  select(location) %>%
  mutate(comma_count = str_count(location, ",")) %>%
  summarise(max(comma_count)) %>% 
  pull() %>%
  + 1

  
country_regex <- countrycode::countrycode_data %>%
  as_tibble() %>%
  # distinct(country.name.en) %>% 
  mutate(regex = str_to_lower(country.name.en)) %>%
  distinct(regex) %>%
  filter(regex != "hanover") %>%
  # mutate(regex = paste0("(", country.name.en.regex, ")")) %>%
  pull() %>%
  c("united kingdom", "u\\.*k\\.*", "england") %>%
  str_replace_all("\\s|-", "\\\\b\\(\\\\s|-\\)\\\\b") %>%
  str_replace_all("^|$", "\\\\b") %>%
  str_c(collapse = "|")

state_regex <- maps::state.fips %>%
  select(abb, polyname) %>%
  mutate(polyname = str_to_title(polyname)) %>%
  # mutate(abb = str_replace_all(abb, "([A-Z])", "\\1.*")) %>%
  stack() %>%
  as_tibble() %>%
  select(-ind) %>%
  # add_row(values = "")
  pull() %>%
  str_to_lower() %>%
  str_replace_all("\\s|-", "\\\\b\\(\\\\s|-\\)\\\\b") %>%
  str_replace_all("^|$", "\\\\b") %>%
  unique() %>%
  paste0("(", ., ")") %>%
  str_c(collapse = "|")

cities_regex <- maps::us.cities %>%
  as_tibble() %>%
  pull(name) %>%
  str_replace("\\s[A-Z]{2}", "") %>%
  c("Bruxelles", "Brussels", "London", "Moscow", "Oxford", "Hastings", "Nettuno", "NYC", 
    "Melbourne", "Wien", "Southampton", "Prague", "Lyon", "Geneva", "Oslo",
    "West Sussex", "Hiroshima",
    "Nürnberg", "Berlin", "Hamburg", "Sydney", "São Paulo", "Vienna", "Paris",
    "Princeton", "Monterey", "Stanford", "Oak Ridge", "Brooklyn", "Claremont",
    "Hanover",
    "University of Leeds", "Our Nation s Capital", "None of your business") %>%
  str_to_lower() %>%
  str_replace_all("\\s|-", "\\\\b\\(\\\\s|-\\)\\\\b") %>%
  str_replace_all("^|$", "\\\\b") %>%
  unique() %>%
  paste0("(", ., ")") %>%
  str_c(collapse = "|")
  
  
# ISOs <- countrycode::countrycode_data %>%
  # as_tibble()

# bad_locs_regex <-"(?<=monterey)\\swashington dc|usa|(?<=,|\\|).*|dcolney|(?<=francisco)washington|and|vienna\\smiddlebury|\\|"

subset_df <- filtered_users_df %>%
  select(user_id, name, screen_name, location, description) %>%
  mutate(clean_loc = str_to_lower(str_replace_all(location, "\\.", ""))) %>%
  mutate(clean_loc = str_to_lower(str_replace_all(location, "[:punct:]", " "))) %>%
  mutate(clean_loc = str_replace(clean_loc, "\\|.*$", "")) %>%
  mutate(clean_loc = str_trim(clean_loc)) %>%
  mutate(country = str_extract(clean_loc, country_regex))%>%
  mutate(state = str_extract(clean_loc, state_regex)) %>%
  mutate(state = ifelse(nchar(state) == 2, str_to_upper(state), str_to_title(state))) %>%
  mutate(country = ifelse(str_detect(country, "[Uu][Kk]|england"),
                          "United Kingdom", country)) %>%
  mutate(country = ifelse(is.na(state), str_to_title(country), "United States")) %>%
  mutate(state = case_when(state == "NJ" ~ "New Jersey",
                           state == "CA" ~ "California",
                           state == "MA" ~ "Massachusetts",
                           state == "VA" ~ "Virginia",
                           state == "IL" ~ "Illinois",
                           state == "TX" ~ "Texas",
                           state == "NY" ~ "New York",
                           state == "NH" ~ "New Hampshire", 
                           state == "MN" ~ "Minnesota",
                           state == "TN" ~ "Tennessee",
                           state == "MD" ~ "Maryland",
                           state == "NM" ~ "New Mexico",
                           TRUE ~ state)) %>%
  mutate(city = str_trim(str_extract(clean_loc, cities_regex))) %>%
  mutate(city = ifelse(is.na(city), 
                       str_extract(str_to_lower(description), cities_regex), city)) %>%
  mutate(city = case_when(clean_loc == "mit" ~ "cambridge",
                          city == "bruxelles" ~ "brussels",
                          city == "nyc" ~ "new york",
                          city == "nürnberg" ~ "nuremburg",
                          city == "our nation s capital" ~ "washington",
                          city == "são paulo" ~ "sao paulo",
                          city == "university of leeds" ~ "leeds",
                          city == "wien" ~ "vienna",
                          city == "warwick" ~ "coventry",
                          state == "Hiroshima" ~ "hiroshima",
                          state == "DC" ~ "washington",
                          screen_name == "DebakD" ~ "ithaca",
                          screen_name == "ISNJH" ~ "washington",
                          screen_name == "annafifield" ~ "tokyo",
                          screen_name == "DanJoyner1" ~ "tuscaloosa",
                          screen_name == "Staheran" ~ "washington",
                          screen_name == "shamsZaman_72" ~ "london",
                          screen_name == "susisnyder" ~ "",
                          TRUE ~ city)) %>%
  mutate(state = case_when(clean_loc == "mit" ~ "Massachusetts",
                           city == "cambridge" ~ "Massachusetts",
                           city == "birmingham" ~ "Alabama",
                           city == "chicago" ~ "Illinois",
                           city == "los angeles" ~ "California",
                           city == "san francisco" ~ "California",
                           city == "santa barbara" ~ "California",
                           city == "monterey" ~ "California",
                           city == "washington" ~ "DC",
                           city == "princeton" ~ "New Jersey",
                           city == "seattle" ~ "Washington",
                           city == "brooklyn" ~ "New York",
                           city == "new york" ~ "New York",
                           city == "madison" ~ "wisconsin",
                           screen_name == "DebakD" ~ "New York",
                           screen_name == "ISNJH" ~ "DC",
                           screen_name == "DanJoyner1" ~ "Alabama",
                           screen_name == "Staheran" ~ "DC",
                           TRUE ~ state)) %>%
  mutate(country = case_when(screen_name == "annafifield" ~ "Japan",
                             city == "hiroshima" ~ "Japan",
                             city == "vienna" ~ "Austria",
                             city == "wellington" ~ "New Zealand",
                             city == "coventry" ~ "United Kingdom",
                             city == "leeds" ~ "United Kingdom",
                             city == "london" ~ "United Kingdom",
                             city == "berlin" ~ "Germany",
                             city == "geneva" ~ "Switzerland",
                             city == "moscow" ~ "Russia",
                             city == "paris" ~ "France",
                             city == "nettuno" ~ "Italy",
                             city == "melbourne" ~ "Australia",
                             city == "brussels" ~ "Belgium",
                             !is.na(state) ~ "United States",
                             TRUE ~ country))


geocoded_users_df <-subset_df %>% # do distinct addresses then right_join()
  drop_na(city) %>%
  mutate(city = str_to_title(city)) %>%
  mutate(add_for_geocode = case_when(country == "United States" ~ paste(city, state, country, sep = ","),
                                     country != "United States" ~ paste(city, country, sep = ","))) %>%
  drop_na(add_for_geocode) %>%
  mutate_geocode(add_for_geocode) 

geocoded_users_sf <- geocoded_users_df %>%
  drop_na(lon, lat) %>%
  rename(long = lon) %>%
  st_as_sf(coords = c("long", "lat"))

map_world_df <- map_data("world")

ggplot() +
  geom_polygon(aes(long, lat, group = group), 
               fill = "white", color = "black",
               data = map_world_df) +
  geom_sf(data = geocoded_users_sf, color = "red") +
  coord_sf(datum = NA) 


# options(warn=2) 
# options(warn=1)

test_attrs <- attrs[1:3] %>% lookup_users()

test_timeline <- rtweet::get_timeline(1698057336)

# mutate_if(is.character, str_replace_all, "[^a-zA-Z0-9\\s]", "") %>%



############## probably crap #############################################################
new_followers_el <- followers_el %>%
  rename(user_id = alter_id, user = ego_name) %>%
  select(user, user_id)
# followers_el <- map_df(names, build_follower_el)

# followers_el_by_name <- followers_el

# readr::write_rds(new_followers_el, "data/new_followers_el.rds")

followers_ids <- followers_el %>%
  distinct(alter_id) %>%
  pull()

# safe_lookup_users <- safely(lookup_users)

followers_info <- lookup_users(followers_ids)
# readr::write_rds(followers_info, "data/followers_info.rds")

# friends ================================================================================
with_friends <- filtered_users_df %>%
  select(user_id, friends_count) %>%
  filter(friends_count > 0) %>% # 0 friends no fails...
  pull(user_id)

# safe_friends <- function(user_ids){
  # safely(rtweet::get_friends(user_ids, retryonratelimit = TRUE))
# }

friends_list <- get_friends(with_friends, retryonratelimit = TRUE, verbose = TRUE)
  
# safe_friends(user_ids, retryonratelimit = TRUE)
  
friends_el <- friends_list %>%
  rename(ego = user, friend = user_id)

# write_rds(friends_el, "data/friends_el.rds")

# followers network ======================================================================
ego_names_ids <- subset_df %>%
  select(user_id, name) %>%
  rename(ego_id = user_id)

el <- followers_el %>%
  left_join(ego_names_ids, by = c(ego_name = "name")) %>%
  select(ego_id, alter_id) %>%
  drop_na()

all_info <- bind_rows(filtered_users_df, followers_info)

attrs <- el %>%
  stack() %>%
  as_tibble() %>%
  select(-ind) %>%
  rename(user_id = values) %>%
  right_join(all_info) %>%
  distinct(user_id, .keep_all = TRUE)

g <- graph_from_data_frame(el, directed = FALSE, vertices = attrs) %>%

# tweets =================================================================================
my_timeline <- rtweet::get_timeline("syknapptic")


# iconv(TweetText, 'UTF-8', 'ASCII') -> UseableText

