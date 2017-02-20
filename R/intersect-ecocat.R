#' Calculate overlap between ecoham boxes and atlantis polygons.
#'
#' @param atlantis_bgm bgm file of the ATLANTIS model.
#' @param ecoham_layout any netcdf file of ECOHAM grid.
#'
#' @return Dataframe
#' @export
#'
#' @examples
#' atlantis_bgm <- system.file(package = "ecocat", "extdata/NorthSea.bgm")
#' ecoham_nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' atlantis_df <- rbgm::bgmfile(x = ) %>%
#'   rbgm::boxSpatial()
#'
#' ecoham_df <- raster::rasterFromXYZ(xyz = ecoham_layout, digits = 3) %>%
#'   raster::rasterToPolygons()
#' raster::projection(ecoham_df) <- sp::CRS("+init=epsg:4326")
#'   sp::spTransform(raster::projection(atlantis_df))
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
  # hard code projection into raster object
  raster::projection(ecoham_spdf) <- sp::CRS("+init=epsg:4326")

  # Calculate spatial overlap between polygons and grid cells.
  overlap <- raster::intersect(atlantis_spdf, ecoham_spdf)

}

# method 1
atlantis_df <- rbgm::bgmfile(x = system.file(package = "ecocat", "extdata/NorthSea.bgm")) %>%
  rbgm::boxSpatial()

ecoham_df <- raster::rasterFromXYZ(xyz = ecoham_layout, digits = 3) %>%
  raster::rasterToPolygons()

raster::projection(ecoham_df) <- sp::CRS("+init=epsg:4326")

ecoham_df <- sp::spTransform(ecoham_df, raster::projection(atlantis_df))

intersect(atlantis_df, ecoham_df)

# method 2
atlantis_df <- rbgm::bgmfile(x = system.file(package = "ecocat", "extdata/NorthSea.bgm")) %>%
  rbgm::boxSpatial()
ecoham_df <-  raster(system.file(package = "ecocat", "extdata/volume.nc")) %>%
  raster::rasterToPolygons() %>% spTransform(projection(atlantis_df))

raster::intersect(atlantis_df, ecoham_df)
