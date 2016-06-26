#' @export
print.r_mat <- function(x, round_to = 2) {
  class(x) <- c("matrix")
  x <- format(round(x, round_to), nsmall = round_to)  # round decimal points
  x <- gsub("0\\.", ".", x)  # remove leading zeros
  diag(x) <- ""  # remove 1s on diagonal
  print(noquote(x))  # print without quotes
}

#' @export
print.n_mat <- function(x) {
  class(x) <- c("matrix")
  print(x)
}
