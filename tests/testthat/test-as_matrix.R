context("as_matrix.R")

x <- correlate(mtcars, diagonal = 1)
y <- as_matrix(x)

test_that("Inherits correct classes", {
  expect_is(y, "matrix")
})

test_that("Converts values accurately", {
  expect_true(all(x[-1] == y, na.rm = TRUE))
})

test_that("Yields correct columns and rows", {
  expect_equal(colnames(x), c("rowname", colnames(y)))
  expect_equal(nrow(x), ncol(y))
  expect_equal(x$rowname, colnames(y))
  expect_equal(rownames(y), colnames(y))
})

test_that("Diagonal sets correctly", {
  expect_true(all(diag(y) == 1))
  expect_true(all(diag(as_matrix(x, diagonal = 100)) == 100))
})

test_that("as_matrix preservers diag from correlate", {
  expect_equal(diag(as.matrix(x[-1])), unname(diag(y)))
})