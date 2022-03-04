#' Apply a function to all pairs of columns in a data frame
#'
#' `colpair_map()` transforms a data frame by applying a function to each pair
#'   of its columns. The result is a correlation data frame (see
#'   \code{\link{correlate}} for details).
#'
#' @param .data A data frame or data frame extension (e.g. a tibble).
#' @param .f A function.
#' @param ... Additional arguments passed on to the mapped function.
#' @param .diagonal Value at which to set the diagonal (defaults to `NA`).
#' @return A correlation data frame (`cor_df`).
#' @importFrom dplyr summarise across
#' @importFrom purrr map_dfr
#' @examples
#' ## Using `stats::cov` produces a covariance data frame.
#' colpair_map(mtcars, cov)
#'
#' ## Function to get the p-value from a t-test:
#' calc_p_value <- function(vec_a, vec_b) {
#'   t.test(vec_a, vec_b)$p.value
#' }
#'
#' colpair_map(mtcars, calc_p_value)
#' @export

colpair_map <- function(.data, .f, ..., .diagonal = NA) {

  ## .data cannot be used as column name.

  out <- purrr::map_dfr(.data, summarise_col, {{ .f }}, .data, ...)

  ## Tidy eval curly brackets ({{) are for compatibility with dplyr v1.0.0 - v1.0.3

  as_cordf(out, diagonal = .diagonal)
}

#' Summarise a column
#'
#' Helper function to summarise data frame column.
#'
#' @param .x A vector, in this case a column of a data frame.
#' @param .f A function.
#' @param .data The data frame in which the column is found.
#'
#' @return A row summarising the values in the column.
#'
#' @noRd

summarise_col <- function(.x, .f, .data, ...) {
  dplyr::summarise(.data, dplyr::across(
    .cols = dplyr::everything(),
    .fns = {{ .f }},
    {{ .x }},
    ...
  ))

  ## Tidy eval curly brackets ({{) are for compatibility with dplyr v1.0.0 - v1.0.3
}
