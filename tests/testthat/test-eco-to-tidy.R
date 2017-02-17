context("test specific values in dataframe")

vol <- eco_to_tidy(system.file(package = "ecocat", "extdata/volume.nc"))

test_that("test this", {
  expect_equal(dim(vol), c(17638, 6))
})
