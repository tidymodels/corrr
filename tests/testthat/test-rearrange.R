context("rearrange")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Rearrange return correct order", {
  expect_equal(
    colnames(rearrange(d)),
    c("rowname", "Petal.Length", "Petal.Width", "Sepal.Length", "Sepal.Width")
  )
})
