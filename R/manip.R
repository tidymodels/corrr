#' Select a subspace of variables by name.
#'
#' Select a subspace of only the variables you mention by name in rows or cols.
#'
#' @section Subspace methods:
#' 
#' \describe{
#'   \item{\code{subrows}}{Return all rows whose names match those provided.}
#'   
#'   \item{\code{subcols}}{Return all columns whose names match those provided.}
#'   
#'   \item{\code{subrows_} and \code{subrows_}}{Programattic versions of above
#'   that accept string characters as row/column names.}
#' }
#' 
#' @param .r_mat A correaltion matrix with row and column names.
#' @param ... Comma separated names of the rows/columns to keep.
#' @name subspace

#' @rdname subspace
#' @export
subrows <- function(.r_mat, ...) {
  subrows_(.r_mat, .dots = lazyeval::lazy_dots(...))
}

#' @rdname subspace
#' @export
subrows_ <- function(.r_mat, ..., .dots) {
  UseMethod("subrows_")
}

#' @export
subrows_.r_mat <- function(.r_mat, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ...)
  vars <- dplyr::select_vars_(colnames(.r_mat), dots)
  x <- .r_mat[vars, ]
  class(x) <- c("r_mat", "matrix")
  x
}

#' @rdname subspace
#' @export
subcols <- function(.r_mat, ...) {
  subcols_(.r_mat, .dots = lazyeval::lazy_dots(...))
}

#' @rdname subspace
#' @export
subcols_ <- function(.r_mat, ..., .dots) {
  UseMethod("subcols_")
}

#' @export
subcols_.r_mat <- function(.r_mat, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ...)
  vars <- dplyr::select_vars_(colnames(.r_mat), dots)
  x <- .r_mat[, vars]
  class(x) <- c("r_mat", "matrix")
  x
}