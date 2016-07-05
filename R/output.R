#' Fashion a correlation data frame for printing.
#' 
#' For the purpose of printing, convert a correlation data frame into a noquote 
#' matrix with the correlations cleanly formatted (leading zeros removed; spaced
#' for signs) and the diagonal (or any NA) left blank.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param digits Number of decimal places to display.
#' @return Formatted noquote matrix.
#' @export
fashion <- function(x, digits) {
  UseMethod("fashion")
}


#' Plot a correlation data frame.
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
