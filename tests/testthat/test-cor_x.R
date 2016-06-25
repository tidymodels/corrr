context("cor_x")

df <- data.frame(a = c(1:4, NA), b = 5:9)
mat <- as.matrix(df)

test_that("cor_x adds appropriate class", {
  expect_is(cor_frame(df), "cor_df")
  expect_is(cor_frame(mat), "cor_df")
  expect_is(cor_matrix(df), "cor_mat")
  expect_is(cor_matrix(mat), "cor_mat")
})

test_that("cor_matrix produces accurate output", {
  
  expect_equal(cor_matrix(df)$r,
               cor(df, use = "pairwise.complete.obs"))
  expect_equal(cor_matrix(df, use = "everything")$r,
               cor(df, use = "everything"))
  
  expect_equal(cor_matrix(mat)$r,
               cor(df, use = "pairwise.complete.obs"))
  expect_equal(cor_matrix(mat, use = "everything")$r,
               cor(df, use = "everything"))
  
  expect_equal(cor_matrix(df, method = "spearman")$r,
               cor(df, use = "pairwise.complete.obs", method = "spearman"))
  
})

test_that("cor_frame produces accurate output", {
  
  r_df <- cor_frame(df)

  expect_equal(r_df$x, "a")
  expect_equal(r_df$y, "b")
  expect_equal(r_df$r, 1)
  expect_equal(r_df$n, nrow(na.omit(df)))
})

test_that("cor_x conversion", {

  r_df <- cor_frame(df)
  
  expect_equal(cor_frame(cor_matrix(df)), r_df)
  expect_equal(cor_frame(cor_matrix(mat)), r_df)
})

