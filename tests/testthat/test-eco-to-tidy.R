context("test specific values in dataframe")

vol <- eco_to_tidy(system.file("extdata/volume.nc", package = "ecocat"))

test_that("test this", {
  expect_equal(dim(vol), c(17638, 4))
})

# compare ecoham/atlantis/reality layout.
# Can only be used interactively.
# lon_min <- -8
# lon_max <- 15
# lat_min <- 47
# lat_max <- 63
#
# surface_ecoham <- dplyr::filter(vol, depth == 5) %>%
#   dplyr::filter(longitude > lon_min)
#
# cm <- ggplot2::fortify(maps::map(database = "world", plot = FALSE, fill = T, xlim = c(lon_min, lon_max), ylim = c(lat_min, lat_max)))
#
# ggplo2::ggplot(bgm_df, ggplo2::aes(x = long, y = lat)) +
#   ggplo2::geom_polygon(data = cm, ggplo2::aes(group = group), colour = "black", fill = "grey") +
#   ggplo2::geom_polygon(ggplo2::aes(group = polygon), fill = NA, colour = "black") +
#   ggplo2::geom_point(data = surface_ecoham, ggplo2::aes(x = longitude, y = latitude), size = .5) +
#   ggplo2::coord_map(xlim = c(lon_min, lon_max), ylim = c(lat_min, lat_max))
#
# data(world2HiresMapEnv)

# # Visually inspect ECOHAM output
# nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc"
#
# raw <- eco_to_tidy(nc)
#
# # select initial time and surface plot ecohamid and compare with layout
# wuwu <- dplyr::filter(raw, time == 0 & depth == 5)
#
# ggplot2::ggplot(wuwu, ggplot2::aes(x = longitude, y = latitude, label = ecoham_id)) +
#   ggplot2::geom_text(size = 2)
#
# ggplot2::ggplot(ecoham_layout, ggplot2::aes(x = longitude, y = latitude, label = ecoham_id)) +
#   ggplot2::geom_text(size = 2)
#
# # select different time steps and plot maximum depth.
# wuwu <- dplyr::filter(raw, time == 0) %>%
#   atlantistools::agg_data(col = "depth", groups = c("longitude", "latitude"), data = ., out = "depth", fun = max)
#
# ggplot2::ggplot(wuwu, ggplot2::aes(x = longitude, y = latitude, fill = depth)) +
#   ggplot2::geom_tile()
#
# wuwu <- dplyr::filter(raw, time == 21) %>%
#   atlantistools::agg_data(col = "depth", groups = c("longitude", "latitude"), data = ., out = "depth", fun = max)
#
# ggplot2::ggplot(wuwu, ggplot2::aes(x = longitude, y = latitude, fill = depth)) +
#   ggplot2::geom_tile()
#
# # Plot Surface volume at time 50.
# wuwu <- dplyr::filter(raw, time == 52 & depth == 17.5)
#
# ggplot2::ggplot(wuwu, ggplot2::aes(x = longitude, y = latitude, fill = ecoham_out)) +
#   ggplot2::geom_tile()

