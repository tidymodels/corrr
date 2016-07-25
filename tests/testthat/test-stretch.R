context("stretch")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Converts to proper structure", {
  expect_equal(
    nrow(stretch(d)),
    nrow(d) * nrow(d)
  )
  expect_output(
    str(stretch(d)),
    "16 obs. of  3 variables:"
  )
  expect_equal(
    colnames(stretch(d)),
    c("x", "y", "r")
  )
})

test_that("na.rm", {
  expect_equal(
    sum(is.na(stretch(d)$r)),
    nrow(d)
  )
  expect_equal(
    sum(is.na(stretch(d, na.rm = TRUE)$r)),
    0
  )
})