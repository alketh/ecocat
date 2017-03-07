#' Convert ECOHAM output to ATLANTIS output.
#'
#' Assign spatial output from ECOHAM simulation to ATLANTIS polygons.
#'
#' @inheritParams eco_to_tidy
#' @param nicemap dataframe of the nicemap.
#' @param nominal_dz dataframe cumulative water column thickness per ATLANTIS polygon and layer.
#' @return Dataframe.
#' @export
#'
#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' df <- ecocat(nc)
#'
#' nc <- system.file(package = "ecocat", "extdata/d1.nc")
#' df <- ecocat(nc)

ecocat <- function(nc, nicemap = ecocat::nicemap_df, nominal_dz = ecocat::nominal_dz_df) {
  # read in data and convert to tidy dataframe
  eco_tidy <- eco_to_tidy(nc = nc)

  # extract variable name and units
  unit <- extract_unit(nc = nc)

  # Convert from mmol to mg! By default variable is listed at the end.
  # Atomar mass of nitrogen = 14.0067 g/mol
  # from mmol to mol --> divide by 1000
  # from g to mg     --> multiply by 1000
  # Thus x [mmol] * 14.0067 [g/mol] / 1000 * 1000
  if (unit[length(unit)] == "mmolN m-3") {
    eco_tidy$ecoham_out <- eco_tidy$ecoham_out * 14.0067
  }

  # Check if time is given in days and convert to years!
  if (stringr::str_detect(unit["time"], pattern = "days")) {
    eco_tidy$time <- (eco_tidy$time + 1) / 365
  }

  # Convert mean depth to max depth! Iteratively calculate max depth per depth layer.
  depths <- sort(unique(eco_tidy$depth))
  for (i in seq_along(depths)) {
    if (i == 1) { # minimum of surface layer is 0 by default.
      depths_max <- vector(mode = "double", length = length(depths))
      depths_max[i] <- depths[i] * 2
    } else {
      depths_max[i] <- depths[i] * 2 - depths_max[i - 1]
    }
  }

  # Combine dataframes and convert output!
  atlantis_df <- dplyr::left_join(eco_tidy, nicemap, by = "ecoham_id") %>%
    dplyr::filter_(~!is.na(polygon)) %>%
    dplyr::left_join(tibble::tibble(depth = depths, max_depth = depths_max), by = "depth") %>%
    atlantistools::agg_data(data = ., col = "ecoham_out", groups = c("time", "polygon"), out = "ecoham_out", fun = mean)

  return(atlantis_df)
}
