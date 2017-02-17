# DO NOT RUN THIS!

library("purrr")

nc <- "z:/my_data_alex/Markus/ECOHAM_B057/B057-D4_3D.2000.vol.nc"
nc_read <- RNetCDF::open.nc(nc)

nc_inq <- RNetCDF::file.inq.nc(nc_read)
nvars <- RNetCDF::file.inq.nc(nc_read)$nvars

nc_detail <- map(0:(nc_inq$nvars - 1), ~RNetCDF::var.inq.nc(.x, ncfile = nc_read))

variables <- map_chr(nc_detail, "name")

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

v_string <- map_chr(v_string, paste0, ",")

# walk(v_string, cat, file = "test.cdf", sep = "\n", append = T)

# very messy postprocessing needed afterwards
# 1. Change NA to "_"
# 2. Convert to netcdf with ncgen
# 3. Check netcdf structure with ncdump
# 4. Rename final file to volume.nc
