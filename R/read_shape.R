# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Importing latest WHO geoJSON files (in ./shape folder)
# the latest WHO shape/geoJSON files are available at https://gis-who.hub.arcgis.com/
# need to run this script only when there are updates in WHO GIS data.
# Takuya Yamanaka, August 2025
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(sf)
library(here)
library(rmapshaper)


# 1. read raw GIS datasets ---- 
# read raw WHO geoJSON files (3 files are required but included in gitignore as the file size is too large. 
# Please download from https://gis-who.hub.arcgis.com/ and save the files in ./shape)

## Global ADM0
shp0 <- st_read(here::here("./shape/Detailed_Boundary_ADM0.geojson"))
## Boundary Borders
disb <- st_read(here::here("./shape/Detailed_Boundary_Disputed_Borders.geojson"))
## Boundary Areas
disa <- st_read(here::here("./shape/Detailed_Boundary_Disputed_Areas.geojson"))


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
disa_lake <- ms_simplify(disa, keep = 0.01, keep_shapes = TRUE, sys = TRUE) |>
  filter(grepl("lake", NAME, ignore.case = TRUE) | grepl("sea", NAME, ignore.case = TRUE))

# Sudan/South Sudan line and Korean boarder
disb_dashed <- disb |>
  filter(grepl("Sudan", NAME, ignore.case = TRUE) | grepl("Korean", NAME, ignore.case = TRUE) | 
           grepl("Gaza Strip", NAME, ignore.case = TRUE) | grepl("West Bank", NAME, ignore.case = TRUE) | 
           (grepl("SDN claim", NAME, ignore.case = TRUE) & !grepl("Abyei", NAME, ignore.case = TRUE)) | 
           grepl("Ilemi", NAME, ignore.case = TRUE) | grepl("Kosovo", NAME, ignore.case = TRUE) |
           (grepl("J&K", NAME, ignore.case = TRUE) & !grepl("Line", NAME, ignore.case = TRUE)))

# Arunachal Pradesh line
disb_solid <- disb |>
  filter(grepl("Arunachal", NAME, ignore.case = TRUE) | grepl("Sahara", NAME, ignore.case = TRUE)| 
           grepl("EGY claim", NAME, ignore.case = TRUE) | grepl("Aksai", NAME, ignore.case = TRUE) |
           grepl("Jammu and Kashmir", NAME, ignore.case = TRUE) )

# Other disputed boundaries
disb_dotted <- disb |>
  filter(grepl("Abyei", NAME, ignore.case = TRUE) | grepl("J&K Line of Control", NAME, ignore.case = TRUE) )



# 3. save geo datasets ---- 
# saving as rda in ./data
save(world, file = here::here(paste0("./data/world", ".rda")))

save(disa_ac, file = here::here(paste0("./data/disa_ac", ".rda")))
save(disa_nlake_nac, file = here::here(paste0("./data/disa_nlake_nac", ".rda")))
save(disa_lake, file = here::here(paste0("./data/disa_lake", ".rda")))
save(disb_dashed, file = here::here(paste0("./data/disb_dashed", ".rda")))
save(disb_solid, file = here::here(paste0("./data/disb_solid", ".rda")))
save(disb_dotted, file = here::here(paste0("./data/disb_dotted", ".rda")))