#' Add a first column to a data.frame
#' 
#' Add a first column to a data.frame. This is most commonly used toappend a
#' rowname column to create a cor_df.
#' 
#' @param df Data frame
#' @param ... Values to go into the column
#' @param var Label for the column. Default is "rowname"
#' @export
#' @examples 
#' first_col(mtcars, 1:nrow(mtcars))
first_col <- function(df, ..., var = "rowname") {
  stopifnot(is.data.frame(df))
  
  if (tibble::has_name(df, var))
    stop("There is a column named ", var, " already!")

  new_col <- tibble::tibble(...)
  names(new_col) <- var
  new_df <- c(new_col, df)
  dplyr::as_data_frame(new_df)
}

#' Number of pairwise complete cases.
#' 
#' Compute the number of complete cases in a pairwise fashion for \code{x} (and
#' \code{y}).
#' 
#' @inheritParams stats::cor
#' @return Matrix of pairwise sample sizes (number of complete cases).
#' @export
#' @examples
#' pair_n(mtcars)
pair_n <- function(x, y = NULL) {
  if (is.null(y)) y <- x
  x <- t(!is.na(x)) %*% (!is.na(y))
  class(x) <- c("n_mat", "matrix")
  x
}

#' Convert cor_df to original matrix.
#' 
#' Convert a correlation data frame to original matrix format.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @return Correlation matrix
#' @export
#' @examples
#' x <- correlate(mtcars)
#' as_matrix(x)
as_matrix <- function(x) {
  UseMethod("as_matrix")
}