## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE, echo=FALSE---------------------------------------------
#  # get citations
#  refs = RefManageR::ReadZotero(group = "418217", .params = list(collection = "JFR868KJ", limit = 100))
#  refs2 = RefManageR::ReadBib("vignettes/refs.bib")
#  refs = c(refs, refs2)
#  citr::insert_citation(bib_file = "vignettes/refs_training.bib")
#  RefManageR::WriteBib(refs, "vignettes/refs_training.bib")
#  citr::tidy_bib_file(rmd_file = "vignettes/pct_training.Rmd", messy_bibliography = "vignettes/refs_training.bib")

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("remotes")
#  pkgs = c(
#    "cyclestreets",
#    "mapview",
#    "pct",
#    "sf",
#    "stats19",
#    "stplanr",
#    "tidyverse",
#    "devtools"
#  )
#  remotes::install_cran(pkgs)
#  # remotes::install_github("ITSLeeds/pct")

## ----setup, out.width="100%", message=FALSE------------------------------
library(pct)
library(dplyr)   # in the tidyverse
library(leaflet) # installed alongside mapvew
zones_all = get_pct_zones("west-yorkshire")
lines_all = get_pct_lines("west-yorkshire")

# basic plot
plot(zones_all$geometry)
plot(lines_all$geometry[lines_all$all > 500], col = "red", add = TRUE)

# interactive plot
active = lines_all %>% 
  mutate(`Percent Active` = (bicycle + foot) / all * 100) %>% 
  filter(e_dist_km < 5)
pal = colorBin(palette = "RdYlBu", domain = active$`Percent Active`, bins = c(0, 2, 4, 10, 15, 20, 30, 40, 90))
leaflet(data = active) %>% 
  addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>% 
  addPolylines(color = ~pal(`Percent Active`), weight = active$all / 100) %>% 
  addLegend(pal = pal, values = ~`Percent Active`)

## ---- out.width="100%"---------------------------------------------------
# car dependent desire lines
car_dependent = lines_all %>% 
  mutate(`Percent Drive` = (car_driver) / all * 100) %>% 
  filter(e_dist_km < 5)
pal = colorBin(palette = "RdYlBu", domain = car_dependent$`Percent Active`, bins = c(0, 20, 40, 60, 80, 100), reverse = TRUE)
leaflet(data = car_dependent) %>% 
  addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>% 
  addPolylines(color = ~pal(`Percent Drive`), weight = active$all / 100) %>% 
  addLegend(pal = pal, values = ~`Percent Drive`)

