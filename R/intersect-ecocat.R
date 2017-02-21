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

# Please note that the area calculations and flux calculations (exchange.nc) are based on the
# ECOHAM nicemap. Thus it doesn't make sense to sptially overlap the ATLANTIS Polygons
# with the ECOHAM grid because the exchange is based on the nicemap grid-->polygon assignment
# and is NOT based on the actual spatial overlap. The function is very precise, however
# as the input itself is based on a coarser comparing with the actual overlap wouldn't make
# the comparison more right but potentially more wrong.

intersect_ecocat <- function(atlantis_bgm, ecoham_layout) {
  # this is heavily inspired by https://github.com/alketh/ecocat/issues/1
  # Thanks to Micheal Sumner!
  # convert bgm to SpatialPolygonsDataFrame
  atlantis_spdf <- rbgm::bgmfile(x = atlantis_bgm) %>%
    rbgm::boxSpatial(bgm = .)

  # convert ecoham layout to SpatialPolygonsDataFrame
  # grid is not perfectly regular, use projection from bgm file.
  ecoham_spdf <- raster::rasterFromXYZ(xyz = ecoham_layout, digits = 3) %>%
    raster::rasterToPolygons(x = .)
  # hard code reference system and projection into raster object. Use bgm projection.
  raster::projection(ecoham_spdf) <- sp::CRS("+init=epsg:4326")
  ecoham_spdf <- sp::spTransform(ecoham_spdf, raster::projection(atlantis_spdf))

  # Calculate spatial overlap between polygons and grid cells.
  overlap <- raster::intersect(atlantis_spdf, ecoham_spdf)

  # WOW this data structure is pure cancer...
  area <- overlap[, 1]@polygons %>%
    purrr::map(~.@Polygons) %>%
    purrr::flatten(.x = .) %>%
    purrr::map_dbl(~.@area)

  # All we need is ecoham_id, polygon and area
  overlap_area <- tibble::tibble(id = 1:nrow(overlap),
                                 ecoham_id = overlap$ecoham_id,
                                 polygon = overlap$box_id,
                                 area = area) %>%
    dplyr::left_join(ecoham_layout, by = "ecoham_id") %>%
  # Calculate % of intersected area within each ecoham grid cell and atlantis polygon.
    dplyr::group_by_(~ecoham_id) %>%
    dplyr::mutate_(wf_area = ~area.x/area.y)
  # normalise to 1.

  # Visually inspect the result!
  # df <- broom::tidy(overlap) %>%
  #   dplyr::mutate(id = as.numeric(id)) %>%
  #   dplyr::left_join(overlap_area, by = "id")
  #
  # ggplot2::ggplot(df, ggplot2::aes(x = long, y = lat, group = group, fill = area.y)) +
  #   ggplot2::geom_polygon()
  #
  return(overlap_area)
}




