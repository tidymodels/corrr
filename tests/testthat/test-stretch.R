context("stretch")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

test_that("Converts to proper structure", {
  expect_equal(
    nrow(stretch(d)),
    nrow(d) * nrow(d)
  )
  expect_equal(
    colnames(stretch(d)),
    c("x", "y", "r")
  )
<<<<<<< HEAD
  verify_output("stretch-keep.order_TRUE.txt",
                str(stretch(d))
  )
  verify_output("stretch-keep.order_FALSE.txt",
    str(stretch(d, keep.order = FALSE))
  )
=======

  exp_res <-
    tibble::tribble(
      ~x,             ~y,                 ~r,
      "Sepal.Length", "Sepal.Length",                 NA,
      "Sepal.Length",  "Sepal.Width",  -0.11210590623308,
      "Sepal.Length", "Petal.Length",  0.871280634027569,
      "Sepal.Length",  "Petal.Width",   0.81696119802127,
      "Sepal.Width", "Sepal.Length",  -0.11210590623308,
      "Sepal.Width",  "Sepal.Width",                 NA,
      "Sepal.Width", "Petal.Length",  -0.42844010433054,
      "Sepal.Width",  "Petal.Width", -0.366125932536439,
      "Petal.Length", "Sepal.Length",  0.871280634027569,
      "Petal.Length",  "Sepal.Width",  -0.42844010433054,
      "Petal.Length", "Petal.Length",                 NA,
      "Petal.Length",  "Petal.Width",  0.962865431402796,
      "Petal.Width", "Sepal.Length",   0.81696119802127,
      "Petal.Width",  "Sepal.Width", -0.366125932536439,
      "Petal.Width", "Petal.Length",  0.962865431402796,
      "Petal.Width",  "Petal.Width",                 NA
    )
  expect_equivalent(as.data.frame(stretch(d)), as.data.frame(exp_res))
>>>>>>> master
})

test_that("na.rm", {
  expect_equal(
    sum(is.na(stretch(d)$r)),
    nrow(d)
  )
  expect_equal(
    sum(is.na(stretch(d, na.rm = TRUE)$r)),
    0
  )
})

test_that("retract works", {
  cd <- as_cordf(retract(stretch(d)))
  expect_equal(d, cd)
  expect_s3_class(d, "cor_df")
})

test_that("remove.dups works", {
  expect_s3_class(stretch(d, remove.dups = TRUE), "data.frame")
})
