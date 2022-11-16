## ---- include=FALSE-----------------------------------------------------------
# knitr::opts_chunk$set(cache = TRUE, class.source = "fold-show")
knitr::opts_chunk$set(cache = TRUE)

## ----clifton, echo=FALSE, fig.cap="Areas that may benefit from improved cycle provision on Clifton Bridge, according to the PCT."----
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130370123-5b8885de-4aed-43b4-8a49-b2f875ffff1b.png")

## ----downloads, echo=FALSE, fig.cap="The Region data tab in the PCT."---------
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130371496-bd0d22ba-c969-4634-904a-0bd0dd924516.png")

## ----pctqgis1, echo=FALSE, fig.cap="Three PCT layers visualised in QGIS."-----
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130372558-629b7fb5-452c-4a44-80bb-2d88a0492be9.png")

## ---- echo=FALSE, eval=FALSE--------------------------------------------------
#  # zip and upload qgis folder to share
#  zip(zipfile = "pctqgis.zip", files = "pctqgis")
#  piggyback::pb_upload("pctqgis.zip")
#  piggyback::pb_download_url("pctqgis.zip")
#  # https://github.com/ITSLeeds/pct/releases/download/0.8.0/pctqgis.zip

## ----cliftonbuffer, echo=FALSE, fig.cap="All fast routes that intersect with Clifton Bridge in QGIS."----
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130374644-549c6de7-97fb-4fff-8356-fa59aa7d481e.png")

## ---- echo=FALSE, eval=FALSE--------------------------------------------------
#  cycle_infra = osminfra::oi_get(place = "north yorkshire", infra_type = "cycle_infrastructure")
#  cycle_infra_projected = sf::st_transform(cycle_infra, 27700)
#  sf::write_sf(cycle_infra, "pctqgis/cycle_infra.gpkg")
#  sf::write_sf(cycle_infra_projected, "pctqgis/cycle_infra_projected.gpkg")

## ----buffer, echo=FALSE, fig.cap="Route network layer and buffer representing cycle infrastructure, to identify gaps in the network."----
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130415597-e7bcb8a1-4792-48de-ba83-118c082584cb.png")

## -----------------------------------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ---- message=FALSE-----------------------------------------------------------
#  library(pct)
#  library(sf)          # key package for working with spatial vector data
#  library(tidyverse)   # in the tidyverse
#  library(tmap)        # installed alongside mapview
#  tmap_options(check.and.fix = TRUE) # tmap setting

## -----------------------------------------------------------------------------
#  region_name = "north-yorkshire"
#  zones_all = get_pct_zones(region_name)
#  lines_all = get_pct_lines(region_name)
#  # note: the next command may take a few seconds
#  routes_all = get_pct_routes_fast(region_name)
#  rnet_all = get_pct_rnet(region_name)

## ----plotall, out.width="70%"-------------------------------------------------
#  plot(zones_all$geometry)
#  plot(lines_all$geometry, col = "blue", add = TRUE)
#  plot(routes_all$geometry, col = "green", add = TRUE)
#  plot(rnet_all$geometry, col = "red", lwd = sqrt(rnet_all$bicycle), add = TRUE)

## -----------------------------------------------------------------------------
#  zones_school = get_pct_zones(region = region_name, purpose = "school")
#  rnet_school = get_pct_rnet(region = region_name, purpose = "school")

## ----school1, fig.cap="Open access data on cycling to school potential from the PCT, at zone (left) and route network (right) levels. These datasets can support planning interventions, especially 'safe routes to school' and interventions in residential areas. To see the source code that generates these plots, see the 'source' link at the top of the page.", out.width="49%", fig.show='hold', echo=FALSE, warning=FALSE----
#  zones_school$dutch_slc[is.na(zones_school$dutch_slc)] = 1.5
#  qtm(zones_school, "dutch_slc", fill.palette = "-viridis")
#  plot(rnet_school["dutch_slc"])

