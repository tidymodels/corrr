#' Cross correlate.
#' 
#' Convenience function to cross correlate one set of variables with all others
#' from a correlation matrix. This function will take a \code{\link{correlate}}
#' correlation matrix, and keep the named variables in the rows (or columns),
#' and drop them from the columns (or rows).
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @param ... Vector of/comma separated character strings of variable names.
#' @param in_rows Boolean to keep the named variables in the rows, or
#'   columns otherwise. Default = TRUE.
#' @export
cross_cor <- function(x, ..., in_rows = TRUE) {
  UseMethod("cross_cor")
}

#' @export
cross_cor.cor_df <- function(x, ..., in_rows = TRUE) {
  vars <- c(...)
  if (!all(vars %in% names(x)))
    stop("Not all variables are in the correlation matrix.")
  
  other_vars <- names(x)[!names(x) %in% c(vars, "rowname")]

  if (in_rows) {
    x %>%
      dplyr::filter(rowname %in% vars) %>%
      dplyr::select(rowname, one_of(other_vars))
  } else {
    x %>%
      dplyr::filter(rowname %in% other_vars) %>%
      dplyr::select(rowname, one_of(vars))
  }
}
