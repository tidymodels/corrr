d <- datasets::iris[, 1:4]
d[1, 1] <- NA

mpg <- ggplot2::mpg
mpg_num_names <- names(mpg)[purrr::map_lgl(mpg, is.numeric)]
displ_colnum <- match("displ", mpg_num_names)

test_that("Accurately computes correlations", {
  expect_equal(
    correlate(d)$Sepal.Length[2],
    cor(d, use = "pairwise.complete.obs")[2, "Sepal.Length"]
  )
  expect_equal(
    correlate(d, use = "everything")$Sepal.Length[2],
    cor(d)[2, "Sepal.Length"]
  )
  expect_equal(correlate(d, use = "everything")$Sepal.Length[2], NA_integer_)
  expect_equal(
    correlate(d, method = "spearman")$Sepal.Length[2],
    cor(d, method = "spearman", use = "pairwise.complete.obs")[2, "Sepal.Length"]
  )
  expect_equal(correlate(mpg)$cty[displ_colnum], cor(mpg$cty, mpg$displ))
  expect_message(correlate(d, quiet = FALSE), "Correlation computed")
})

test_that("Diagonal sets correctly", {
  expect_equal(all(is.na(diag(as.matrix(correlate(d, diagonal = NA)[, -1])))), TRUE)
  expect_equal(all(diag(as.matrix(correlate(d, diagonal = 100)[, -1] == 100))), TRUE)
})


test_that("Numeric variables are kept", {
  expect_message(correlate(mpg), "Non-numeric variables removed")
  expect_equal(names(correlate(mpg))[-1], mpg_num_names)
})


test_that("correlate works with numeric vectors", {
  expect_equal(correlate(x = 1:10, y = 1:10)[[2]], 1)
  expect_equal(correlate(x = 1:10, y = -(1:10), diagonal = 0)[[2]], -1)
})

test_that("correlate works with a one-column data.frame", {
  var <- "Sepal.Length"
  expect_equal(correlate(datasets::iris[var])[[1]], var)
  expect_equal(correlate(datasets::iris[var])[[2]], 1)
})
