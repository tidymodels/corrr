#' Obtain correlations and corresponding sample sizes.
#' 
#' These are extensions of stats::cor(). They use cor() to calculate
#' correlations, and return the results in a data frame or matrix-list structure
#' with corresponding sample sizes.
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
#' @inheritParams stats::cor
#' @name cor_x

#' @rdname cor_x
#' @export
cor_matrix <- function(x, y = NULL, use = "pairwise.complete.obs", method = "pearson") {
  UseMethod("cor_matrix")
}

#' @export
cor_matrix.default <- function(x, y = NULL, use = "pairwise.complete.obs", method = "pearson") {
  r <- stats::cor(x = x, y = y, use = use, method = method)
  if (is.null(y)) y <- x
  n <- t(!is.na(x)) %*% (!is.na(y))
  x <- list(r = r, n = n)
  class(x) <- c("cor_mat", "list")
  x
}

#' @rdname cor_x
#' @export
cor_frame <- function(x, y = NULL, use = "pairwise.complete.obs", method = "pearson") {
  UseMethod("cor_frame")
}

#' @export
cor_frame.default <- function(x, y = NULL, use = "pairwise.complete.obs", method = "pearson") {
  cor_frame(cor_matrix(x, y, use, method))
}

# Conversions -------------------------------------------------------------

#' @export
cor_matrix.cor_df <- function(x) {
  vars <- union(x$x, x$y)
  n_vars <- length(vars)
  r <- n <- matrix(1, nrow = n_vars, ncol = n_vars)
  r[upper.tri(r)] <- r[lower.tri(r)] <- x$r
  n[upper.tri(n)] <- n[lower.tri(n)] <- x$n
  x <- list(r = r, n = n)
  class(x) <- c("cor_mat", "list")
  x
}

#' @export
cor_frame.cor_mat <- function(x) {
  vars <- colnames(x$r)
  if (is.null(vars)) vars <- paste0("v", 1:ncol(d))
  n_vars <- length(vars)
  n_cors <- factorial(n_vars) / (factorial(2) * factorial(n_vars - 2))
  
  x1 <- rep(head(vars, -1), (n_vars - 1):1)
  x2 <- vector(mode = "character")
  for (i in 1:(n_vars - 1))
    x2 <- c(x2, tail(vars, -i))
  
  x <- dplyr::data_frame(
    x1 = x1,
    x2 = x2,
    r  = x$r[lower.tri(x$r)],
    n  = x$n[lower.tri(x$n)]
  )
  names(x) <- c("x", "y", "r", "n")
  class(x) <- c("cor_df", class(x))
  x
}
