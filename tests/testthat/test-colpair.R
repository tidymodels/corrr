test_that("colpair_map() works", {

  mini_mtcars <- mtcars[, c("mpg", "cyl", "disp")]

  expected_cov_result <- as_cordf(tibble(mpg = c(NA, -9.172379, -633.097208),
                                         cyl = c(-9.172379, NA, 199.660282),
                                         disp = c(-633.0972, 199.6603, NA)))

  expect_equal(colpair_map(mini_mtcars, cov), expected_cov_result,
               tolerance = 0.0001)
  expect_equal(correlate(mtcars), colpair_map(mtcars, cor))
})

test_that("colpair_map() masks argument names", {

  arg_names <- c("x", ".x", "f", ".f" , ".fns", "data", ".data",
                 "summarise_col", ".cols", "diagonal", ".diagonal")

  my_mtcars <- mtcars
  colnames(my_mtcars) <- arg_names

  expect_equal(colpair_map(my_mtcars, cor),
               correlate(my_mtcars, quiet = TRUE),
               tolerance = 1e-10)
})
