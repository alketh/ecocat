#' Convert netcdf output from ECOHAM simulation to tidy dataframe.
#'
#' Read in netcdf output array from ECOHAM simulation and convert it to a tidy dataframe to allow
#' coupling with atlantistools.
#'
#' @param nc connection to the netcdf file to read in.
#' @return tidy dataframe with columns longitude, latitude, depth, time, variable-name, ecohambox-id.
#' @export
#'
#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' vol <- eco_to_tidy(nc)

# nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc"
# nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.z2n.nc"
# volume <- eco_to_tidy("z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc")

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
  c6 <- rep(1:(d[1] * d[2]), times = d[3] * d[4])

  # Combine to tibble and remove missing values.
  ecodf <- tibble::tibble(c1, c2, c3, c4, c5 = as.vector(ar), c6)
  ecodf <- purrr::set_names(ecodf, c(variables[-length(variables)], "ecoham_out", "ecoham_id"))
  ecodf <- dplyr::filter_(ecodf, ~!is.na(ecoham_out))
  ecodf$longitude <- NULL
  ecodf$latitude <- NULL

  return(ecodf)
}

# df <- vol %>%
#   dplyr::filter(depth == 5 & time == 0) %>%
#   ggplot2::ggplot(ggplot2::aes(x = longitude, y = latitude, label = id)) +
#   ggplot2::geom_text(size = 2)

