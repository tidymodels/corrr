#' Correlation Data Frame
#' 
#' An extension of stats::cor(), which returns a correlation matrix in a
#' specific format. See details below. Additional adjustment include the use of
#' pairwise deletion by default.
#' 
#' \itemize{
#'   This function returns a correlation matrix in the following format:
#'   \item A tibble::data_frame
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
#' @export
correlate <- function(x, y = NULL,
                       use = "pairwise.complete.obs",
                       method = "pearson") {
  x <- stats::cor(x = x, y = y, use = use, method = method)
  diag(x) <- NA
  x <- as.data.frame(x)
  x %<>% dplyr::add_rownames()
  class(x) <- c("cor_df", class(x))
  x
}
