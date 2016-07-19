#' @export
fashion.data.frame <- function(x, decimals = 2, na_print = "") {
  x %>%
    purrr::map(fashion, decimals = decimals, na_print = na_print) %>% 
    as.data.frame() %>% 
    noquote()
}
