#' Calculate overlap between ecoham boxes and atlantis polygons.
#'
#' @param atlantis_bgm bgm file of the ATLANTIS model.
#' @param ecoham_layout dataframe of the ECOHAM layout.
#'
#' @return Dataframe
#' @export
#'
#' @examples
#' atlantis_bgm <- system.file(package = "ecocat", "extdata/NorthSea.bgm")
#' overlap <- intersect_ecocat(atlantis_bgm, ecoham_layout)
#'
#' test <- raster::intersect(atlantis_df, ecoham_df)
intersect_ecocat <- function(atlantis_bgm, ecoham_layout) {
  # this is heavily inspired by https://github.com/alketh/ecocat/issues/1
  # Thanks to Micheal Sumner!
  # convert bgm to SpatialPolygonsDataFrame
  atlantis_spdf <- rbgm::bgmfile(x = atlantis_bgm) %>%
    rbgm::boxSpatial()

  # convert ecoham layout to SpatialPolygonsDataFrame
  # grid is not perfectly regular, use projection from bgm file.
  ecoham_spdf <- raster::rasterFromXYZ(xyz = ecoham_layout, digits = 3) %>%
    raster::rasterToPolygons()
  # hard code reference system and projection into raster object. Use bgm projection.
  raster::projection(ecoham_spdf) <- sp::CRS("+init=epsg:4326")
  ecoham_spdf <- sp::spTransform(ecoham_spdf, raster::projection(atlantis_spdf))

  # Calculate spatial overlap between polygons and grid cells.
  overlap <- raster::intersect(atlantis_spdf, ecoham_spdf)

  # WOW this data structure is pure cancer...
  area <- overlap[, 1]@polygons %>%
    purrr::map(~.@Polygons) %>%
    purrr::flatten() %>%
    purrr::map_dbl(~.@area)

  # All we need is ecoham_id, polygon and area
  overlap_area <- tibble::tibble(id = 1:nrow(overlap),
                                 ecoham_id = overlap$ecoham_id,
                                 polygon = overlap$box_id,
                                 area = area)

  ggplot2::ggplot(df, ggplot2::aes(x = long, y = lat, group = group, colour = cols)) +
    ggplot2::geom_polygon()

  ggplot2::ggplot(df, ggplot2::aes(x = long, y = lat, group = group, colour = cols)) +
    ggplot2::geom_polygon()
}

# # method 1
# atlantis_df <- rbgm::bgmfile(x = system.file(package = "ecocat", "extdata/NorthSea.bgm")) %>%
#   rbgm::boxSpatial()
#
# ecoham_df <- raster::rasterFromXYZ(xyz = ecoham_layout, digits = 3) %>%
#   raster::rasterToPolygons()
#
# raster::projection(ecoham_df) <- sp::CRS("+init=epsg:4326")
#
# ecoham_df <- sp::spTransform(ecoham_df, raster::projection(atlantis_df))
#
# raster::intersect(atlantis_df, ecoham_df)
#
# # method 2
# atlantis_df <- rbgm::bgmfile(x = system.file(package = "ecocat", "extdata/NorthSea.bgm")) %>%
#   rbgm::boxSpatial()
# ecoham_df <- raster::raster(system.file(package = "ecocat", "extdata/volume.nc")) %>%
#   raster::rasterToPolygons() %>%
#   sp::spTransform(raster::projection(atlantis_df))
#
# raster::intersect(atlantis_df, ecoham_df)


