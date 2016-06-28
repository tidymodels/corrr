#' Set portion to missing
#' 
#' Convert a portion of a correlation data frame (cor_df) to missing.
#' 
#' @section Portions to convert to missing:
#' 
#' Currently, corrr supports the setting of the upper and lower triangles to
#' missing.
#' 
#' \describe{
#'   \item{\code{na_upper}}{convert the upper matrix to missing}
#'   
#'   \item{\code{na_lower}}{convert the lower triangle to missing}
#'   
#' }
#' 
#' @param x cor_df
#' @name na_x
NULL

#' @rdname na_x
#' @export
na_upper <- function(x) {
  UseMethod("na_upper")
}

#' @rdname na_x
#' @export
na_lower <- function(x) {
  UseMethod("na_lower")
}