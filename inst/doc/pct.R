## ---- eval=FALSE, echo=FALSE---------------------------------------------
#  # Aim: generate references.bib - run only if references change
#  refs = RefManageR::ReadZotero(group = "418217", .params = list(collection = "8Y9DU4DR", limit = 100))
#  RefManageR::WriteBib(refs, "vignettes/references.bib")
#  citr::tidy_bib_file(
#    rmd_file = "vignettes/pct.Rmd",
#    messy_bibliography = "vignettes/references.bib",
#    file = "vignettes/refs.bib")
#  file.remove("vignettes/references.bib")

## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE---------------------------------------------------------
#  remotes::install_github("ITSLeeds/pct")

## ------------------------------------------------------------------------
library(pct)

## ------------------------------------------------------------------------
library(sf)
library(stplanr)
library(leaflet)

## ---- eval=FALSE---------------------------------------------------------
#  library(pct)
#  wight_centroids = get_pct_centroids(region = "isle-of-wight")
#  wight_zones = get_pct_zones(region = "isle-of-wight")

## ----centroids, fig.show='hold'------------------------------------------
plot(wight_centroids[, "bicycle"])
plot(wight_zones[, "bicycle"])

## ----get_pct_lines, eval=FALSE-------------------------------------------
#  wight_lines_pct = get_pct_lines(region = "isle-of-wight")

## ---- eval=FALSE---------------------------------------------------------
#  line_order = order(wight_lines_pct$bicycle, decreasing = TRUE)
#  wight_lines_30 = wight_lines_pct[line_order[1:30], ]

## ---- pct-lines-min------------------------------------------------------
lwd = wight_lines_30$all / mean(wight_lines_30$all) * 5
plot(wight_lines_30[c("bicycle", "car_driver", "foot")], lwd = lwd)

## ----leaflines, out.width="100%"-----------------------------------------
pal = colorNumeric(palette = "RdYlBu", domain = wight_lines_30$bicycle)
leaflet(data = wight_lines_30) %>% 
  addTiles() %>% 
  addPolylines(weight = lwd,
               color = ~ pal(bicycle)) %>% 
  addLegend(pal = pal, values = ~bicycle)

## ----isle-pct-bike, echo=FALSE, out.width="100%"-------------------------
# i = magick::image_read("vignettes/isle-pct-bike.png")
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/54882128-c4f02980-4e4e-11e9-8eb8-49c43507165a.png")

## ---- eval=FALSE---------------------------------------------------------
#  wight_od_all = get_od(area = "wight")
#  summary(wight_od_all$geo_code1 %in% wight_centroids$geo_code)
#  #>    Mode    TRUE
#  #> logical    2851
#  summary(wight_od_all$geo_code2 %in% wight_centroids$geo_code)
#  #>    Mode   FALSE    TRUE
#  #> logical    2527     324

## ---- eval=FALSE---------------------------------------------------------
#  wight_od = wight_od_all[
#    wight_od_all$geo_code2 %in% wight_centroids$geo_code,]

## ----pct-lines-----------------------------------------------------------
wight_lines = od2line(wight_od, wight_centroids)
nrow(wight_lines)
sum(wight_lines$all)

## ---- eval=FALSE, echo=FALSE---------------------------------------------
#  # aim: test result of get_desire_lines
#  library(pct)
#  wight_od_all = get_od(area = "wight")
#  wight_od = wight_od_all[
#    wight_od_all$geo_code2 %in% wight_centroids$geo_code,]
#  wight_lines_census = stplanr::od2line(wight_od, wight_centroids)
#  wight_lines_census2 = get_desire_lines(area = "wight")
#  nrow(wight_lines_census)
#  nrow(wight_lines_census2)

## ------------------------------------------------------------------------
wight_lines_census = wight_lines[
  wight_lines$geo_code1 != wight_lines$geo_code2, ]
nrow(wight_lines_census)
sum(wight_lines_census$all)

## ------------------------------------------------------------------------
wight_lines_census1 = onewaygeo(
  wight_lines_census,
  attrib = c("all", "bicycle")
  )
nrow(wight_lines_census1) / nrow(wight_lines_census)
sum(wight_lines_census1$all) / sum(wight_lines_census$all)

## ----pct-routes-fast, eval=FALSE-----------------------------------------
#  wight_routes_fast = line2route(
#    l = wight_lines_census1,
#    route_fun = route_cyclestreet,
#    plan = "fastest")

## ------------------------------------------------------------------------
line_order = order(wight_lines_census1$bicycle, decreasing = TRUE)
wight_lines_census_30 = wight_lines_census1[line_order[1:30], ]

## ---- eval=FALSE---------------------------------------------------------
#  wight_routes_30 = wight_routes_fast[line_order[1:30], ]

## ------------------------------------------------------------------------
d = as.numeric(st_length(wight_lines_census_30))
plot(d, wight_routes_30$length)

## ------------------------------------------------------------------------
plot(wight_lines_30$rf_dist_km, wight_routes_30$length)

## ----pct-goducth---------------------------------------------------------
pcycle_govtarget = uptake_pct_govtarget(
  distance = wight_routes_30$length,
  gradient = wight_routes_30$av_incline * 100
)

## ------------------------------------------------------------------------
wight_routes_30$govtarget = wight_lines_census_30$bicycle +
  pcycle_govtarget * wight_lines_census_30$all
wight_routes_30$govtarget_pct = wight_lines_30$govtarget_slc
library(ggplot2)
ggplot(wight_routes_30) +
  geom_point(aes(
    length,
    govtarget,
    colour = "red"
  )) +
  geom_point(aes(
    length,
    govtarget_pct,
    colour = "godutch"
  ))
cor(wight_routes_30$govtarget, wight_routes_30$govtarget_pct)

## ------------------------------------------------------------------------
rnet = overline2(wight_routes_30, "govtarget")
plot(rnet)

## ---- eval=FALSE---------------------------------------------------------
#  wight_routes_fast$govtarget = uptake_pct_govtarget(
#    distance = wight_routes_fast$length,
#    gradient = wight_routes_fast$av_incline * 100
#    ) * wight_lines_census1$all + wight_lines_census1$bicycle
#  wight_rnet = overline2(wight_routes_fast, "govtarget")

## ---- out.width="100%"---------------------------------------------------
pal = colorNumeric(palette = "RdYlBu", domain = wight_rnet$govtarget)
leaflet(data = wight_rnet) %>% 
  addTiles() %>% 
  addPolylines(color = ~ pal(govtarget)) %>% 
  addLegend(pal = pal, values = ~govtarget)

