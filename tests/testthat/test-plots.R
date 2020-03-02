d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

context("network")

test_that("Network plot works", {
  expect_s3_class(network_plot(d), "ggplot")  
  expect_s3_class(network_plot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})

context("rplot")

test_that("Network plot works", {
  expect_s3_class(rplot(d), "ggplot")
  expect_s3_class(rplot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})
