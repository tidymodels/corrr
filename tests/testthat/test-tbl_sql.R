context("tbl_sql")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA

remote_mtcars <- mtcars
class(remote_mtcars) <- c(class(remote_mtcars), "tbl_sql")

test_that("Fails when non supported arguments are passed",{
  expect_error(correlate(remote_d, y = remote_d))
  expect_error(correlate(remote_d, method = "kendall"))
  expect_error(correlate(remote_d, diagonal = 1))
})

compare_corr <- function(x, y, threshold = 0.01){
  x$rowname <- NULL
  y$rowname <- NULL
  comps <- lapply(
    1:nrow(x),
    function(i){
      l <- round(as.numeric(x[i, ]), 3)
      r <- round(as.numeric(y[i, ]), 3)
      res <- abs(l - r) > threshold
      any(res[!is.na(res)])
    }
  )
  any(as.logical(comps))
}

test_that("tbl_sql routine's results are within the 0.01 threshold",{
  expect_false(
    compare_corr(
      correlate(mtcars, quiet = TRUE),
      correlate(remote_mtcars, quiet = TRUE)
      )
    )
  })




