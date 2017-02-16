library("atlantistools")
library("purrr")
library("tibble")

bgm_df <- convert_bgm(bgm = "inst/extdata/NorthSea.bgm")

nicemap <- readLines("inst/extdata/polygon-mask_ECOHAM.dat") %>%
  map(strsplit, split = "") %>%
  flatten()  # strsplit creates a list within a list...

d1 <- unique(map_dbl(nicemap, length))
d2 <- length(nicemap)

nicemap_df <- tibble(id_x = rep(1:d1, times = d2),
                     id_y = rep(1:d2, each = d1),
                     poly_code = unlist(nicemap))

# add some simple tests
nicemap_df$poly_code[nicemap_df$id_x == 47 & nicemap_df$id_y == 42] == "J"
nicemap_df$poly_code[nicemap_df$id_x == 70 & nicemap_df$id_y == 49] == "N"
nicemap_df$poly_code[nicemap_df$id_x == 15 & nicemap_df$id_y == 72] == "0"

devtools::use_data(bgm_df, nicemap_df, overwrite = TRUE)
