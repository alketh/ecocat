#' Convert mean_depth from ECOHAM output to ATLANTIS layer id.
#'
#' @param poly_depth dataframe Unique combinations of ATLANTIS polygons and ECOHAM depth layers.
#' Layer assignment does not work in case the true mininum depth is not present.
#' See \code{\link{poly_depth_df}} for further details.
#' @param nominal_dz dataframe Tidy dataframe with columns polygon, layer, max_nominal_dz.
#' See \code{\link{nominal_dz_df}} for further details.
#'
#' @return Dataframe.
#' @export
#'
#' @examples
#' poly_depth <- ecocat::poly_depth_df
#' nominal_dz <- ecocat::nominal_dz_df
#' head(depth_to_layer(poly_depth, nominal_dz))

depth_to_layer <- function(poly_depth = ecocat::poly_depth_df, nominal_dz = ecocat::nominal_dz_df) {
  # Add max and min depth! Iteratively calculate max depth per depth layer.
  depths <- sort(unique(poly_depth$depth))
  if (depths[1] != 5) stop("Minimum depth is not equal to 5.")
  for (i in seq_along(depths)) {
    if (i == 1) { # minimum of surface layer is 0 by default.
      depths_max <- vector(mode = "double", length = length(depths))
      depths_max[i] <- depths[i] * 2
    } else {
      depths_max[i] <- depths[i] * 2 - depths_max[i - 1]
    }
  }
  depths_min <- c(0, depths_max[-length(depths_max)])

  if (any(depths_min >= depths_max)) stop("Pls check mean depth in ecoham grid. Min depth > max depth in some cells.")

  pd <- dplyr::left_join(poly_depth, tibble::tibble(depth = depths, max_depth = depths_max, min_depth = depths_min), by = "depth")

  # poly <- pd$polygon[13]
  # mind <- pd$min_depth[13]
  # maxd <- pd$max_depth[13]
  # assign layer with the best overlap ratio to a single row in pd!
  assign_layer <- function(poly, mind, maxd, nominal_dz) {
    # extract layer margins in specific polygon.
    select_ndz <- nominal_dz[nominal_dz$polygon == poly, ]
    maxndz <- select_ndz$max_nominal_dz
    minndz <- c(0, maxndz[-length(maxndz)])
    ndz <- purrr::map2(minndz, maxndz, c)
    # apply calc_overlap function to each layer combination.
    # thus the single layer from pd matched with all layers in the polygon.
    layer_ol <- purrr::map_dbl(ndz, calc_overlap, ld = c(mind, maxd))
    # select the layer with the best overlap. In case of equal overlap use layer closer to surface.
    layer_id <- which(abs(layer_ol - 1) == min(abs(layer_ol - 1)))
    # Add NA in case of missing overlap.
    if (all(layer_ol == 0)) {
      res <- c(NA, 0)
    } else {
      if (length(layer_id) == 2) layer_id <- layer_id[1]
      res <- c(select_ndz$layer[layer_id], layer_ol[layer_id])
    }

    names(res) <- c("layer", "overlap")
    return(res)
  }

  # Apply layer assignment to each polygon/layer-depth combination!
  lol <- purrr::pmap(list(pd$polygon, pd$min_depth, pd$max_depth), assign_layer, nominal_dz = nominal_dz) %>%
    do.call(args = ., rbind) %>%
    tibble::as_tibble()
  pd <- dplyr::bind_cols(pd, lol)

  # cleanup
  pd$max_depth <- NULL
  pd$min_depth <- NULL

  return(pd)
}

# Calculate overlap between vertical layers.
# This could be improved. Nonetheless, the code is super easy to debug!
calc_overlap <- function(lo, ld) {
  if (any(c(length(ld), length(lo)) != 2)) stop("Length of lo and ld has to be 2.")
  # Theretically there are 9 potential combinations (3^2).
  # See "test-depth-to-layer.R" for further details.
  diff_dest <- (ld[2] - ld[1])
  if (lo[1] > ld[1] & lo[2] > ld[2]) { # case 1.
    if (lo[1] < ld[2] & lo[2] > ld[1]) { # add exceptions for partial
      result <- (ld[2] - lo[1]) / diff_dest
    } else {
      result <- 0
    }
  }
  if (lo[1] >= ld[1] & lo[2] <= ld[2]) { # case 4. 6. 7. & 9.
    result <- 1
  }

  if (lo[1] <= ld[1] & lo[2] >= ld[2]) { # case 2. 3. 8. & 9.
    result <- (ld[2] - ld[1]) / diff_dest
  }
  if (lo[1] < ld[1] & lo[2] < ld[2]) { # case 5.
    if (lo[1] < ld[2] & lo[2] > ld[1]) { # add exceptions for partial
      result <- (lo[2] - ld[1]) / diff_dest
    } else {
      result <- 0
    }
  }

  return(result)
}


