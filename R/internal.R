#' Convert correlate to original matrix.
#' 
#' Convert a \code{\link{correlate}} correlation matrix from data frame to
#' original matrix format.
#' 
#' @param x A \code{\link{correlate}} correlation matrix.
#' @export
as_matrix <- function(x) {
  UseMethod("as_matrix")
}

#' Shave off upper/lower triangle.
#' 
#' Convert the upper or lower triangle of a correlation data frame (cor_df) to
#' missing values.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param upper Boolean. If TRUE, set upper triangle to NA; lower triangle if
#'   FALSE.
#' @export
shave <- function(x, upper = TRUE) {
  UseMethod("shave")
}

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