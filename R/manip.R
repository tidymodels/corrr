#' Select columns, exclude rows.
#' 
#' Convenience function to select a set of variables from a correlation matrix
#' to keep as the columns, but exclude these same variables from the rows. This
#' function will take a \code{\link{correlate}} correlation matrix, and
#' expression(s) suited for dplyr::select(). The selected variables will remain
#' in the columns, but be excluded from the rows. For a complete list of methods
#' for using this function, see \code{\link[dplyr]{select}}.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @inheritParams dplyr::select
#' 
#' @examples
#' mtcars %>% correlate() %>% xselect(mpg, cyl)
#' mtcars %>% correlate() %>% xselect(-disp, - mpg)
#' iris[, 1:4] %>% correlate() %>% xselect(-matches("Sepal"))
#' 
#' @export
xselect <- function(x, ...) {
  UseMethod("xselect")
}
