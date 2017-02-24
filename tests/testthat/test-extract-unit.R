context("test unit extraxction from nc file")

u1 <- extract_unit(system.file(package = "ecocat", "inst/extdata/d1.nc"))
u2 <- extract_unit(system.file(package = "ecocat", "inst/extdata/volume.nc"))

test_names <- c("longitude", "latitude", "depth", "time")
test_units <- c("degrees_east", "degrees_north", "meters", "days since 2000-1-1 00:00:00")

t1 <- c(test_units, "mmolN m-3")
names(t1) <- c(test_names, "d1")

t2 <- c(test_units, "m3")
names(t2) <- c(test_names, "vol")

test_that("test this", {
  expect_equal(length(u1), length(t1))
  expect_equal(length(u2), length(t2))

  expect_equal(u1, t1)
  expect_equal(u2, t2)
})
