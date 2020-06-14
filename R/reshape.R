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
#' @param ...  One or more unquoted expressions separated by commas. Variable 
#'  names can be used as if they were positions in the data frame, so 
#'  expressions like `x:y`` can be used to select a range of variables.
#' @param .dots Use focus_ to do standard evaluations. See \code{\link[dplyr]{select}}.
#' @param mirror Boolean. Whether to mirror the selected columns in the rows or
#'   not.
#' @return A tbl or, if mirror = TRUE, a cor_df (see \code{\link{correlate}}).
#' @export
#' @examples
#' library(dplyr)
#' x <- correlate(mtcars)
#' focus(x, mpg, cyl)  # Focus on correlations of mpg and cyl with all other variables
#' focus(x, -disp, - mpg, mirror = TRUE)  # Remove disp and mpg from columns and rows
#'
#' x <- correlate(iris[-5])
#' focus(x, -matches("Sepal"))  # Focus on correlations of non-Sepal
#'                              # variables with Sepal variables.
focus <- function(x, ..., mirror = FALSE) {
  focus_(
    x = x,
    .dots = ...,
    ... = ...,
    mirror = mirror
    )
}

#' Returns a correlation table with the selected fields only
#'
#' @param x A correlation table, class cor_df
#' @param ... A list of variables in the correlation table
#'
#' @examples
#'
#' dice(correlate(mtcars), mpg, wt, am)
#'
#' @export
dice <- function(x, ...) {
  UseMethod("dice")
}

#' @export
dice.cor_df <- function(x, ...) {
  focus(x, ..., mirror = TRUE)
}

#' @export
#' @rdname focus
focus_ <- function(x, ..., .dots, mirror) {
  UseMethod("focus_")
}

#' Conditionally focus correlation data frame
#'
#' Apply a predicate function to each column of correlations. Columns that
#' evaluate to TRUE will be included in a call to \code{\link{focus}}.
#'
#' @param x Correlation data frame or object to be coerced to one via
#'   \code{\link{as_cordf}}.
#' @param .predicate A predicate function to be applied to the columns. The
#'   columns for which .predicate returns TRUE will be included as variables in
#'   \code{\link{focus}}.
#' @param ... Additional arguments to pass to the predicate function if not anonymous.
#' @inheritParams focus
#' @return A tibble or, if mirror = TRUE, a correlation data frame.
#' @export
#' @examples
#' library(dplyr)
#' any_greater_than <- function(x, val) {
#'   mean(abs(x), na.rm = TRUE) > val
#' }
#'
#' x <- correlate(mtcars)
#'
#' x %>% focus_if(any_greater_than, .6)
#' x %>% focus_if(any_greater_than, .6, mirror = TRUE) %>% network_plot()
focus_if <- function(x, .predicate, ..., mirror = FALSE) {
  UseMethod("focus_if")
}

#' @export
focus_if.default <- function(x, .predicate, ..., mirror = FALSE) {
  # Coerce to cor_df
  x <- as_cordf(x)
  focus_if.cor_df(x, .predicate, ..., mirror = mirror)
}

#' Stretch correlation data frame into long format.
#'
#' \code{stretch} is a specified implementation of tidyr::gather() to be applied
#' to a correlation data frame. It will gather the columns into a long-format
#' data frame. The rowname column is handled automatically.
#'
#' @param x cor_df. See \code{\link{correlate}}.
#' @param na.rm Boolean. Whether rows with an NA correlation (originally the
#'   matrix diagonal) should be dropped? Will automatically be set to TRUE if
#'   mirror is FALSE.
#' @param remove.dups Removes duplicate entries, without removing all NAs
#' @return tbl with three columns (x and y variables, and their correlation)
#' @export
#' @examples
#' x <- correlate(mtcars)
#' stretch(x)  # Convert all to long format
#' stretch(x, na.rm = FALSE)  # omit NAs (diagonal in this case)
#'
#' x <- shave(x)  # use shave to set upper triangle to NA and then...
#' stretch(x, na.rm = FALSE)  # omit all NAs, therefore keeping each
#'                              # correlation only once.
stretch <- function(x, na.rm = FALSE, remove.dups =  FALSE) {
  UseMethod("stretch")
}

#' @export
stretch.cor_df <- function(x, na.rm = FALSE, remove.dups =  FALSE) {
  if(remove.dups) x <- shave(x)
  row_name <- x$rowname
  x <- x[, colnames(x) != "rowname"]
  tb <- imap_dfr(x, ~tibble(x = .y, y = row_name, r = .x))
  if(na.rm) tb <- tb[!is.na(tb$r), ]
  if(remove.dups) {
    stretch_unique(tb)
  } else {
    tb
  }
}

stretch_unique <- function(.data,  x = x, y = y, val = r) {
  val <- enquo(val)
  y <- enquo(y)
  x <- enquo(x)
  row_names <- unique(.data[, as_label(y)][[1]])
  td <- purrr::transpose(.data)
  combos <- map_chr(
    td,
    ~paste0(sort(c(.x$x, .x$y)), collapse = " | ")
  )
  .data$combos <- combos
  map_dfr(
    unique(combos),
    ~{
      cr <- .data[.data$combos == .x, ]
      vl <- cr[, as_label(val)][[1]]
      if(nrow(cr) == 2) cr <- cr[!is.na(vl), ]
      if(nrow(cr) != 1) stop("Error deduplicating stretched table")
      cr[, colnames(cr) != "combos"]
    }
  )
}
