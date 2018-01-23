library(tidyverse)
library(gdeltr2) # devtools::install_github("abresler/gdeltr2")
library(trelliscopejs) # devtools::install_github("hafen/trelliscopejs")

search_terms <- "missile"

langs <- get_gdelt_codebook_ft_api(code_book = "languages") %>%
  pull(value)

theme_regex <- c("nuclear", "missile", "wmd", "bomb") %>%
  str_to_upper() %>%
  str_c(collapse = "|")

gkg_themes <- get_gdelt_codebook_ft_api(code_book = "gkg") %>%
  select(idGKGTheme, isMilitaryEvent, isCriminalEvent) %>%
  filter(str_detect(idGKGTheme, theme_regex)) %>%
  pull(idGKGTheme)
  

gdelt_mentions <- get_data_ft_v2_api(terms = search_terms,
                                     gkg_themes = gkg_themes,
                                     search_language = langs,
                                     visualize_results = FALSE)

knitr::include_graphics("http://centralstation.hosted.cx/hosting/media/centralstation/1643649/mens-room-daily-podcast-1400x1400.a7b700ac-6e30-4e7a-8c67-60426be15990.jpg")
