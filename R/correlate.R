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

  as_cordf(x, diagonal = diagonal)
}