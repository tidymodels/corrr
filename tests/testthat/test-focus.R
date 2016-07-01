context("focus")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Column select works as dplyr::select", {
  expect_equal(
    colnames(focus(d, Sepal.Length, Sepal.Width, mirror = TRUE)),
    c("rowname", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    colnames(focus(d, Sepal.Length:Petal.Length, mirror = TRUE)),
    c("rowname", "Sepal.Length", "Sepal.Width", "Petal.Length")
  )
  expect_equal(
    colnames(focus(d, contains("Length"), mirror = TRUE)),
    c("rowname", "Sepal.Length", "Petal.Length")
  )
  expect_equal(
    colnames(focus(d, -contains("Length"), mirror = TRUE)),
    c("rowname", "Sepal.Width", "Petal.Width")
  )
})

test_that("Selects/excludes in rows", {
  expect_equal(
    focus(d, Sepal.Length, Sepal.Width, mirror = TRUE)$rowname,
    c("Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    focus(d, Sepal.Length, Sepal.Width, mirror = FALSE)$rowname,
    c("Petal.Length", "Petal.Width")
  )
  expect_equal(
    colnames(focus(d, Sepal.Length, Sepal.Width, mirror = FALSE)),
    c("rowname", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    sum(is.na(as.matrix(focus(d, Sepal.Length, Sepal.Width, mirror = TRUE)))),
    2
  )
  expect_equal(
    sum(is.na(as.matrix(focus(d, Sepal.Length, Sepal.Width, mirror = FALSE)))),
    0
  )
})