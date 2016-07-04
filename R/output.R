#' Plot correlation matrix.
#' 
#' Plot a correlation data frame using ggplot.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param shape \code{\link{geom_point}} aesthetic.
#' @return Plots a correlation data frame
#' @export
#' @examples 
#' x <- correlate(mtcars)
#' rplot(x)
#' 
#' # Common use is following rearrange and shave
#' x <- rearrange(x, absolute = FALSE)
#' x <- shave(x)
#' rplot(x)
rplot <- function(x, shape) {
  UseMethod("rplot")
}
