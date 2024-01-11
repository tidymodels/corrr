test_that("pair_n works", {
  expect_s3_class(
    pair_n(1),
    "matrix"
  )
})

test_that("new_cordf() doesn't append again", {
  x <- as_cordf(data.frame(a = 1))
  obj <- new_cordf(x)
  expect_identical(obj, x)
})
