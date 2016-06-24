
# Correlations ------------------------------------------------------------

#' Convert to a correlation data frame
#' @export
as_cor_frame.data.frame <- function(x) {
  as_cor_frame(cor_matrix(x))
}

#' Convert to a correlation data frame
#' @export
as_cor_frame.r_mat <- function(x) {
  vars <- colnames(x$r)
  n_vars <- length(vars)
  n_cors <- factorial(n_vars) / (factorial(2) * factorial(n_vars - 2))
  
  var1 <- rep(head(vars, -1), (n_vars - 1):1)
  var2 <- vector(mode = "character")
  for (i in 1:(n_vars - 1))
    var2 <- c(var2, tail(vars, -i))
  
  dplyr::data_frame(
    vars = paste(var1, var2, sep = "<>"),
    r    = x$r[lower.tri(x$r)],
    n    = x$n[lower.tri(x$n)]
  )
}


