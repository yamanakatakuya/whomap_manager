# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# requirement for R package
# This script is saved in ./whomap_manager since the repo for
# whomapper package cannot store this file.
# please run this in ./whomapper, not here!!
# Takuya Yamanaka, August 2025
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# load each .rda files created from WHO geoJSON
load("data/world.rda")
load("data/disa_ac.rda")
load("data/disa_lake.rda")
load("data/disa_nlake_nac.rda")
load("data/disb_dashed_white.rda")
load("data/disb_dashed_black.rda")
load("data/disb_dashed_grey.rda")
load("data/disb_solid.rda")
load("data/disb_dotted_black.rda")
load("data/disb_dotted_grey.rda")

# merge everything into ./R/sysdata.rda
usethis::use_data(
  world, disa_ac, disa_lake, disa_nlake_nac,
  disb_solid, disb_dotted_black, disb_dotted_grey,
  disb_dashed_white, disb_dashed_black, disb_dashed_grey,
  internal = TRUE, compress = "gzip", overwrite = TRUE
)
# update ./man documentation
devtools::document()

devtools::install(build = TRUE, force = TRUE)