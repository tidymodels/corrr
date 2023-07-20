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
#' shave(x) # Default; shave upper triangle
#' shave(x, upper = FALSE) # shave lower triangle
shave <- function(x, upper = TRUE) {
  UseMethod("shave")
}

#' Re-arrange a correlation data frame
#'
#' Re-arrange a correlation data frame to group highly correlated variables closer
#' together.
#'
#' @param x cor_df. See \code{\link{correlate}}.
#' @param method String specifying the arrangement method.
#'   Reordering is achieved via \code{\link[seriation]{seriate}}, which can be
#'   consulted for a complete list of clustering methods. Default = "PCA".
#' @param absolute Boolean whether absolute values for the correlations should
#'   be used for reordering.
#' @return cor_df. See \code{\link{correlate}}.
#' @export
#' @references
#' Hahsler M, Hornik K, Buchta C (2008). "Getting things in order:
#' An introduction to the R package seriation."
#' Journal of Statistical Software, 25(3), 1-34. ISSN 1548-7660.
#' \doi{10.18637/jss.v025.i03}
#' @examples
#' x <- correlate(mtcars)
#'
#' rearrange(x) # Default settings (PCA)
#' rearrange(x, method = "PCA_angle") # Angle in 2D PCA projection
#' rearrange(x, method = "OLO") # Optimal leaf ordering
#' rearrange(x, method = "R2E") # Rank 2 ellipse seriation
#'
#' rearrange(x, absolute = TRUE) # Using absolute values for arranging
#'
#' # list all available seriation methods
#' seriation::list_seriation_methods()
rearrange <- function(x, method = "PC", absolute = TRUE) {
  UseMethod("rearrange")
}
