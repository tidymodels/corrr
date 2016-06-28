#' Plot correlation matrix.
#' 
#' Plot a \code{\link{correlate}} correlation matrix.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' 
#' @export
rplot <- function(x) {
  UseMethod("rplot")
}
