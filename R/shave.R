#' Shave off upper/lower triangle.
#' 
#' Convert the upper or lower triangle of a correlation data frame (cor_df) to
#' missing values.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param upper Boolean. If TRUE, set upper triangle to NA; lower triangle if
#'   FALSE.
#' @export
shave <- function(x, upper = TRUE) {
  UseMethod("shave")
}