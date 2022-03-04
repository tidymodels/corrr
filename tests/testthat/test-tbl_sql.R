d <- datasets::iris[, 1:4]
d[1, 1] <- NA

remote_mtcars <- mtcars
class(remote_mtcars) <- c("tbl_sql", class(remote_mtcars))

test_that("Fails when non supported arguments are passed", {
  expect_error(correlate(remote_d, y = remote_d))
  expect_error(correlate(remote_d, method = "kendall"))
  expect_error(correlate(remote_d, diagonal = 1))
})


test_that("tbl_sql routine's results are within the 0.01 threshold", {

  compare_corr <- function(x, y, ...) {
    res <- purrr:::map2_lgl(x, y, ~ isTRUE(all.equal(.x[[1]], .y[[1]])), ...)
    all(res)
  }

  expect_true(
    compare_corr(
      correlate(mtcars, quiet = TRUE),
      correlate(remote_mtcars, quiet = TRUE),
      tolerance = 0.01
    )
  )
})
