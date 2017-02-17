#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' volume <- eco_to_tidy(nc)
#'
#' volume <- eco_to_tidy("z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc")

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
  d <- dim(ar)

  # create columns (vectorised) with netcdf variable values.
  vars_new <- purrr::map(variables[-length(variables)], RNetCDF::var.get.nc, ncfile = nc_read)
  c1 <- rep(rep(rep(vars_new[[1]], times = d[2]), times = d[3]), times = d[4])
  c2 <- rep(rep(rep(vars_new[[2]], each = d[1]), times = d[3]), times = d[4])
  c3 <- rep(rep(vars_new[[3]], each = d[1] * d[2]), times = d[4])
  c4 <- rep(vars_new[[4]], each = d[1] * d[2] * d[3])

  # Combine to tibble and remove missing values.
  ecodf <- tibble::tibble(c1, c2, c3, c4, c5 = as.vector(ar)) %>%
    dplyr::filter_(~!is.na(c5)) %>%
    purrr::set_names(variables)

  return(ecodf)
}


