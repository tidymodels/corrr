#' Obtain correlations and corresponding sample sizes.
#' 
#' These are methods for calculating the correlations (and corresponding sample
#' sizes) between columns of a data frame or matrix. Note that data frames are
#' converted to a matrix before computing correlations.
#' 
#' @section Return structures:
#' 
#' Currently corrr returns correlations and sample sizes in two structures:
#' 
#' \describe{
#'  \item{\code{cor_matrix}}{return a list of two matrices: \code{r}, which
#'  contains the correlations; and \code{n}, which contains the corresponding
#'  sample sizes.}
#'  
#'  \item{\code{cor_frame}}{return a dplyr::data_frame with three columns:
#'  \code{vars}, the column names (variables) being correlated pasted together
#'  with \code{<>}; \code{r}, which contains the correlations; and \code{n}, which
#'  contains the corresponding sample sizes. Unlike \code{cor_matrix},
#'  \code{cor_frame} only returns each correlation once (rather than in a
#'  mirrored matrix).}
#'  
#' }
#' 
#' @param x A data frame of columns to correlate.
#' @inheritParams stats::cor
#' @name cor_x

#' @rdname cor_x
#' @export
cor_matrix <- function(x, use = "pairwise.complete.obs",
                       method = c("pearson", "kendall", "spearman")) {
  UseMethod("cor_matrix")
}

#' @rdname cor_x
#' @export
cor_frame <- function(x, use = "pairwise.complete.obs",
                      method = c("pearson", "kendall", "spearman")) {
  UseMethod("cor_frame")
}