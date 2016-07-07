#' Correlation Data Frame
#' 
#' An implementation of stats::cor(), which returns a correlation matrix in a
#' specific format. See details below. Additional adjustment include the use of
#' pairwise deletion by default.
#' 
#' \itemize{
#'   This function returns a correlation matrix in the following format:
#'   \item A tbl (tibble::data_frame)
#'   \item An additional class, "cor_df"
#'   \item A "rowname" column
#'   \item Standardised variances (the matrix diagonal) set to missing values
#'   (\code{NA}) so they can be ignored in calculations.
#' }
#' 
#' The main feature is the use of the data frame. This is to make use of data
#' frame manipulation packages like dplyr and tidyr.
#' 
#' 
#' @inheritParams stats::cor
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
                       method = "pearson") {
  x <- stats::cor(x = x, y = y, use = use, method = method)
  diag(x) <- NA
  x <- dplyr::as_data_frame(x)
  x <- first_col(x, names(x))
  class(x) <- c("cor_df", class(x))
  x
}
