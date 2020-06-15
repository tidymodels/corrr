context("as_cordf")

d <- cor(mtcars)

test_that("Inherits correct classes", {
  expect_s3_class(as_cordf(d), "cor_df")
  expect_s3_class(as_cordf(d), "tbl")
  expect_warning(as_cordf(as_cordf(d)), "x is already a correlation")
})

test_that("Yields correct columns and rows", {
  expect_equal(colnames(as_cordf(d)), c("rowname", colnames(d)))
  expect_equal(nrow(as_cordf(d)), ncol(d))
  expect_equal(as_cordf(d)$rowname, colnames(d))
})

test_that("Diagonal sets correctly", {
  expect_equal(all(is.na(diag(as.matrix(as_cordf(d, diagonal = NA)[, -1])))), TRUE)
  expect_equal(all(diag(as.matrix(as_cordf(d, diagonal = 100)[, -1] == 100))), TRUE)
})
