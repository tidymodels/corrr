#' Correlation Matrix
#' 
#' An extension of stats::cor(), which appends the class \code{r_mat} for
#' additional features provided by the \code{corrr} package. Minor addition is
#' to use pairwise deletion by default rather than listwise.
#' 
#' @inheritParams stats::cor
#' @export
correlate <- function(x, y = NULL,
                       use = "pairwise.complete.obs",
                       method = "pearson") {
  x <- stats::cor(x = x, y = y, use = use, method = method)
  class(x) <- c("r_mat", "matrix")
  x
}
