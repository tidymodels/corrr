context("tbl_sql")

d <- datasets::iris[, 1:4]
d[1, 1] <- NA

remote_d <- d
class(remote_d) <- c(class(remote_d), "tbl_sql")

test_that("Fails when non supported arguments are passed",{
  expect_error(correlate(remote_d))
  expect_error(correlate(remote_d, y = remote_d))
  expect_error(correlate(remote_d, method = "kendall"))
  expect_error(correlate(remote_d, diagonal = 1))
})

test_that("tbl_sql routine returns same results are the default routine",{
  expect_equal(
    correlate(remote_d, use = "complete.obs", quiet = TRUE) %>%
      tidyr::gather() %>%
      arrange(value) %>%
      pull(value),
    correlate(d, use = "complete.obs", quiet = TRUE) %>%
      tidyr::gather() %>%
      arrange(value) %>%
      pull(value)
  )
})