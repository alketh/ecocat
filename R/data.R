#' bgm_df
#'
#' bgm file converted to tidy dataframe.
#'
#' @format A data frame with 324 rows and 5 variables:
#' \describe{
#'   \item{\code{lat}}{double. Latitude}
#'   \item{\code{long}}{double. Longitude}
#'   \item{\code{inside_lat}}{double. Latitude of ("mid"-) point inside the polygon.}
#'   \item{\code{inside_long}}{double. Longitude of ("mid"-) point inside the polygon.}
#'   \item{\code{polygon}}{double. Polygonid.}
#' }
"bgm_df"

#' nicemap_df
#'
#' nicemap converted to tidy dataframe.
#'
#' @format A data frame with 7216 rows and 3 variables:
#' \describe{
#'   \item{\code{id_x}}{integer. Horizontal position of the potential ECOHAM box.}
#'   \item{\code{id_y}}{integer. Vertical position of the potential ECOHAM box.}
#'   \item{\code{poly_code}}{character. Value of the box code.}
#'   \item{\code{ecoham_id}}{integer. ECOHAM box id.}
#'   \item{\code{polygon}}{double. ATLANTIS polygon id.}
#' }
"nicemap_df"

#' ecoham_layout
#'
#' mid points in latitude and longitude for each ecoham box.
#'
#' @format A data frame with 7216 rows and 3 variables:
#' \describe{
#'   \item{\code{longitude}}{double. longitude.}
#'   \item{\code{latitude}}{double. latitude.}
#'   \item{\code{ecoham_id}}{integer. ECOHAM box id.}
#' }
"ecoham_layout"

#' Reference dataframe for volume per ecoham grid.
#'
#' Volume in m^3 for each ECOHAM grid and depth layer.
#'
#' @format A data frame with 17638 rows and 6 variables:
#' \describe{
#'   \item{\code{longitude}}{double. longitude:units = "degrees_east".}
#'   \item{\code{latitude}}{double. latitude:units = "degrees_north".}
#'   \item{\code{depth}}{double. depth:units = "meters".}
#'   \item{\code{time}}{double. time:units = "days since 2000-1-1 00:00:00".}
#'   \item{\code{vol}}{double. vol:units = "m3".}
#'   \item{\code{ecoham_id}}{integer. grid cell.}
#' }
"ref_vol"
