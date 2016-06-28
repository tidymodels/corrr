context("rselect")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Column select works as dplyr::select", {
  expect_equal(
    colnames(rselect(d, Sepal.Length, Sepal.Width)),
    c("rowname", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    colnames(rselect(d, Sepal.Length:Petal.Length)),
    c("rowname", "Sepal.Length", "Sepal.Width", "Petal.Length")
  )
  expect_equal(
    colnames(rselect(d, contains("Length"))),
    c("rowname", "Sepal.Length", "Petal.Length")
  )
  expect_equal(
    colnames(rselect(d, -contains("Length"))),
    c("rowname", "Sepal.Width", "Petal.Width")
  )
})

test_that("Selects/excludes in rows", {
  expect_equal(
    rselect(d, Sepal.Length, Sepal.Width)$rowname,
    c("Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    rselect(d, Sepal.Length, Sepal.Width, rows = FALSE)$rowname,
    c("Petal.Length", "Petal.Width")
  )
  expect_equal(
    colnames(rselect(d, Sepal.Length, Sepal.Width, rows = FALSE)),
    c("rowname", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    sum(is.na(as.matrix(rselect(d, Sepal.Length, Sepal.Width)))),
    2
  )
  expect_equal(
    sum(is.na(as.matrix(rselect(d, Sepal.Length, Sepal.Width, rows = FALSE)))),
    0
  )
})