context("test depth to layer assignment")

library("purrr")

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
test <- map_dbl(map(seq(-10, 10), ~orig + .x), calc_overlap, lo = orig)

test_that("move layer through wc", {
  expect_equal(test, c(seq(0, 0.9, by = 0.1), 1, seq(0.9, 0, by = -0.1)))
})


