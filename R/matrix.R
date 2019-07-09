#' @export
fashion.matrix <- function(x, decimals = 2, leading_zeros = FALSE, na_print = "") {
  fashion(
    as.data.frame(x),
    decimals = decimals, 
    leading_zeros = leading_zeros, 
    na_print = na_print
    )
}