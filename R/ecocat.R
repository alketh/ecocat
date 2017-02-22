#' Convert ECOHAM output to ATLANTIS output.
#'
#' Assign spatial output from ECOHAM simulation to ATLANTIS polygons.
#'
#' @param eco_out dataframe generated with \link{eco-to-tidy}.
#' @param col column to convert from ecoham output to atlantis output.
#' @param nicemap_df dataframe of the nicemap.
#' @return Dataframe.
#' @export
#'
#' @examples
#' eco_out <- ref_vol
#' ecocat(ref_vol, col = "vol", nicemap_df)

ecocat <- function(eco_out, col, nicemap_df) {
  wuwu <- dplyr::left_join(eco_out, nicemap_df, by = "ecoham_id") %>%
    dplyr::filter_(~!is.na(polygon)) %>%
    atlantistools::agg_data(data = ., col = col, groups = c("time", "polygon"), out = col, fun = mean)

  return(wuwu)
}
