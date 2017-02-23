#' Convert ECOHAM output to ATLANTIS output.
#'
#' Assign spatial output from ECOHAM simulation to ATLANTIS polygons.
#'
#' @inheritParams eco_to_tidy
#' @param nicemap dataframe of the nicemap.
#' @return Dataframe.
#' @export
#'
#' @examples
#' nc <- system.file(package = "ecocat", "extdata/volume.nc")
#' df <- ecocat(nc)
#'
#' nc <- system.file(package = "ecocat", "extdata/d1.nc")
#' df <- ecocat(nc)

ecocat <- function(nc, nicemap = ecocat::nicemap_df) {
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

  atlantis_df <- dplyr::left_join(eco_tidy, nicemap, by = "ecoham_id") %>%
    dplyr::filter_(~!is.na(polygon)) %>%
    atlantistools::agg_data(data = ., col = "ecoham_out", groups = c("time", "polygon"), out = "ecoham_out", fun = mean)

  return(atlantis_df)
}
