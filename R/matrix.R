#' @export
fashion.matrix <- function(x, decimals = 2, na_print = "") {
  x %>%
    as.data.frame() %>%
    fashion(decimals = decimals, na_print = na_print)
}