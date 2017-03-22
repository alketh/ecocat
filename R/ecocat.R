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

  # Add Atlantis polygons based on nicemap and restrict ECOHAM to ATLANTIS area.
  eco_tidy <- dplyr::left_join(eco_tidy, nicemap, by = "ecoham_id") %>%
    dplyr::filter_(~!is.na(polygon))

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
    eco_tidy <- dplyr::mutate(eco_tidy, time = (time + 1) / 365)
    # eco_tidy$time <- (eco_tidy$time + 1) / 365
  }

  # Assign ATLANTIS layers based on ECOHAM grid layer and polygon combination. Create a dataframe
  # with unique polygon grid depth combinations to speed up calculations.
  poly_depth <- eco_tidy
  poly_depth <- dplyr::select_(poly_depth, ~depth, ~polygon)
  poly_depth <- unique(poly_depth)
  poly_depth <- depth_to_layer(poly_depth, nominal_dz = nominal_dz)

  # Add layer information and aggregate data!
  eco_tidy <- eco_tidy %>%
    dplyr::left_join(poly_depth, by = c("polygon", "depth")) %>%
    atlantistools::agg_data(data = ., col = "ecoham_out", groups = c("time", "polygon", "layer"), out = "ecoham_out", fun = mean)

  return(eco_tidy)
}