## -----------------------------------------------------------------------------
#  lines_all$pcycle = lines_all$bicycle / lines_all$all
#  lines_all$euclidean_distance = as.numeric(sf::st_length(lines_all))
#  lines_all$pcycle_govtarget = uptake_pct_govtarget_2020(
#    distance = lines_all$rf_dist_km,
#    gradient = lines_all$rf_avslope_perc
#    ) * 100 + lines_all$pcycle

## ----change, echo=FALSE-------------------------------------------------------
#  lines_all$pcycle_dutch = uptake_pct_godutch_2020(
#    distance = lines_all$rf_dist_km,
#    gradient = lines_all$rf_avslope_perc
#    ) * 100 + lines_all$pcycle
#  summary(lines_all$pcycle_dutch)

## ----dutch_pcycle, echo=FALSE, warning=FALSE, fig.show='hold', fig.cap="Percent cycling currently (left) and under a 'Go Dutch' scenario (right) in the North Yorkshire.", out.width="40%"----
#  plot(lines_all["pcycle"], lwd = lines_all$all / mean(lines_all$all), breaks = c(0, 5, 10, 20, 50))
#  plot(lines_all["pcycle_dutch"], lwd = lines_all$all / mean(lines_all$all), breaks = c(0, 5, 10, 20, 50))
#  # cor(l_originalines_all$dutch_slc / l_originalines_all$all, lines_all$pcycle_dutch)
#  # cor(l_originalines_all$govtarget_slc / l_originalines_all$all, lines_all$pcycle_govtarget)
#  # plot(l_originalines_all$dutch_slc / l_originalines_all$all, lines_all$pcycle_dutch)

## ----cities, out.width="45%", fig.show='hold', fig.cap="Classification of areas in Great Britain (left) and North Yorkshire (right).", message=FALSE, warning=FALSE----
#  # Get data on the urban_rural status of LSOA zones
#  urban_rural = readr::read_csv("https://researchbriefings.files.parliament.uk/documents/CBP-8322/oa-classification-csv.csv")
#  ggplot(urban_rural) +
#    geom_bar(aes(citytownclassification)) +
#    coord_flip()
#  
#  # summary(routes_all$geo_code1 %in% urban_rural$lsoa_code)
#  
#  # Join this with the PCT commute data that we previously downloaded
#  urban_rural = rename(urban_rural, geo_code = lsoa_code)
#  zones_all_joined = left_join(zones_all, urban_rural)
#  routes_all_joined = left_join(routes_all, urban_rural, by = c("geo_code1" = "geo_code"))
#  tm_shape(zones_all_joined) +
#    tm_polygons("citytownclassification")

## -----------------------------------------------------------------------------
#  # Select only zones for which the field `citytownclassification` contains the word "Town" or "City"
#  routes_towns = routes_all_joined %>%
#    filter(grepl(pattern = "Town|City", x = citytownclassification))
#  round(sum(routes_towns$foot + routes_towns$bicycle) / sum(routes_towns$all) * 100)

