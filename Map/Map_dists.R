library(tigris)
library(leaflet)
library(tidyverse)
library(USAboundaries)
library(maps)
library(plotly)
library(ggmap)
library(rgdal)

library(ggplot2)
library(rgeos)
library(maptools)

schools <- read_csv("Current_schools.csv")
comp_dists <- read_csv("LSG_Matched Pairs_NY.csv")
district <- read_csv("Current_Districts (1).csv")

school_leaf <- suppressWarnings(suppressMessages(school_districts("Texas")))

distnames <- comp_dists %>% 
  select(DISTRICT) %>% 
  mutate(DISTRICT = str_pad(DISTRICT, width = 6, side = "left", pad = "0"),
         DISTRICT = str_pad(DISTRICT, width = 7, side = "left", pad = "'")) %>% 
  as.matrix() %>% 
  as.vector()

school_imp <- schools %>% 
  filter(District_N %in% distnames)

treatment <- comp_dists %>% 
  mutate(DISTRICT = str_pad(DISTRICT, width = 6, side = "left", pad = "0"),
         DISTRICT = str_pad(DISTRICT, width = 7, side = "left", pad = "'"),
         Group = factor(treat, levels = c(0,1), labels = c("Control District", "LSG District"))) %>% 
  select(District_N = "DISTRICT", everything() ) %>% 
  right_join(school_imp, by = "District_N")


fort_school <- fortify(school_leaf, region= "NAME")



treatment_red <- treatment %>% 
  group_by(District_N) %>% 
  slice(1) %>% 
  ungroup()


fort_school2 <- fort_school %>% 
  mutate(DISTNAME = str_replace_all(id, "Independent School District", "ISD"),
         DISTNAME = toupper(DISTNAME)) %>% 
  select(long, lat, id, DISTNAME) %>% 
  right_join(treatment_red, by = "DISTNAME") %>% 
  rename(`District Name` = "DISTNAME")


fort_school <- fort_school %>% 
  rename(`District Name` = "id")


final <- ggplot() +
 # geom_polygon(data = map_data("state", region = "texas"), aes(x=long, y=lat, group=group), col="black", fill = "white", size = 1) +
  geom_polygon(data = fort_school, aes(x = long, y = lat, group = `District Name`), fill = "white",  color = "gray", size = 0.001) +
  geom_polygon(data = fort_school2, aes(x = long, y = lat, group = `District Name`, fill = Group), color = "gray", size = .001)  +
  geom_polygon(data = fort_school, aes(x = long, y = lat, group = `District Name`), fill = "white",  color = "black", size = .05, alpha = 1) +
  theme_void() +
  ggtitle("Lonestar Governance (LSG) & Control District Spatial Comparison")

ggplotly(final,
         showline = FALSE,
         showticklabels = FALSE,
         showgrid = FALSE)

