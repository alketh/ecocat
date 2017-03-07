library("atlantistools")
library("purrr")
library("tibble")
library("dplyr")
library("ggplot2")

# Convert bgm-file to tidy dataframe --------------------------------------------------------------
bgm_df <- convert_bgm(bgm = "inst/extdata/NorthSea.bgm") %>%
  as_tibble()

# Convert nicemap to tidy dataframe ---------------------------------------------------------------
nicemap <- readLines("inst/extdata/polygon-mask_ECOHAM.dat") %>%
  map(strsplit, split = "") %>%
  flatten()  # strsplit creates a list within a list...

d1 <- unique(map_dbl(nicemap, length))
d2 <- length(nicemap)

nicemap_df <- tibble(id_x = rep(1:d1, times = d2),
                     id_y = rep(1:d2, each = d1),
                     poly_code = unlist(nicemap))

nicemap_df$ecoham_id <- 1:nrow(nicemap_df)

# convert poly_code to polygon-ids
nicemap_df$poly_code[nicemap_df$poly_code == "0"] <- NA
nicemap_df$poly_code[nicemap_df$poly_code == "."] <- NA
pos <- !is.na(nicemap_df$poly_code)
nicemap_df <- add_column(nicemap_df, polygon = rep(NA, times = nrow(nicemap_df)))
nicemap_df$polygon[pos] <- map_int(nicemap_df$poly_code[pos], ~which(LETTERS %in% .x)) - 1

# add some simple tests
nicemap_df$poly_code[nicemap_df$id_x == 47 & nicemap_df$id_y == 42] == "J"
nicemap_df$poly_code[nicemap_df$id_x == 70 & nicemap_df$id_y == 49] == "N"
is.na(nicemap_df$poly_code[nicemap_df$id_x == 15 & nicemap_df$id_y == 72])

# Remove islands and boundary boxes from nicemap!
nicemap_df$polygon[nicemap_df$polygon %in% c(0, 16, 17, 23:25)] <- NA

# Extract ecoham box layout from volume.nc --------------------------------------------------------
# Create dataframe with ECOHAM boxes
nc_read <- RNetCDF::open.nc(con = system.file(package = "ecocat", "extdata/volume.nc"))

# Grid is not percect...
# plot(diff(RNetCDF::var.get.nc(nc_read, variable = "longitude")))
# plot(diff(RNetCDF::var.get.nc(nc_read, variable = "latitude")))

ecoham_layout <- expand.grid(RNetCDF::var.get.nc(nc_read, variable = "longitude"),
                             RNetCDF::var.get.nc(nc_read, variable = "latitude")) %>%
  as_tibble() %>%
  set_names(c("longitude", "latitude")) %>%
  mutate(ecoham_id = 1:nrow(.))

area <- RNetCDF::open.nc(con = system.file(package = "ecocat", "extdata/area.nc")) %>%
  RNetCDF::var.get.nc(ncfile = ., variable = "area") %>%
  as.vector()

ecoham_layout <- add_column(ecoham_layout, area = area)

ggplot(ecoham_layout, aes(x = longitude, y = latitude, col = area)) +
  geom_point()

# Convert Volume for each ecoham Grid and depth layer ---------------------------------------------
ref_vol <- eco_to_tidy("inst/extdata/volume.nc") %>%
  filter(time == 0) %>%
  select(depth, ecoham_out, ecoham_id) %>%
  unique()

# Create dataframe of nominal_dz values -----------------------------------------------------------
nominal_dz_df <- load_init(dir = "z:/Atlantis_models/baserun/", init = "init_NorthSea.nc", vars = "nominal_dz")[[1]] %>%
  filter(!(is.na(layer) | layer == 7)) %>%
  split(., .$polygon) %>%
  purrr::map(., ~arrange(., desc(layer))) %>%
  purrr::map_df(., ~dplyr::mutate(., max_nominal_dz = cumsum(atoutput))) %>%
  select(polygon, layer, max_nominal_dz) %>%
  as_tibble()

# Write files and cleanup -------------------------------------------------------------------------
devtools::use_data(bgm_df, nicemap_df, ecoham_layout, ref_vol, nominal_dz_df, overwrite = TRUE)

rm(list = ls())
