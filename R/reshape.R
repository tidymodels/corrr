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
#' @return A tbl or, if mirror = TRUE, a cor_df (see \code{\link{correlate}}).
#' @export
#' @examples
#' x <- correlate(mtcars)
#' focus(x, mpg, cyl)  # Focus on correlations of mpg and cyl with all other variables
#' focus(x, -disp, - mpg, mirror = TRUE)  # Remove disp and mpg from columns and rows
#' 
#' x <- correlate(iris[-5])
#' focus(x, -matches("Sepal"))  # Focus on correlations of non-Sepal 
#'                              # variables with Sepal variables.
focus <- function(x, ..., mirror = FALSE) {
  UseMethod("focus")
}

#' Stretch correlation data frame into long format.
#' 
#' \code{stretch} is a specified implementation of tidyr::gather() to be applied
#' to a correlation data frame. It will gather the columns into a long-format 
#' data frame. The rowname column is handled automatically.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param na_omit Boolean. Whether rows with an NA correlation (originally the
#'   matrix diagonal) should be dropped? Will automatically be set to TRUE if
#'   mirror is FALSE.
#' @return tbl with three colums (x and y variables, and their correlation)
#' @export
#' @examples
#' x <- correlate(mtcars)
#' stretch(x)  # Convert all to long format
#' stretch(x, na_omit = FALSE)  # omit NAs (diagonal in this case)
#' 
#' x <- focus(-mpg, -cyl, mirror = TRUE)  # use focus (with mirror = TRUE) to
#'                                        # drop columns first
#' stretch(x)
#' 
#' x <- shave(x)  # use shave to set upper triangle to NA and then...
#' stretch(x, na_omit = FALSE)  # omit all NAs, therefore keeping each
#'                              # correlation only once.
stretch <- function(x, na_omit = FALSE) {
  UseMethod("stretch")
}
