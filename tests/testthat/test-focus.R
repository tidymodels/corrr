d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Column select works as dplyr::select", {
  expect_equal(
    colnames(focus(d, Sepal.Length, Sepal.Width, mirror = TRUE)),
    c("term", "Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    colnames(focus(d, Sepal.Length:Petal.Length, mirror = TRUE)),
    c("term", "Sepal.Length", "Sepal.Width", "Petal.Length")
  )
  expect_equal(
    colnames(focus(d, dplyr::contains("Length"), mirror = TRUE)),
    c("term", "Sepal.Length", "Petal.Length")
  )
  expect_equal(
    colnames(focus(d, -dplyr::contains("Length"), mirror = TRUE)),
    c("term", "Sepal.Width", "Petal.Width")
  )
})

test_that("Selects/excludes in rows", {
  expect_equal(
    focus(d, Sepal.Length, Sepal.Width, mirror = TRUE)$term,
    c("Sepal.Length", "Sepal.Width")
  )
  expect_equal(
    focus(d, Sepal.Length, Sepal.Width, mirror = FALSE)$term,
    c("Petal.Length", "Petal.Width")
  )
  expect_equal(
    colnames(focus(d, Sepal.Length, Sepal.Width, mirror = FALSE)),
    c("term", "Sepal.Length", "Sepal.Width")
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

test_that("focus_if works", {
  any_greater_than <- function(x, val) {
    mean(abs(x), na.rm = TRUE) > val
  }
  expect_s3_class(
    focus_if(d, any_greater_than, .6),
    "tbl_df"
  )
})
