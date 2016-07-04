#' Shave off upper/lower triangle.
#' 
#' Convert the upper or lower triangle of a correlation data frame (cor_df) to
#' missing values.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param upper Boolean. If TRUE, set upper triangle to NA; lower triangle if
#'   FALSE.
#' @return cor_df. See \code{\link{correlate}}.
#' @export
#' @examples
#' x <- correlate(mtcars)
#' shave(x)  # Default; shave upper triangle
#' shave(x, upper = FALSE)  # shave lower triangle
shave <- function(x, upper = TRUE) {
  UseMethod("shave")
}

#' Re-arrange a correlation data frame
#' 
#' Re-arrange a correlation data frame to group highly correlated variables closer
#' together.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param method String specifying the arrangement (clustering) method.
#'   Clustering is achieved via \code{\link[seriation]{seriate}}, which can be
#'   consulted for a complete list of clustering methods. Default = "PCA".
#' @param absolute Boolean whether absolute values for the correlations should
#'   be used for clustering.
#' @return cor_df. See \code{\link{correlate}}.
#' @export
#' @examples 
#' x <- correlate(mtcars)
#' 
#' rearrange(x) # Default settings
#' rearrange(x, method = "HC")  # Different seriation method
#' rearrange(x, absolute = FALSE)  # Not using absolute values for arranging
rearrange <- function(x, method = "PC", absolute = TRUE) {
  UseMethod("rearrange")
}