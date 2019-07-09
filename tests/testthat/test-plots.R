d <- datasets::iris[, 1:4]
d[1, 1] <- NA
d <- correlate(d)

context("network")

test_that("Network plot works", {
  expect_is(network_plot(d), "ggplot")  
  expect_is(network_plot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})

context("rplot")

test_that("Network plot works", {
  expect_is(rplot(d), "ggplot")
  expect_is(rplot(d, colors = c("indianred2", "white", "skyblue1")), "ggplot")
})
