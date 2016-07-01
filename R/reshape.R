#' Focus on section of a correlation data frame.
#' 
#' Convenience function to select a set of variables from a correlation matrix
#' to keep as the columns, and exclude these or all other variables from the rows. This
#' function will take a \code{\link{correlate}} correlation matrix, and
#' expression(s) suited for dplyr::select(). The selected variables will remain
#' in the columns, and these, or all other variables, will be excluded from the
#' rows based on `\code{same}. For a complete list of methods for using this
#' function, see \code{\link[dplyr]{select}}.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @inheritParams dplyr::select
#' @param mirror Boolean. Whether to mirror the selected columns in the rows or
#'   not.
#' 
#' @examples
#' mtcars %>% correlate() %>% focus(mpg, cyl)
#' mtcars %>% correlate() %>% focus(-disp, - mpg, mirror = TRUE)
#' iris[, 1:4] %>% correlate() %>% focus(-matches("Sepal"))
#' 
#' @export
focus <- function(x, ..., mirror = FALSE) {
  UseMethod("focus")
}

#' Stretch correlation data frame into long format.
#' 
#' \code{stretch} is an extension of tidyr::gather() to be applied to a
#' \code{\link{correlate}} correlation matrix. It will gather the selected
#' variables into a long-format data frame. The rowname column is handled
#' automatically. Variable selection is achieved with \code{\link{focus}},
#' which you can see for more detail on how to select columns.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @inheritParams dplyr::select
#' @param na_omit Boolean. Whether rows with an NA correlation (originally the
#'   matrix diagonal) should be dropped? Will automatically be set to TRUE if
#'   mirror is FALSE.
#' 
#' @export
stretch <- function(x, ..., na_omit = FALSE) {
  UseMethod("stretch")
}
