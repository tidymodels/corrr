#' Correlation Data Frame
#' 
#' An implementation of stats::cor(), which returns a correlation data frame
#' rather than a matrix. See details below. Additional adjustment include the
#' use of pairwise deletion by default.
#' 
#' \itemize{
#'   This function returns a correlation matrix as a correlation data frame in
#'   the following format:
#'   \item A tibble (see \code{\link[tibble]{tibble}})
#'   \item An additional class, "cor_df"
#'   \item A "rowname" column
#'   \item Standardised variances (the matrix diagonal) set to missing values by
#'   default (\code{NA}) so they can be ignored in calculations.
#' }
#' 
#' @inheritParams stats::cor
#' @inheritParams as_cordf
#' @return A correlation data frame (cor_df)
#' @export
#' @examples
#' \dontrun{
#' correlate(iris)
#' }
#' 
#' correlate(mtcars)
#' correlate(iris[-5])
correlate <- function(x, y = NULL,
                       use = "pairwise.complete.obs",
                       method = "pearson",
                      diagonal = NA) {
  x <- stats::cor(x = x, y = y, use = use, method = method)
  #diag(x) <- NA
  #x <- dplyr::as_data_frame(x)
  #x <- first_col(x, names(x))
  #class(x) <- c("cor_df", class(x))
  #x
  as_cordf(x, diagonal = diagonal)
}

# #' Coerce lists and matrices to correlation data frames
# #' 
# #' A wrapper function to coerce objects in a valid format (such as correlation
# #' matrices created using the base function, \link{\code{cor}}) into a
# #' correlation data frame.
# #' 
# #' @param x A list, data frame or matrix that can be coerced into a correlation
# #'   data frame.
# #' @param diagonal Value to set the diagonal to.
# #' @return A correlation data frame (cor_df)
# #' @export
# as_cordf <- function(x, diagonal = NA) {
#   x <- dplyr::as_data_frame(x)
#   diag(x) <- NA
#   x <- first_col(x, names(x))
#   class(x) <- c("cor_df", class(x))
#   x
# }