#' Convert mean_depth from ECOHAM output to ATLANTIS layer id.
#'
#' @param poly_depth dataframe Unique combinations between ATLANTIS polygons and ECOHAM mean depths.
#' Layer assignment does not work in case the true mininum mean depth is not present here.
#' @param nominal_dz dataframe Tidy dataframe with columns polygon, layer, max_nominal_dz.
#' See \link{create-example-dfs.R} for further details.
#'
#' @return Dataframe.
#' @export
#'
#' @examples
#' nc <- system.file(package = "ecocat", "extdata/d1.nc")
#' df <- ecocat(nc)
#' df <- dplyr::select(df, depth, polygon)
#' df <- unique(df)
#' poly_depth <- df
#' polygon <- df$polygon
#' mean_depth <- df$depth
#' nominal_dz <- ecocat::nominal_dz_df

depth_to_layer <- function(poly_depth, nominal_dz) {
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

  pd <- dplyr::left_join(poly_depth, tibble::tibble(depth = depths, max_depth = depths_max, min_depth = depths_min), by = "depth")

  poly <- pd$polygon[1]
  mind <- pd$min_depth[1]
  maxd <- pd$max_depth[1]
  poly <- pd$polygon[1]
  mind <- 35
  maxd <- 70
  assign_layer <- function(poly, mind, maxd, nominal_dz) {
    mndz <- nominal_dz$max_nominal_dz[nominal_dz$polygon == poly]
    ol <- maxd - c(0, mndz[-length(mndz)])
  }
}

# Calculate overlap between vertical layers.
# This could be improved. Nonetheless, the code is super easy to debug!
set_overlap <- function(lo, ld) {
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

set_overlap(c(0, 10), c(8, 12))




