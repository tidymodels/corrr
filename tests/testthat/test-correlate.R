context("correlate")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA

test_that("Inherits correct classes", {
  expect_is(correlate(d), "cor_df")
  expect_is(correlate(d), "tbl_df")
})

test_that("Yields correct columns and rows", {
  expect_equal(colnames(correlate(d)), c("rowname", colnames(d)))
  expect_equal(nrow(correlate(d)), ncol(d))
  expect_equal(correlate(d)$rowname, colnames(d))
})

test_that("Diagonal set to NA", {
  expect_equal(all(is.na(diag(as.matrix(correlate(d)[, -1])))), TRUE)
})

test_that("Accurately computes correlations", {
  expect_equal(correlate(d)$Sepal.Length[2],
               cor(d, use = "pairwise.complete.obs")[2, "Sepal.Length"])
  expect_equal(correlate(d, use = "everything")$Sepal.Length[2],
               cor(d)[2, "Sepal.Length"])
  expect_equal(correlate(d, use = "everything")$Sepal.Length[2], NA_integer_)
  expect_equal(correlate(d, method = "spearman")$Sepal.Length[2],
               cor(d, method = "spearman", use = "pairwise.complete.obs")[2, "Sepal.Length"])
})
