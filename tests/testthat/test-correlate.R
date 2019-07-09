context("correlate")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA

test_that("Accurately computes correlations", {
  expect_equal(correlate(d)$Sepal.Length[2],
               cor(d, use = "pairwise.complete.obs")[2, "Sepal.Length"])
  expect_equal(correlate(d, use = "everything")$Sepal.Length[2],
               cor(d)[2, "Sepal.Length"])
  expect_equal(correlate(d, use = "everything")$Sepal.Length[2], NA_integer_)
  expect_equal(correlate(d, method = "spearman")$Sepal.Length[2],
               cor(d, method = "spearman", use = "pairwise.complete.obs")[2, "Sepal.Length"])
  expect_message(correlate(d, quiet = FALSE), "Correlation method") 
})

test_that("Diagonal sets correctly", {
  expect_equal(all(is.na(diag(as.matrix(correlate(d, diagonal = NA)[, -1])))), TRUE)
  expect_equal(all(diag(as.matrix(correlate(d, diagonal = 100)[, -1] == 100))), TRUE)
})
