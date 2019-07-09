context("Utilities") 

test_that("pair_n works", {
  expect_is(
    pair_n(1),
    "matrix"
  )  
})
