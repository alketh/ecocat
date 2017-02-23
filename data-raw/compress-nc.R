# DO NOT RUN THIS (unless you know what you are doing)!

# Compress ECOHAM output down to 2 depth layers and 2 timesteps.

nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.d1n.nc"
nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc"

nc_read <- RNetCDF::open.nc(nc)

nc_inq <- RNetCDF::file.inq.nc(nc_read)
# nvars <- RNetCDF::file.inq.nc(nc_read)$nvars

nc_detail <- purrr::map(0:(nc_inq$nvars - 1), ~RNetCDF::var.inq.nc(ncfile = nc_read, variable = .x))

variables <- purrr::map_chr(nc_detail, "name")

v1 <- RNetCDF::var.get.nc(nc_read, variable = variables[5], na.mode = 0)

v_test <- v1[, , 1:2, 1:2]
v_string <- vector(mode = "list", length = prod(dim(v_test)[2:4]))
for (k in 1:dim(v_test)[4]) {
  for (j in 1:dim(v_test)[3]) {
    for (i in 1:dim(v_test)[2]) {
      if (i == 1 && j == 1 && k == 1) l <- 1
      v_string[[l]] <- paste(v_test[, i, j, k], collapse = ",")
      l <- l + 1
    }
  }
}

v_string <- purrr::map_chr(v_string, paste0, ",")

purrr::walk(v_string, cat, file = "test_d1.cdf", sep = "\n", append = T)

# very messy postprocessing needed afterwards
# 1. Change NA to "_"
# 2. Copy to cdf skeleton.
# 3. Update "VARNAME" with associated unit
# 4. Convert to netcdf with ncgen
# 5. Check netcdf structure with ncdump

