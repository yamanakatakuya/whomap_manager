# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Importing latest WHO geoJSON files (in ./shape folder)
# the latest WHO shape/geoJSON files are available at https://gis-who.hub.arcgis.com/
# need to run this script only when there are updates in WHO GIS data.
# Takuya Yamanaka, August 2025
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(sf)
library(here)
library(rmapshaper)
library(dplyr)


# 1. read raw GIS datasets ---- 
# read raw WHO geoJSON files (3 files are required but included in gitignore as the file size is too large. 
# Please download from https://gis-who.hub.arcgis.com/ and save the files in ./shape)

## Global ADM0
shp0 <- st_read(here::here("./shape/Detailed_Boundary_ADM0.geojson"))
## Boundary Borders
disb <- st_read(here::here("./shape/Detailed_Boundary_Disputed_Borders.geojson"))
## Boundary Areas
disa <- st_read(here::here("./shape/Detailed_Boundary_Disputed_Areas.geojson"))


# produce different percentage of map details ----

#- - - - - - - - - - -
# A. Practical level - 100% for disputed borders, 0.1% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world <- ms_simplify(shp0, keep = 0.0013, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# Aksai Chin hack
disa_ac <- disa |>
  filter(grepl("Aksai", NAME, ignore.case = TRUE))

# Other disputed areas
disa_nlake_nac <- disa |>
  filter(!grepl("lake", NAME, ignore.case = TRUE) & !grepl("sea", NAME, ignore.case = TRUE) & !grepl("Aksai", NAME, ignore.case = TRUE))

# Lakes
disa_lake <- disa |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# Sudan/South Sudan line and Korean boarder
disb_dashed_kor <- disb |>
  filter(grepl("Korean", NAME, ignore.case = TRUE) )

disb_dashed_pse <- disb |>
  filter(grepl("Gaza Strip", NAME, ignore.case = TRUE) | grepl("West Bank", NAME, ignore.case = TRUE))

disb_dashed_sdn <- disb |>
  filter((grepl("SDN claim", NAME, ignore.case = TRUE) & !grepl("Abyei", NAME, ignore.case = TRUE)))

disb_dashed_black <- disb |>
  filter(grepl("Sudan", NAME, ignore.case = TRUE) | grepl("Ilemi", NAME, ignore.case = TRUE) | 
           grepl("Kosovo", NAME, ignore.case = TRUE))

disb_dashed_grey <- disb |>
  filter((grepl("J&K", NAME, ignore.case = TRUE) & !grepl("Line", NAME, ignore.case = TRUE)))

# solid line
disb_solid <- disb |>
  filter(grepl("Arunachal", NAME, ignore.case = TRUE) | grepl("Sahara", NAME, ignore.case = TRUE)| 
           grepl("EGY claim", NAME, ignore.case = TRUE) | grepl("Aksai", NAME, ignore.case = TRUE) |
           grepl("Jammu and Kashmir", NAME, ignore.case = TRUE) )

# dotted boundaries
disb_dotted_grey <- disb |>
  filter(grepl("J&K Line of Control", NAME, ignore.case = TRUE) )

disb_dotted_black <- disb |>
  filter(grepl("Abyei", NAME, ignore.case = TRUE))


# 3. save geo datasets ---- 
# saving as rda in ./data
save(world, file = here::here(paste0("./data/world", ".rda")))

save(disa_ac, file = here::here(paste0("./data/disa_ac", ".rda")))
save(disa_nlake_nac, file = here::here(paste0("./data/disa_nlake_nac", ".rda")))
save(disa_lake, file = here::here(paste0("./data/disa_lake", ".rda")))
save(disb_dashed_kor, file = here::here(paste0("./data/disb_dashed_kor", ".rda")))
save(disb_dashed_pse, file = here::here(paste0("./data/disb_dashed_pse", ".rda")))
save(disb_dashed_sdn, file = here::here(paste0("./data/disb_dashed_sdn", ".rda")))
save(disb_dashed_black, file = here::here(paste0("./data/disb_dashed_black", ".rda")))
save(disb_dashed_grey, file = here::here(paste0("./data/disb_dashed_grey", ".rda")))
save(disb_solid, file = here::here(paste0("./data/disb_solid", ".rda")))
save(disb_dotted_grey, file = here::here(paste0("./data/disb_dotted_grey", ".rda")))
save(disb_dotted_black, file = here::here(paste0("./data/disb_dotted_black", ".rda")))



#- - - - - - - - - - -
# B. For LEG - 100% for all
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world100 <- shp0 |>
  mutate(iso3 = ISO_3_CODE)

# Lakes
disa_lake100 <- disa |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world100, file = here::here(paste0("./data/world_100%", ".rda")))
save(disa_lake100, file = here::here(paste0("./data/disa_lake_100%", ".rda")))


#- - - - - - - - - - -
# C. Increased details - 5% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world5 <- ms_simplify(shp0, keep = 0.05, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# Lakes
disa_lake5 <- ms_simplify(disa, keep = 0.05, keep_shapes = TRUE, sys = TRUE) |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world5, file = here::here(paste0("./data/world_5%", ".rda")))
save(disa_lake5, file = here::here(paste0("./data/disa_lake_5%", ".rda")))


#- - - - - - - - - - -
# D. Increased details - 10% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world10 <- ms_simplify(shp0, keep = 0.1, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# Lakes
disa_lake10 <- ms_simplify(disa, keep = 0.1, keep_shapes = TRUE, sys = TRUE) |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world10, file = here::here(paste0("./data/world_10%", ".rda")))
save(disa_lake10, file = here::here(paste0("./data/disa_lake_10%", ".rda")))


#- - - - - - - - - - -
# E. Increased details - 2.5% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world2.5 <- ms_simplify(shp0, keep = 0.025, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# Lakes
disa_lake2.5 <- ms_simplify(disa, keep = 0.025, keep_shapes = TRUE, sys = TRUE) |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world2.5, file = here::here(paste0("./data/world_2.5%", ".rda")))
save(disa_lake2.5, file = here::here(paste0("./data/disa_lake_2.5%", ".rda")))

#- - - - - - - - - - -
# E. Increased details - 1.25% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world1.25 <- ms_simplify(shp0, keep = 0.0125, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world1.25, file = here::here(paste0("./data/world_1.25%", ".rda")))


#- - - - - - - - - - -
# E. Increased details - 0.75% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world0.75 <- ms_simplify(shp0, keep = 0.0075, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world0.75, file = here::here(paste0("./data/world_0.75%", ".rda")))


#- - - - - - - - - - -
# E. Increased details - 0.5% for base world and lake
#- - - - - - - - - - -

# 2. Data manuputation for practical use and layers for disputed boundaries ---- 
# reducing the level of details using rmapshaper::ms_simplify() since the original geoJSON files are too heavy to be loaded.
world0.5 <- ms_simplify(shp0, keep = 0.005, keep_shapes = TRUE, sys = TRUE) |>
  mutate(iso3 = ISO_3_CODE)

# 3. save geo datasets ---- 
# saving as rda in ./data
save(world0.5, file = here::here(paste0("./data/world_0.5%", ".rda")))

