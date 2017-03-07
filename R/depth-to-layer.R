#' Convert mean_depth from ECOHAM output to ATLANTIS layer id.
#'
#' @param polygon int Vector of ATLANTIS polygon id.
#' @param mean_depth num Vector of ECOHAM mean depth.
#' @param nominal_dz dataframe Tidy dataframe with columns polygon, layer, max_nominal_dz.
#' See \link{create-example-dfs.R} for further details.
#'
#' @return Dataframe.
#' @export
#'
#' @examples
#' polygon <- c(12, 15)
#' mean_depth <- c(5, 12.5)
#' nominal_dz <- ecocat::nominal_dz_df

depth_to_layer <- function(polygon, mean_depth, nominal_dz) {

}
