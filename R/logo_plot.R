library(tidyverse)
library(igraph)
# library(sp)
# library(sf)
library(grid)
library(png)
library(extrafont)

g <- tribble(   
         ~from,                                    ~to,
  #   _______________________________|_______________________________    
  #                                  |
  "United States",                            "Brazil",
  "Brazil",                                   "South Africa",
  "South Africa",                             "France",
  "France",                                   "India",
  "India",                                    "Argentina",
  "Argentina",                                "Russian Federation",
  "Russian Federation",                       "Australia",
  "Australia",                                "Libya",
  "Libya",                                    "United States"
) %>%
  mutate(index = row_number()) %>%
  graph_from_data_frame(directed = FALSE)

country_list <- g %>%
  as_data_frame(what = "vertices") %>%
  as_tibble() %>%
  rename(country = name) %>%
  distinct()
  
load("~/centroids.rda")

centroids_df <- centroids %>%
  filter(type == "country") %>%
  as_tibble() %>%
  select(iso3, longitude, latitude)

iso3s <- ISOcodes::ISO_3166_1 %>% 
  as_tibble() %>%
  select(Alpha_3, Name) %>%
  rename(iso3 = Alpha_3, name = Name) %>%
  right_join(centroids_df) %>% 
  select(iso3, name, longitude, latitude) %>%
  rename(long = longitude, lat = latitude) %>%
  distinct()

node_coords <- country_list %>%
  left_join(iso3s, by = c(country = "name")) %>%
  drop_na() %>%
  distinct(country, .keep_all = TRUE)

el_coords <- g %>%
  as_edgelist() %>%
  as_tibble() %>%
  full_join(node_coords, by = c(V1 = "country")) %>%
  full_join(node_coords, by = c(V2 = "country")) %>%
  drop_na(V1, V2)

# node_bounds <- node_coords %>%
#   select(-country, -iso3) %>%
#   drop_na %>%
#   sp::SpatialPointsDataFrame(coords = .[,1:2],
#                              data = .) %>%
#   sp::bbox()

map_world <- map_data("world") %>%
  as_tibble() %>%
  arrange(desc(order))

# map_world %>%
#   sp::SpatialPointsDataFrame(coords = .[,1:2],
#                              data = .) %>%
#   sp::bbox() 
# # %>%
# #   as_tibble() %>%
# #   filter(region != "Antarctica") %>%
# #   mutate(region = ifelse(region == "USA", "United States", region))

# basic map ==============================================================================
rast <- data.frame(x = rep(1, 1000), y = 1:1000,
                       z = c(1:500, 500:1)) %>%
  as_tibble()

# flame_pal <- c("#CC0000", "#FFA600", "#FFFF00", "#00B7FF")
flame_pal <- c("red", "red", "red", "red", "red",
               "#FF2121", "#FF2121", "#FF2121",  "#FF2121",
               "#FF5500", "#FF5500", "#FF5500", "#FF5500",
               "#FF5921", "#FF5921", "#FF5921", "#FF5921",
               "#FF6600", "#FF6600", "#FF6600",
               "#FF9100",
               "#FFFF29")

# flame_pal <- c("black", "black", "black", "white")

background <- (ggplot(rast) +
  geom_raster(aes(x = x, y = y, fill = z), interpolate = TRUE,
              show.legend = FALSE) +
  scale_fill_gradientn(colours = flame_pal) +
  coord_flip() +
  theme_bw() +
  theme(axis.line = element_line(),
        panel.grid.major = element_line(size = 0.25, color = "white"),
        panel.grid.minor = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank()))

ggsave("background.png", width = 12, height = 8, units = "in", dpi = 500)

rast_grob <- readPNG("background.png") %>%
  rasterGrob(width = unit(1.5, "npc"), height = unit(1.5, "npc"), interpolate = TRUE)


gg <-  ggplot() +
  geom_polygon(data = map_world, size = 0.25,
               aes(long, lat, group = group),
               fill = "black",
               # fill = "#CC0000",
               size = 0.15,
               # alpha = 0.75,
               show.legend = FALSE,
               # color = "#FF0009",
               color = "black"
               ) +
  geom_point(data = node_coords, fill = "#098000", 
             color = "#098000",
             size = 5, stroke = 1.5,
             show.legend = FALSE, shape = 21,
             aes(long, lat)) +
  geom_segment(data = el_coords,
               color = "#098000",
               aes(x = long.x, xend = long.y,
                   y = lat.x, yend = lat.y),
               size = 1.25,
               show.legend = FALSE) +
  geom_segment(data = el_coords,
               color = "#51FF00",
               aes(x = long.x, xend = long.y,
                   y = lat.x, yend = lat.y),
               size = 0.5,
               show.legend = FALSE) +
  geom_point(data = node_coords, fill = "#51FF00", 
             color = "transparent",
             size = 4, stroke = 1,
             show.legend = FALSE, shape = 21,
             aes(long, lat)) +
  geom_point(data = node_coords, fill = "#FFFF00", 
             color = "transparent",
             size = 1, stroke = 1,
             show.legend = FALSE, shape = 21,
             aes(long, lat)) +
  geom_segment(data = el_coords,
               color = "#FFFF00",
               aes(x = long.x, xend = long.y,
                   y = lat.x, yend = lat.y),
               size = 0.15,
               show.legend = FALSE) +
  theme(panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.border = element_blank(),
        # panel.grid.minor = element_line(size = 0.25, color = "white"),
        panel.grid.major = element_line(size = 0.25, color = "white"),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank()
        # line = element_line(colour="black")
        ) +
  # theme() +
  coord_map("polyconic",
            xlim = c(-180, 180), 
            ylim = c(-40, 40)) #+
  # geom_label(aes(0,0, label = "@syknapptic",
  #                family = "Liberation Mono"),
  #            color = "red",
  #            fill = "black",
  #            label.padding = unit(1.5, "lines"),
  #            # alpha = 0.5,
  #            size = 30,
  #            label.r = unit(0.75, "lines")) +
  # geom_label(aes(0,0, label = "           ",
  #                family = "Liberation Mono"),
  #            color = "black",
  #            fill = "transparent",
  #            label.padding = unit(1.5, "lines"),
  #            # alpha = 0.5,
  #            size = 30,
  #            label.r = unit(0.75, "lines"))

# gg# gg2 <- gg + coord_flip()

grid.newpage()
grid.draw(rast_grob)
print(gg, newpage = FALSE)

fonts %>% filter(str_detect(FullName, "Liberation")) %>% select(FullName)

gg +
  geom_label(aes(0,0, label = "@syknapptic",
                 family = "Liberation Mono"),
             color = "black",
             fill = "white",
             label.padding = unit(1, "lines"),
             alpha = 0.5,
             size = 25,
             label.r = unit(0.75, "lines"))



png("logo_small.png", width = 12, height = 8, units = "in", res = 500)
grid.newpage()
grid.draw(rast_grob)
print(gg, newpage = FALSE)
dev.off()

png("logo_twitter.png", width = 1500, height = 500)
grid.newpage()
grid.draw(rast_grob)
print(gg, newpage = FALSE)
dev.off()

jpeg("logo_twitter.jpg", width = 1500, height = 500, quality = 100)
grid.newpage()
grid.draw(rast_grob)
print(gg, newpage = FALSE)
dev.off()


ggsave(filename = "gg.png", dpi = 1000,
       width = 12, height = 8, units = "in")

