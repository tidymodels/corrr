
# Correlations ------------------------------------------------------------

#' @export
cor_matrix.data.frame <- function(x, use = "pairwise.complete.obs",
                                     method = c("pearson", "kendall", "spearman")) {
  cor_matrix(as.matrix(x), use = use, method = method)
}

#' @export
cor_frame.data.frame <- function(x, use = "pairwise.complete.obs",
                                    method = c("pearson", "kendall", "spearman")) {
  cor_frame(cor_matrix(x, use, method))
}