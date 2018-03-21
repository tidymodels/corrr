#' Correlation Data Frame
#' 
#' An implementation of stats::cor(), which returns a correlation data frame
#' rather than a matrix. See details below. Additional adjustment include the
#' use of pairwise deletion by default.
#' 
#' \itemize{
#'   This function returns a correlation matrix as a correlation data frame in
#'   the following format:
#'   \item A tibble (see \code{\link[tibble]{tibble}})
#'   \item An additional class, "cor_df"
#'   \item A "rowname" column
#'   \item Standardised variances (the matrix diagonal) set to missing values by
#'   default (\code{NA}) so they can be ignored in calculations.
#' }
#' 
#' @inheritParams stats::cor
#' @inheritParams as_cordf
#' @param quiet Set as TRUE to suppress message about `method` and `use`
#'   parameters.
#' @return A correlation data frame (cor_df)
#' @export
#' @examples
#' \dontrun{
#' correlate(iris)
#' }
#' 
#' correlate(mtcars)
#' correlate(iris[-5])
#' 
correlate <- function(x, y = NULL,
                      use = "pairwise.complete.obs",
                      method = "pearson",
                      diagonal = NA,
                      quiet = FALSE) {
  UseMethod("correlate")
}
#' @export
correlate.default <- function(x, y = NULL,
                       use = "pairwise.complete.obs",
                       method = "pearson",
                      diagonal = NA,
                      quiet = FALSE) {
  x <- stats::cor(x = x, y = y, use = use, method = method)

  if (!quiet)
    message("\nCorrelation method: '", method, "'",
            "\nMissing treated using: '", use, "'\n")
  
  as_cordf(x, diagonal = diagonal)
}
#' @export
correlate.tbl_sql <- function(x) {
  df <- x
  
  col_names <- colnames(df)
  col_no <- length(col_names)
  
  combos <- 1:(col_no - 1) %>%
    map_df(~tibble(
      x = col_names[.x],
      y = col_names[(.x + 1):col_no],
      cn = paste0(x, "_", y)
    ))
  
  full_combos <- 1:(col_no) %>%
    map_df(~
             tibble(
               x = col_names[.x],
               y = col_names[.x:col_no],
               cn = paste0(x, "_", y)
             ) %>%
             bind_rows(
               tibble(
                 x = col_names[.x:col_no],
                 y = col_names[.x],
                 cn = paste0(y, "_", x)
               )
             )) %>%
    filter(x != y)
  
  df <- df %>%
    filter_all(all_vars(!is.na(.))) 
  
  df_mean <- df %>%
    summarise_all(mean, na.rm = TRUE)
  
  cor_f <- 1:nrow(combos) %>%
    map(
      ~ tidyeval_cor(
        !! sym(combos$x[.x]),
        !! sym(combos$y[.x]),
        pull(select(df_mean, combos$x[1])),
        pull(select(df_mean, combos$y[1])) 
      )
    )
  
  cor_f <- set_names(cor_f, combos$cn)
  
  df_cor <- df %>%
    summarise(!!! cor_f) %>%
    collect() %>%
    as.tibble() %>%
    gather(cn, cor) %>%
    right_join(full_combos, by = "cn") %>%
    select(-cn) %>%
    spread(y, cor) %>%
    rename(rowname = x)
  
  class(df_cor) <- c("cor_df", class(df_cor))
  
  df_cor
}


tidyeval_cor <- function(x, y, x_mean, y_mean) {
  x <- enexpr(x)
  y <- enexpr(y)
  
  expr(
    sum((!! x - !! x_mean) * (!! y - !! y_mean), na.rm = TRUE) /
      sqrt(
        sum((!! x - !! x_mean) * (!! x - !! x_mean), na.rm = TRUE) *
          sum((!! y - !! y_mean) * (!! y - !! y_mean), na.rm = TRUE)
      )
  )
}
