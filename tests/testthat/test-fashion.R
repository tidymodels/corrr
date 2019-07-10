context("fashion")

test_that("Digits", {
  expect_equal(
    fashion(0.232573),
    noquote(" .23")
  )
  expect_equal(
    fashion(237.234),
    noquote("237.23")
  )
  expect_equal(
    fashion(-0.236),
    noquote("-.24")
  )
})

test_that("Decimal places", {
  expect_equal(
    fashion(0.232573, decimals = 3),
    noquote(" .233")
  )
  expect_equal(
    fashion(0.232573, decimals = 4),
    noquote(" .2326")
  )
})

test_that("Leading zeros", {
  expect_equal(
    fashion(0.23, leading_zeros = F),
    noquote(" .23")
  )
  expect_equal(
    fashion(-0.23, leading_zeros = F),
    noquote("-.23")
  )
  expect_equal(
    fashion(0.23, leading_zeros = T),
    noquote("0.23")
  )
  expect_equal(
    fashion(-0.23, leading_zeros = T),
    noquote("-0.23")
  )
})

test_that("Non-numeric and missing", {
  expect_equal(
    fashion("0.232573"),
    noquote("0.232573")
  )
  expect_equal(
    fashion(TRUE),
    noquote("TRUE")
  )
  expect_equal(
    fashion(NA),
    noquote("")
  )
  expect_equal(
    fashion(NA, na_print = "x"),
    noquote("x")
  )
})

test_that("Vectors and padding", {
  expect_equal(
    fashion(c(111.11, .11, -.11, NA)),
    noquote(c("111.11", "   .11", "  -.11", ""))
  )
})

test_that("Fashion works against matrix", {
  expect_is(fashion(as.matrix(correlate(mtcars))), "data.frame")
})
