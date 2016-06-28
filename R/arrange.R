#' Re-arrange a correlation matrix
#' 
#' Re-arrange a correlation matrix to group highly correlated variables closer
#' together.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @param method String specifying the arrangement (clustering) method.
#'   Clustering is achieved via \code{\link[seriation]{seriate}}, which can be
#'   consulted for a complete list of clustering methods. Default = "PCA".
#' @param absolute Boolean whether absolute values for the correlations should
#'   be used when clustering.
#' 
#' @export
rarrange <- function(x, method = "PC", absolute = TRUE) {
  UseMethod("rarrange")
}