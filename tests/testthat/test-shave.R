context("shave")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Shave upper", {
  expect_equal(
    sum(is.na(as.matrix(shave(d, upper = TRUE)))),
    nrow(d) + sum((nrow(d)-1):1)
  )
})

test_that("Shave lower", {
  expect_equal(
    sum(is.na(as.matrix(shave(d, upper = FALSE)))),
    nrow(d) + sum((nrow(d)-1):1)
  )
})

test_that("Shave all", {
  expect_equal(
    sum(is.na(as.matrix(shave(shave(d, upper = TRUE), upper = FALSE)))),
    nrow(d) * nrow(d)
  )
})
