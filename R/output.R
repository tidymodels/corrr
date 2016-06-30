#' Plot correlation matrix.
#' 
#' Plot a \code{\link{correlate}} correlation matrix.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param shape \code{\link{geom_point}} aesthetic.
#' 
#' @export
rplot <- function(x, shape) {
  UseMethod("rplot")
}