## ----distmode, fig.cap="Relationship between distance (x axis) and mode share (y axis) in towns and cities in North Yorkshire. (a) left: existing mode shares; (b) right: mode shares under high active travel uptake scenario.", out.width="49%", fig.show='hold', message=FALSE----
#  # Reduce the number of transport mode categories
#  routes_towns_recode = routes_towns %>%
#    mutate(public_transport = train_tube + bus,
#           car = car_driver + car_passenger,
#           other = taxi_other + motorbike
#           ) %>%
#    dplyr::select(-car_driver, -car_passenger, -train_tube, -bus)
#  
#  # Set distance bands to use in the bar charts
#  routes_towns_recode$dist_bands = cut(x = routes_towns_recode$rf_dist_km, breaks = c(0, 1, 3, 6, 10, 15, 20, 30, 1000), include.lowest = TRUE)
#  
#  # Set the colours to use in the bar charts
#  col_modes = c("#fe5f55", "grey", "#ffd166", "#90be6d", "#457b9d")
#  
#  # Plot bar chart showing modal share by distance band for existing journeys
#  base_results = routes_towns_recode %>%
#    sf::st_drop_geometry() %>%
#    dplyr::select(dist_bands, car, other, public_transport, bicycle, foot) %>%
#    tidyr::pivot_longer(cols = matches("car|other|publ|cy|foot"), names_to = "mode") %>%
#    mutate(mode = factor(mode, levels = c("car", "other", "public_transport", "bicycle", "foot"), ordered = TRUE)) %>%
#    group_by(dist_bands, mode) %>%
#    summarise(Trips = sum(value))
#  g1 = ggplot(base_results) +
#    geom_col(aes(dist_bands, Trips, fill = mode)) +
#    scale_fill_manual(values = col_modes) + ylab("Trips")
#  g1
#  
#  # Create the new scenario:
#  # First we replace some car journeys with walking, then replace some of the
#  # remaining car journeys with cycling
#  routes_towns_recode_go_active = routes_towns_recode %>%
#    mutate(
#      foot_increase_proportion = case_when(
#        # specifies that 50% of car journeys <1km in length will be replaced with walking
#        rf_dist_km < 1 ~ 0.5,
#        # specifies that 10% of car journeys 1-2km in length will be replaced with walking
#        rf_dist_km >= 1 & rf_dist_km < 2 ~ 0.1,
#        TRUE ~ 0
#        ),
#      # Specify the Go Dutch scenario we will use to replace remaining car trips with cycling
#      bicycle_increase_proportion = uptake_pct_godutch_2020(distance = rf_dist_km, gradient = rf_avslope_perc),
#      # Make the changes specified above
#      car_reduction = car * foot_increase_proportion,
#      car = car - car_reduction,
#      foot = foot + car_reduction,
#      car_reduction = car * bicycle_increase_proportion,
#      car = car - car_reduction,
#      bicycle = bicycle + car_reduction
#      )
#  
#  # Plot bar chart showing how modal share has changed in our new scenario
#  active_results = routes_towns_recode_go_active %>%
#    sf::st_drop_geometry() %>%
#    dplyr::select(dist_bands, car, other, public_transport, bicycle, foot) %>%
#    tidyr::pivot_longer(cols = matches("car|other|publ|cy|foot"), names_to = "mode") %>%
#    mutate(mode = factor(mode, levels = c("car", "other", "public_transport", "bicycle", "foot"), ordered = TRUE)) %>%
#    group_by(dist_bands, mode) %>%
#    summarise(Trips = sum(value))
#  g2 = ggplot(active_results) +
#    geom_col(aes(dist_bands, Trips, fill = mode)) +
#    scale_fill_manual(values = col_modes) + ylab("Trips")
#  g2

## ---- echo=FALSE, eval=FALSE--------------------------------------------------
#  # % active under go active scenario
#  round(sum(routes_towns_recode$foot + routes_towns_recode$bicycle) / sum(routes_towns_recode_go_active$all) * 100)
#  round(sum(routes_towns_recode_go_active$foot + routes_towns_recode_go_active$bicycle) / sum(routes_towns_recode_go_active$all) * 100)
#  round(sum(routes_all_joined$foot + routes_all_joined$bicycle) / sum(routes_all_joined$all) * 100)
#  round(
#    sum(routes_towns_recode_go_active$car * routes_towns_recode_go_active$rf_dist_km) /
#      sum(routes_towns_recode$car * routes_towns_recode$rf_dist_km) * 100
#  )
#  round(
#    sum(routes_towns_recode_go_active$bicycle * routes_towns_recode_go_active$rf_dist_km) /
#      sum(routes_towns_recode$bicycle * routes_towns_recode$rf_dist_km) * 100
#  )
#  round(
#    sum(routes_towns_recode_go_active$foot * routes_towns_recode_go_active$rf_dist_km) /
#      sum(routes_towns_recode$foot * routes_towns_recode$rf_dist_km) * 100
#  )
#  

## ----shortcar, echo=FALSE, fig.cap="Illustration of route network based on car trips that could be replaced by bicycle trips, based on Census data on car trips to work and the Go Dutch uptake function used in the PCT.", message=FALSE, fig.show='hold', out.width="49%"----
#  rnet_shortcar = stplanr::overline(routes_towns_recode_go_active, "car_reduction")
#  plot(rnet_shortcar)
#  plot(rnet_all["dutch_slc"])

