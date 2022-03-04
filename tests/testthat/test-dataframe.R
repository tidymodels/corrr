test_that("Fashion works", {
  expect_s3_class(fashion(mtcars), "data.frame")
})
