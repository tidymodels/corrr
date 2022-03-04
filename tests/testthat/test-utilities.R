test_that("pair_n works", {
  expect_s3_class(
    pair_n(1),
    "matrix"
  )
})
