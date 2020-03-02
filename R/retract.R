#' Creates a data frame from a stretched correlation table
#'
#' \code{retract} does the opposite of what \code{stretch} does
#'
#' @param .data A data.frame or tibble containing at least three variables: x, y and the value
#' @param x The name of the column to use from .data as x
#' @param y The name of the column to use from .data as y
#' @param val The name of the column to use from .data to use as the value
#' @export
#' @examples
#' x <- correlate(mtcars)
#' xs <- stretch(x)
#' retract(xs)
#' @export
retract <- function(.data, x, y, val) {
  UseMethod("retract")
}

#' @export
retract.data.frame <- function(.data, x = x, y = y, val = r) {
  data <- mutate(rename(.data, val = {{ val }}), x = fct_inorder({{ x }}), y = fct_inorder({{ y }}))

  xtabs <- as.data.frame(unclass(stats::xtabs(val ~ x + y, data)))
  row_name <- rownames(xtabs)
  rownames(xtabs) <- NULL
  class(xtabs) <- class(.data)

  first_col(xtabs, row_name)
}

fct_inorder <- function(x) {
  if (is.factor(x)) return(x)
  factor(x, levels = unique(x))
}
