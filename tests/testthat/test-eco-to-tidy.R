context("test specific values in dataframe")

library("dplyr")
library("ggplot2")
library("rbgm")

vol <- eco_to_tidy(system.file(package = "ecocat", "extdata/volume.nc"))

test_that("test this", {
  expect_equal(dim(vol), c(17638, 6))
})

# compare ecoham/atlantis/reality layout
lon_min <- -8
lon_max <- 15
lat_min <- 47
lat_max <- 63

surface_ecoham <- filter(vol, depth == 5) %>%
  filter(longitude > lon_min)



cm <- fortify(maps::map(database = "world", plot = FALSE, fill = T, xlim = c(lon_min, lon_max), ylim = c(lat_min, lat_max)))

ggplot(bgm_df, aes(x = long, y = lat)) +
  geom_polygon(data = cm, aes(group = group), colour = "black", fill = "grey") +
  geom_polygon(aes(group = polygon), fill = NA, colour = "black") +
  geom_point(data = surface_ecoham, aes(x = longitude, y = latitude), size = .5) +
  coord_map(xlim = c(lon_min, lon_max), ylim = c(lat_min, lat_max))


