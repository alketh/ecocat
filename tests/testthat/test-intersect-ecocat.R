context("test area calculations")

atlantis_bgm <- system.file(package = "ecocat", "extdata/NorthSea.bgm")
overlap <- intersect_ecocat(atlantis_bgm, ecoham_layout)

# Compare area of intersected polygons with ecoham area!
check_area <- overlap %>%
  dplyr::group_by_(~ecoham_id) %>%
  dplyr::summarise_(area_intersect = ~sum(area.x)) %>%
  dplyr::left_join(ecoham_layout, by = "ecoham_id") %>%
  dplyr::filter_(~!is.na(area)) %>%
  dplyr::mutate(check = area/area_intersect) %>%
  dplyr::mutate(border = ifelse(abs(check - 1) > 0.01, 1, 0))

ggplot2::ggplot(check_area, ggplot2::aes(x = longitude, y = latitude, colour = factor(border))) +
  ggplot2::geom_point()

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
  dplyr::select(area, polygon = dplyr::contains("bx0"))

area_eco <- overlap %>%
  dplyr::group_by(polygon) %>%
  dplyr::summarise(area = sum(area.x))

comp_area <- dplyr::left_join(area_at, area_eco, by = "polygon") %>%
  purrr::set_names(x = ., c("area_atlantis", "polygon", "area_ecoham")) %>%
  dplyr::mutate(at_div_eco = area_atlantis/area_ecoham)
