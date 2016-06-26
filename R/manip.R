#' Cross section of the correlation matrix.
#' 
#' Convenience function to create a cross section of the matrix by selecting a 
#' set of variables to be kept in one axis (rows or columns), and dropped from
#' the other.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @param ... Vector of/comma separated character strings of variable names.
#' @param in_rows Boolean to keep the named variables in the rows, or
#'   columns otherwise. Default = TRUE.
#' @export
cross_section <- function(x, ..., in_rows = TRUE) {
  UseMethod("cross_section")
}

#' @export
cross_section.cor_df <- function(x, ..., in_rows = TRUE) {
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
