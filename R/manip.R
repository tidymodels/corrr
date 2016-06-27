#' Select columns, exclude same or other rows.
#' 
#' Convenience function to select a set of variables from a correlation matrix
#' to keep as the columns, and exclude these or all other variables from the rows. This
#' function will take a \code{\link{correlate}} correlation matrix, and
#' expression(s) suited for dplyr::select(). The selected variables will remain
#' in the columns, and these, or all other variables, will be excluded from the
#' rows based on `\code{same}. For a complete list of methods for using this
#' function, see \code{\link[dplyr]{select}}.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @inheritParams dplyr::select
#' @param rows Boolean. Whether to keep selected variables in the rows, or all other
#'   variables otherwise.
#' 
#' @examples
#' mtcars %>% correlate() %>% rselect(mpg, cyl)
#' mtcars %>% correlate() %>% rselect(-disp, - mpg)
#' iris[, 1:4] %>% correlate() %>% rselect(-matches("Sepal"))
#' 
#' @export
rselect <- function(x, ..., rows = TRUE) {
  UseMethod("rselect")
}

#' Gather correlation columns
#' 
#' rgather is an extension of tidyr::gather() to be applied to a
#' \code{\link{correlate}} correlation matrix. It will gather the selected
#' variables into a long-format data frame. The rowname column is handled
#' automatically. Variable selection is achieved with \code{\link{rselect}},
#' which you can see for more detail on how to select columns.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @inheritParams dplyr::select
#' @param mirror Boolean. Should the upper and lower triangles of the matrix be included?
#' @param na_omit Boolean. Whether rows with an NA correlation (originally the
#'   matrix diagonal) should be dropped? Will automatically be set to TRUE if
#'   mirror is FALSE.
#' 
#' @export
rgather <- function(x, ..., mirror = TRUE, na_omit = FALSE) {
  UseMethod("rgather")
}
