context("focus_")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Column select works as dplyr::select_", {
  expect_equal(
    colnames(focus_(d, "Sepal.Length", "Sepal.Width", mirror = TRUE)),
    c("term", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    colnames(focus_(d, .dots = c("Sepal.Length", "Petal.Length"), mirror = TRUE)),
    c("term", "Sepal.Length", "Petal.Length")
  )
  expect_equal(
    colnames(focus_(d, .dots = paste(c("Sepal", "Petal"), "Width", sep = "."), mirror = TRUE)),
    c("term", "Sepal.Width", "Petal.Width")
  )
})

test_that("Selects/excludes in rows", {
  expect_equal(
    focus_(d, "Sepal.Length", "Sepal.Width", mirror = TRUE)$term,
    c("Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    focus_(d, "Sepal.Length", "Sepal.Width", mirror = FALSE)$term,
    c("Petal.Length", "Petal.Width")
  )
  expect_equal(
    colnames(focus_(d, "Sepal.Length", "Sepal.Width", mirror = FALSE)),
    c("term", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    sum(is.na(as.matrix(focus_(d, "Sepal.Length", "Sepal.Width", mirror = TRUE)))),
    2
  )
  expect_equal(
    sum(is.na(as.matrix(focus_(d, "Sepal.Length", "Sepal.Width", mirror = FALSE)))),
    0
  )
})