## -----------------------------------------------------------------------------
#  zones_york = zones_all_joined %>%
#    filter(lad_name == "York") %>%
#    mutate(pcycle = bicycle / all)
#  routes_york = routes_all %>%
#    filter(lad_name1 == "York") %>%
#    mutate(pcycle = bicycle / all)

## ----york, fig.cap="Zones in York with colours representing cycling mode share (left) and urban functional classification (right)", echo=FALSE, message=FALSE----
#  tm_shape(zones_york) +
#    tm_polygons(c("pcycle", "citytownclassification"), palette = list("-viridis", "Set3")) +
#    tm_shape(routes_york %>% filter(bicycle > 3)) + tm_lines()

## -----------------------------------------------------------------------------
#  pcycle_model_york = model_pcycle_pct_2020(
#    pcycle = routes_york$pcycle,
#    distance = routes_york$rq_dist_km,
#    gradient = routes_york$rf_avslope_perc,
#    weights = routes_york$all
#  )
#  summary(pcycle_model_york)

## -----------------------------------------------------------------------------
#  routes_all_renamed = routes_all %>%
#    rename(distance = rf_dist_km, gradient = rf_avslope_perc)
#  pcycle_go_york_model = boot::inv.logit(predict(pcycle_model_york, newdata = routes_all_renamed))
#  routes_all$york_slc = routes_all$all * pcycle_go_york_model
#  sum(routes_all$bicycle) / sum(routes_all$all)
#  sum(routes_all$govtarget_slc) / sum(routes_all$all)
#  sum(routes_all$dutch_slc) / sum(routes_all$all)
#  sum(routes_all$york_slc) / sum(routes_all$all)

## ---- message=FALSE, warning=FALSE, eval=FALSE, class.source=NULL-------------
#  # get pct rnet data for schools
#  rnet_school = get_pct_rnet(region = region_name, purpose = "school")
#  rnet_school = subset(rnet_school, select = -c(`cambridge_slc`)) # subset columns for bind
#  rnet_all = subset(rnet_all, select = -c(`ebike_slc`,`gendereq_slc`,`govnearmkt_slc`)) # subset columns for bind
#  
#  rnet_school_commute = rbind(rnet_all,rnet_school) # bind commute and schools rnet data
#  rnet_school_commute$duplicated_geometries = duplicated(rnet_school_commute$geometry) # find duplicated geometries
#  rnet_school_commute$geometry_txt = sf::st_as_text(rnet_school_commute$geometry)
#  
#  rnet_combined = rnet_school_commute %>%
#    group_by(geometry_txt) %>% # group by geometry
#    summarise(across(bicycle:dutch_slc, sum, na.rm = TRUE)) # and summaries route network which is not a duplicate

## ---- eval=FALSE, echo=FALSE--------------------------------------------------
#  brks = c(0, 10, 100, 1000, 5000)
#  tmap_arrange(nrow = 1,
#    tm_shape(rnet_all %>% arrange(dutch_slc)) + tm_lines("dutch_slc", palette = "-viridis", breaks = brks) + tm_layout(title = "Trips to work"),
#    tm_shape(rnet_school %>% arrange(dutch_slc)) + tm_lines("dutch_slc", palette = "-viridis", breaks = brks) + tm_layout(title = "Trips to school"),
#    tm_shape(rnet_combined %>% arrange(dutch_slc)) + tm_lines("dutch_slc", palette = "-viridis", breaks = brks) + tm_layout(title = "Trips to work and school")
#  )

## ----combined, fig.cap="Comparison of commute, school, and combined commute *and* school route networkworks, under the Go Dutch scenario.", fig.show='hold', out.width="100%", echo=FALSE----
#  # https://github.com/ITSLeeds/pct/issues/103#issuecomment-904990639
#  knitr::include_graphics("https://user-images.githubusercontent.com/1825120/130692688-65a958a9-8586-4196-982d-872d236becdb.png")

