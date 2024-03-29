#' @export
fashion.data.frame <- function(x, decimals = 2, leading_zeros = FALSE, na_print = "") {
  x <- purrr::map(
    x,
    fashion,
    decimals = decimals,
    leading_zeros = leading_zeros,
    na_print = na_print
  )
  noquote(as.data.frame(x))
}
