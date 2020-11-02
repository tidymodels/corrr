d <- datasets::anscombe[, 1:7]
d[1, 1] <- NA
d <- correlate(d)

context("network_plot")

test_that("Network plot works", {
  expect_s3_class(network_plot(d), "ggplot")
  expect_s3_class(network_plot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})


test_that("Network plot works with 2 variables", {
  d2 <- correlate(datasets::anscombe[c("x1", "y1")])

  expect_s3_class(network_plot(d2), "ggplot")
  expect_s3_class(network_plot(d2, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})

test_that("Network plot works with 1 variable", {
  d1 <- correlate(datasets::anscombe["x1"])
  expect_s3_class(network_plot(d1), "ggplot")
  expect_s3_class(network_plot(d1, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})

context("rplot")

test_that("rplot works", {
  expect_s3_class(rplot(d), "ggplot")
  expect_s3_class(rplot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})
