# pct 0.4.0

- Read `.geojson` files directly rather than downloading old `.Rds` files that were generating error messages - see https://github.com/ITSLeeds/pct/issues/57
- Do not test time-consuming tests on CRAN as per #58

# pct 0.3.0

- Always returns objects with EPSG code 4326, see https://github.com/ropensci/stats19/issues/135

# pct 0.2.7

- Improved documentation for godutch uptake function
- Uptake function now work when there are NAs in the distances (previously they generated errors)

# pct 0.2.5

- Fixed issue due to government data provider endpoint being down: https://github.com/ITSLeeds/pct/issues/51

# pct 0.2.4

- Updated vignettes use `tmap` instead of leaflet for easy-to-type map making code

# pct 0.2.3

- Remove OD pairs with no matching IDs, see https://github.com/ITSLeeds/pct/issues/47

# pct 0.2.2

- Updated training materials
- Fixed bug in `get_od()`

# pct 0.2.1

- `get_od()` now gets national data by default

# pct 0.2.0

- Updates to allow od data to be downloaded for `pct_regions`: see https://github.com/ITSLeeds/pct/issues/44

# pct 0.1.3

- Fix issue with `rnet` downloads - see https://github.com/ITSLeeds/pct/issues/45

# pct 0.1.2

- Bug fix: `get_pct_centroids()` and `get_pct_zones()` now work as intended
- Minor updates to vignettes

# pct 0.1.1
- Minor CRAN doi

# pct 0.1.0
* First release.
