test_that("Rearrange return correct order", {
  d <- datasets::iris[, 1:4]
  d[1, 1] <- NA
  d <- correlate(d)

  expect_equal(
    colnames(rearrange(d)),
    c("term", "Petal.Length", "Petal.Width", "Sepal.Length", "Sepal.Width")
  )
})
