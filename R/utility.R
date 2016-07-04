#' Number of pairwise complete cases.
#' 
#' Compute the number of complete cases in a pairwise fashion for \code{x} (and
#' \code{y}).
#' 
#' @inheritParams stats::cor
#' @return Matrix of pairwise sample sizes (number of complete cases).
#' @export
#' @examples
#' pair_n(mtcars)
pair_n <- function(x, y = NULL) {
  if (is.null(y)) y <- x
  x <- t(!is.na(x)) %*% (!is.na(y))
  class(x) <- c("n_mat", "matrix")
  x
}

#' Convert cor_df to original matrix.
#' 
#' Convert a correlation data frame to original matrix format.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @return Correlation matrix
#' @export
#' @examples
#' x <- correlate(mtcars)
#' as_matrix(x)
as_matrix <- function(x) {
  UseMethod("as_matrix")
}