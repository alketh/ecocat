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
