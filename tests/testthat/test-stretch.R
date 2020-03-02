context("stretch")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Converts to proper structure", {
  expect_equal(
    nrow(stretch(d)),
    nrow(d) * nrow(d)
  )
  expect_equal(
    colnames(stretch(d)),
    c("x", "y", "r")
  )
  verify_output("stretch.txt",
    str(stretch(d))
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

test_that("retract works", {
  cd <- as_cordf(retract(stretch(d)))
  expect_equal(d, cd)
  expect_is(d, "cor_df")
})

test_that("remove.dups works", {
  expect_is(stretch(d, remove.dups = TRUE), "data.frame")
})
