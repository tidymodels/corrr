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
retract.data.frame <- function(.data,  x = x, y = y, val = r) {
  val <- enquo(val)
  y <- enquo(y)
  x <- enquo(x)
  row_names <- unique(.data[, as_label(y)][[1]])
  res <- map_dfr(
    row_names, ~{
      df <- .data[.data[, as_label(x)]== .x, ]
      vl <- df[, as_label(val)][[1]]
      nm <- df[, as_label(y)][[1]]
      map_dfc(
        seq_along(nm),
        ~ tibble(!! nm[.x] := !! vl[.x])
      )
    }
  )
  first_col(res, row_names)
}
