context("dataframe")

test_that("Fashion works", {
  expect_is(fashion(mtcars), "data.frame")
})
