
# Correlations ------------------------------------------------------------

#' @export
cor_matrix.data.frame <- function(x, use = "pairwise.complete.obs",
                                     method = c("pearson", "kendall", "spearman")) {
  r <- stats::cor(x, use = use, method = method)
  n <- t(!is.na(x)) %*% (!is.na(x))
  x <- list(r = r, n = n)
  class(x) <- c("r_mat", "list")
  x
}

#' @export
cor_frame.data.frame <- function(x, use = "pairwise.complete.obs",
                                    method = c("pearson", "kendall", "spearman")) {
  cor_frame(cor_matrix(x, use, method))
}

#' @export
cor_frame.r_mat <- function(x) {
  vars <- colnames(x$r)
  n_vars <- length(vars)
  n_cors <- factorial(n_vars) / (factorial(2) * factorial(n_vars - 2))
  
  var1 <- rep(head(vars, -1), (n_vars - 1):1)
  var2 <- vector(mode = "character")
  for (i in 1:(n_vars - 1))
    var2 <- c(var2, tail(vars, -i))
  
  x <- dplyr::data_frame(
    vars = paste(var1, var2, sep = "<>"),
    r    = x$r[lower.tri(x$r)],
    n    = x$n[lower.tri(x$n)]
  )
  
  class(x) <- c("r_df", class(x))
  x
}
