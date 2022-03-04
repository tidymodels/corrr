d <- cor(mtcars)

test_that("Inherits correct classes", {
  expect_s3_class(as_cordf(d), "cor_df")
  expect_s3_class(as_cordf(d), "tbl")
  expect_warning(as_cordf(as_cordf(d)), "x is already a correlation")
})

test_that("Yields correct columns and rows", {
  expect_equal(colnames(as_cordf(d)), c("term", colnames(d)))
  expect_equal(nrow(as_cordf(d)), ncol(d))
  expect_equal(as_cordf(d)$term, colnames(d))
})

test_that("Diagonal sets correctly", {
  expect_equal(all(is.na(diag(as.matrix(as_cordf(d, diagonal = NA)[, -1])))), TRUE)
  expect_equal(all(diag(as.matrix(as_cordf(d, diagonal = 100)[, -1] == 100))), TRUE)
})

test_that("as_cordf handles single correlation", {
  d1 <- cor(mtcars["cyl"])
  expect_s3_class(as_cordf(d1), "cor_df")
  expect_equal(colnames(as_cordf(d1)), c("term", colnames(d1)))
})
