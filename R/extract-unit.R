#' Extract units for each variable in a netcdf file
#'
#' Extract units for each variable in a netcdf file
#'
#' @inheritParams eco_to_tidy
#' @param attribute either a character string of the name of the attribute (deault = "units") or the
#' attribute id (starting at 0).
#' @export

#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' extract_unit(nc)

extract_unit <- function(nc, attribute = "units") {
  nc_read <- RNetCDF::open.nc(con = nc)
  on.exit(RNetCDF::close.nc(nc_read))

  nc_inq <- RNetCDF::file.inq.nc(nc_read)

  # Exract units from netcdf file!
  units <- purrr::map_chr(0:(nc_inq$nvars - 1), ~RNetCDF::att.get.nc(.x, ncfile = nc_read, attribute = attribute))

  variables <- purrr::map(0:(nc_inq$nvars - 1), ~RNetCDF::var.inq.nc(.x, ncfile = nc_read)) %>%
    purrr::map_chr(., "name")

  units <- purrr::set_names(units, variables)

  return(units)
}
