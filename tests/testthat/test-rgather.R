context("rgather")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Converts to proper structure", {
  expect_equal(
    nrow(rgather(d, everything())),
    nrow(d) * nrow(d)
  )
  expect_equal(
    nrow(rgather(d, contains("Length"))),
    4
  )
  expect_output(
    str(rgather(d, everything())),
    "16 obs. of  3 variables:"
  )
  expect_equal(
    colnames(rgather(d, everything())),
    c("x", "y", "r")
  )
})

test_that("na_omit", {
  expect_equal(
    sum(is.na(rgather(d, everything())$r)),
    nrow(d)
  )
  expect_equal(
    sum(is.na(rgather(d, everything(), na_omit = TRUE)$r)),
    0
  )
})