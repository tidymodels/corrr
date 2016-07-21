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

test_that("Non-numeric", {
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
})
noquote(as.character(list(1,2,3)))
test_that("Vectors and padding", {
  expect_equal(
    fashion(c(111.11, .11, -.11, NA)),
    noquote(c("111.11", "   .11", "  -.11", ""))
  )
})

