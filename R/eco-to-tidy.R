#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")

eco_to_tidy <- function(nc) {
  nc_read <- RNetCDF::open.nc(con = nc)
  on.exit(RNetCDF::close.nc(nc_read))

  nc_inq <- RNetCDF::file.inq.nc(nc_read)
  nc_detail <- purrr::map(0:(nc_inq$nvars - 1), ~RNetCDF::var.inq.nc(.x, ncfile = nc_read))

  variables <- purrr::map_chr(nc_detail, "name")

  # by default last variable in netcdf file is extracted!
  ar <- RNetCDF::var.get.nc(nc_read, variable = variables[length(variables)], na.mode = 0)

  # Order of dimension in array is
  # 1. Longitude
  # 2. Latitude
  # 3. Depth
  # 4. Time

}
