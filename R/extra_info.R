#' Number of pairwise complete cases.
#' 
#' Compute the number of complete cases in a pairwise fashion for \code{x} (and
#' \code{y}).
#' 
#' @inheritParams stats::cor
#' @return Matrix of pairwise sample sizes (number of complete cases).
#' @export
pair_n <- function(x, y = NULL) {
  if (is.null(y)) y <- x
  x <- t(!is.na(x)) %*% (!is.na(y))
  class(x) <- c("n_mat", "matrix")
  x
}