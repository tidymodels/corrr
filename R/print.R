#' @export
print.r_mat <- function(x, round_to = 2) {
  x <- format(round(x, round_to), nsmall = round_to)  # round decimal points
  x <- gsub("0\\.", ".", x)  # remove leading zeros

  # remove standardised variances (1s)
  is_sv <- sapply(colnames(x), function(i) i == rownames(x))
  x[is_sv] <- ""

  # print without quotes
  class(x) <- c("matrix")
  print(noquote(x))
}

#' @export
print.n_mat <- function(x) {
  class(x) <- c("matrix")
  print(x)
}
