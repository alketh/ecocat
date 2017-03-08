context("test depth to layer assignment")

# Theretically there are 9 potential combinations (3^2).
# 1. lo[1] > ld[1] & lo[2] > ld[2] --> partial match. dest shallower.
# 2. lo[1] < ld[1] & lo[2] > ld[2] --> full match. dest completly covered by orig.
# 3. lo[1] = ld[1] & lo[2] > ld[2] --> full match. origin deeper.
# 4. lo[1] > ld[1] & lo[2] < ld[2] --> full match. orig completly covered by dest.
# 5. lo[1] < ld[1] & lo[2] < ld[2] --> partial match. dest deeper.
# 6. lo[1] = ld[1] & lo[2] < ld[2] --> full match. dest deeper.
# 7. lo[1] > ld[1] & lo[2] = ld[2] --> full match. dest shallower.
# 8. lo[1] < ld[1] & lo[2] = ld[2] --> full match. dest deeper.
# 9. lo[1] = ld[1] & lo[2] = ld[2] --> full match.

test_that("test cases", {
  expect_equal(calc_overlap(c(10, 20), c(5, 15)), 0.5)  # case 1
  expect_equal(calc_overlap(c(10, 20), c(12, 15)), 1)   # case 2
  expect_equal(calc_overlap(c(10, 20), c(10, 15)), 1)   # case 3
  expect_equal(calc_overlap(c(10, 20), c(5, 25)), 1)    # case 4
  expect_equal(calc_overlap(c(10, 20), c(15, 25)), 0.5) # case 5
  expect_equal(calc_overlap(c(10, 20), c(10, 25)), 1)   # case 6
  expect_equal(calc_overlap(c(10, 20), c(5, 20)), 1)    # case 7
  expect_equal(calc_overlap(c(10, 20), c(15, 20)), 1)   # case 8
  expect_equal(calc_overlap(c(10, 20), c(10, 20)), 1)   # case 9
})

orig <- c(15, 25)
test <- purrr::map_dbl(purrr::map(seq(-10, 10), ~orig + .x), calc_overlap, lo = orig)

test_that("move layer through wc", {
  expect_equal(test, c(seq(0, 0.9, by = 0.1), 1, seq(0.9, 0, by = -0.1)))
})


head(nominal_dz_df)
head(poly_depth_df)

ndf <- tibble::tibble(polygon = 5, layer = 2:0, max_nominal_dz = c(20, 30, 40))
pdf1 <- tibble::tibble(depth = seq(0, 60, by = 3), polygon = 5)

pdf2 <- pdf1
pdf2$depth[pdf2$depth == 6] <- 5
pdf2 <- dplyr::filter(pdf2, depth >= 5)

pdf3 <- tibble::tibble(depth = c(5, 12, seq(15, 50, by = 3)), polygon = 5)
tdf <- depth_to_layer(pdf3, ndf)
# Visually inspect data!
tdf_ch <- tdf
tdf_ch$depth_min <- c(0,  10, cumsum(rep(c(4, 2), times = nrow(pdf3) / 2 - 1)) + 10)
tdf_ch$depth_max <- c(tdf_ch$depth_min[-1], 50)

test_that("layer assignment", {
  expect_error(depth_to_layer(pdf1, ndf), "Minimum depth is not equal to 5.")
  expect_error(depth_to_layer(pdf2, ndf), "Pls check mean depth in ecoham grid.")
  expect_equal(nrow(pdf3), nrow(tdf))
  expect_equal(ncol(pdf3) + 2, ncol(tdf))
  expect_equal(tdf$layer, c(rep(2, 4), rep(1, 4), rep(0, 3), rep(NA, 3)))
})

