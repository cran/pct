## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----libraries, message=FALSE--------------------------------------------
# devtools::install_github("ATFutures/geoplumber")
# require("geojsonsf")
library(pct)

## ------------------------------------------------------------------------
head(santiago_od)

## ------------------------------------------------------------------------
sf:::print.sf(santiago_zones)
plot(santiago_zones)

## ---- warning=FALSE------------------------------------------------------
desire_lines = stplanr::od2line(flow = santiago_od, zones = santiago_zones)

## ---- out.width="100%"---------------------------------------------------
plot(santiago_zones$geometry)
plot(santiago_lines["pcycle"], lwd = santiago_lines$n / 3, add = TRUE)
# gj = geojsonsf::sf_geojson(santiago_lines)
# path = file.path(tempdir(), "dl.geojson")
# write(gj, path)
# html_map = geoplumber::gp_map(path, browse_map = FALSE)
# htmltools::includeHTML(html_map)

## ------------------------------------------------------------------------
desire_lines$hilliness = 0

## ------------------------------------------------------------------------
desire_lines$distance = as.numeric(sf::st_length(desire_lines))

## ------------------------------------------------------------------------
desire_lines$godutch_pcycle = uptake_pct_godutch(distance = desire_lines$distance, gradient = 0)

## ------------------------------------------------------------------------
cor(x = desire_lines$pcycle, y = desire_lines$godutch_pcycle)
plot(x = desire_lines$pcycle, y = desire_lines$godutch_pcycle)
plot(x = desire_lines$distance, y = desire_lines$godutch_pcycle)

## ------------------------------------------------------------------------
library(leaflet)
leaflet(width = "100%") %>% addTiles() %>% addPolylines(data = desire_lines, weight = desire_lines$pcycle * 5)
leaflet(width = "100%") %>% addTiles() %>% addPolylines(data = desire_lines, weight = desire_lines$godutch_pcycle * 5)

