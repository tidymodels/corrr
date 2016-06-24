#' Build a correlation matrix.
#' 
#' @export
#' 
cor_matrix <- function(x) {
  
  stopifnot(is.data.frame(x))
  
  r <- stats::cor(x, use = "pairwise.complete.obs")
  n <- t(!is.na(x)) %*% (!is.na(x))
  x <- list(r = r, n = n)
  class(x) <- c("r_mat", "list")
  x
}

#' Build a data frame of correlations.
#'
#' @export
#'
cor_frame <- function(x) {
  as_cor_frame(x)
}

# Conversions -------------------------------------------------------------

as_cor_frame <- function(x) {
  UseMethod("as_cor_frame")
}