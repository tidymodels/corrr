#' Plot correlation matrix.
#' 
#' Plot a \code{\link{correlate}} correlation matrix.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' 
#' @export
rplot <- function(x) {
  UseMethod("rplot")
}
