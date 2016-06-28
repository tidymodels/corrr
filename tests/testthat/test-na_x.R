context("na_x")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("na_upper", {
  expect_equal(
    sum(is.na(as.matrix(na_upper(d)))),
    nrow(d) + sum((nrow(d)-1):1)
  )
})

test_that("na_lower", {
  expect_equal(
    sum(is.na(as.matrix(na_upper(d)))),
    nrow(d) + sum((nrow(d)-1):1)
  )
})

test_that("combined", {
  expect_equal(
    sum(is.na(as.matrix(na_lower(na_upper(d))))),
    nrow(d) * nrow(d)
  )
})
