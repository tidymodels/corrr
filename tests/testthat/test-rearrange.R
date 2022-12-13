test_that("Rearrange return correct order", {
  d <- datasets::iris[, 1:4]
  d[1, 1] <- NA
  d <- correlate(d)

  expect_equal(
    colnames(rearrange(d, absolute = FALSE)),
    c("term", "Petal.Length", "Petal.Width", "Sepal.Length", "Sepal.Width")
  )
})

test_that("rearrange(absolute) works again [#167]", {
  df <- data.frame(
    x = 1:10,
    y = -c(1:10),
    z = 1:10
  )

  x <- correlate(df, quiet = TRUE)
  obj <- rearrange(x, absolute = FALSE)
  exp <- as_cordf(tibble(
    term = c("x", "z", "y"),
    x = c(NA, 1, -1),
    z = c(1, NA, -1),
    y = c(-1, -1, NA)
  ))
  expect_identical(obj, exp)

  # should not change the order
  obj <- rearrange(x, absolute = TRUE)
  expect_identical(obj, x)
})
