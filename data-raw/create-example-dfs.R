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

nicemap_df$ecoham_id <- 1:nrow(nicemap_df)

# convert poly_code to polygon-ids
nicemap_df$poly_code[nicemap_df$poly_code == "0"] <- NA
nicemap_df$poly_code[nicemap_df$poly_code == "."] <- NA
pos <- !is.na(nicemap_df$poly_code)
nicemap_df <- add_column(nicemap_df, polygon = rep(NA, times = nrow(nicemap_df)))
nicemap_df$polygon[pos] <- map_int(nicemap_df$poly_code[pos], ~which(LETTERS %in% .x)) - 1

# add some simple tests
nicemap_df$poly_code[nicemap_df$id_x == 47 & nicemap_df$id_y == 42] == "J"
nicemap_df$poly_code[nicemap_df$id_x == 70 & nicemap_df$id_y == 49] == "N"
is.na(nicemap_df$poly_code[nicemap_df$id_x == 15 & nicemap_df$id_y == 72])

devtools::use_data(bgm_df, nicemap_df, overwrite = TRUE)

rm(list = ls())
