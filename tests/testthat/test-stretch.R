context("stretch")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Converts to proper structure", {
  expect_equal(
    nrow(stretch(d, everything())),
    nrow(d) * nrow(d)
  )
  expect_equal(
    nrow(stretch(d, contains("Length"))),
    4
  )
  expect_output(
    str(stretch(d, everything())),
    "16 obs. of  3 variables:"
  )
  expect_equal(
    colnames(stretch(d, everything())),
    c("x", "y", "r")
  )
})

test_that("na_omit", {
  expect_equal(
    sum(is.na(stretch(d, everything())$r)),
    nrow(d)
  )
  expect_equal(
    sum(is.na(stretch(d, everything(), na_omit = TRUE)$r)),
    0
  )
})