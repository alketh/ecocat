context("test area calculations")

library("ggplot2")
library("dplyr")
library("purrr")

atlantis_bgm <- system.file(package = "ecocat", "extdata/NorthSea.bgm")
overlap <- intersect_ecocat(atlantis_bgm, ecoham_layout)


# Compare area of intersected polygons with ecoham area!
check_area <- overlap_area %>%
  dplyr::group_by_(~ecoham_id) %>%
  dplyr::summarise_(area_intersect = ~sum(area)) %>%
  dplyr::left_join(ecoham_layout, by = "ecoham_id") %>%
  dplyr::filter_(~!is.na(area)) %>%
  dplyr::mutate(check = area/area_intersect) %>%
  dplyr::mutate(border = ifelse(abs(check - 1) > 0.01, 1, 0))

ggplot(check_area, aes(x = longitude, y = latitude, colour = factor(border))) +
  geom_point()

test <- dplyr::filter(check_area, border == 0)

test_that("test this", {
  expect_equal(nrow(test), 1449)
})


# PERFECT! rel diff between area calculations generally < 0.1%.
# Only corner areas are significantly different due to the fact that the overlapping
# grid area is removed during the intersect!
# NOTE: Test does only work with visual inspection!

# compare area calculations in ATLANTIS and ECOHAM
area_at <- rbgm::bgmfile(system.file(package = "ecocat", "extdata/NorthSea.bgm"))
area_at <- area_at$boxes %>%
  select(area, polygon = contains("bx0"))

area_eco <- overlap %>%
  group_by(polygon) %>%
  summarise(area = sum(area.x))

comp_area <- left_join(area_at, area_eco, by = "polygon") %>%
  set_names(c("area_atlantis", "polygon", "area_ecoham")) %>%
  mutate(at_div_eco = area_atlantis/area_ecoham)
