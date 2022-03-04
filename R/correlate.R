#' Correlation Data Frame
#'
#' An implementation of stats::cor(), which returns a correlation data frame
#' rather than a matrix. See details below. Additional adjustment include the
#' use of pairwise deletion by default.
#'
#'   This function returns a correlation matrix as a correlation data frame in
#'   the following format:
#'
#' \itemize{
#'   \item A tibble (see \code{\link[tibble]{tibble}})
#'   \item An additional class, "cor_df"
#'   \item A "term" column
#'   \item Standardized variances (the matrix diagonal) set to missing values by
#'   default (\code{NA}) so they can be ignored in calculations.
#' }
#'
#'   The `use` argument and its possible values are inherited from `stats::cor()`:
#'
#'   \itemize{
#'       \item "everything": NAs will propagate conceptually, i.e. a resulting value will be NA whenever one of its contributing observations is NA
#'       \item "all.obs": the presence of missing observations will produce an error
#'       \item "complete.obs": correlations will be computed from complete observations, with an error being raised if there are no complete cases.
#'       \item "na.or.complete": correlations will be computed from complete observations, returning an NA if there are no complete cases.
#'       \item "pairwise.complete.obs": the correlation between each pair of variables is computed using all complete pairs of those particular variables.
#'    }
#'
#' As of version 0.4.3, the first column of a `cor_df` object is named "term".
#' In previous versions this first column was named "rowname".
#'
#' @inheritParams stats::cor
#' @inheritParams as_cordf
#' @param quiet Set as TRUE to suppress message about `method` and `use`
#'   parameters.
#' @return A correlation data frame `cor_df`
#' @export
#' @examples
#' \dontrun{
#' correlate(iris)
#' }
#'
#' correlate(iris[-5])
#'
#' correlate(mtcars)
#' \dontrun{
#'
#' # Also supports DB backend and collects results into memory
#'
#' library(sparklyr)
#' sc <- spark_connect(master = "local")
#' mtcars_tbl <- copy_to(sc, mtcars)
#' mtcars_tbl %>%
#'   correlate(use = "pairwise.complete.obs", method = "spearman")
#' spark_disconnect(sc)
#' }
#'
correlate <- function(x, y = NULL,
                      use = "pairwise.complete.obs",
                      method = "pearson",
                      diagonal = NA,
                      quiet = FALSE) {
  UseMethod("correlate")
}


keep_numeric <- function(df, quiet) {
  col_is_numeric <- map_lgl(df, is.numeric)

  if (sum(col_is_numeric) < dim(df)[2]) {
    nonnum_cols <- names(df)[!col_is_numeric]
    df <- df[col_is_numeric]
    if (!quiet) {
      glue_nonnum <-
        glue::glue_collapse(
          glue::backtick(nonnum_cols),
          sep = ", ",
          last = ", and "
        )
      rlang::inform(
        glue::glue("Non-numeric variables removed from input: {glue_nonnum}")
      )
    }
  }

  return(df)
}

#' @export
correlate.default <- function(x, y = NULL,
                              use = "pairwise.complete.obs",
                              method = "pearson",
                              diagonal = NA,
                              quiet = FALSE) {
  if (is.data.frame(x)) {
    x <- keep_numeric(x, quiet)
  }

  if (is.data.frame(y)) {
    y <- keep_numeric(y, quiet)
  }

  x <- stats::cor(x = x, y = y, use = use, method = method)

  if (!quiet) {
    rlang::inform(
      c(
        "Correlation computed with",
        glue::glue("Method: '{method}'"),
        glue::glue("Missing treated using: '{use}'")
      )
    )
  }

  as_cordf(x, diagonal = diagonal)
}

#' @export
correlate.tbl_sql <- function(x, y = NULL,
                              use = "pairwise.complete.obs",
                              method = "pearson",
                              diagonal = NA,
                              quiet = FALSE) {
  if (use != "pairwise.complete.obs") rlang::abort("Only 'pairwise.complete.obs' method are supported")
  if (!is.null(y)) rlang::abort("y is not supported for tables with a SQL back-end")
  if (!is.na(diagonal)) rlang::abort("Only NA's are supported for same field correlations")
  df_cor <- NULL

  if ("tbl_spark" %in% class(x)) {
    if (!method %in% c("pearson", "spearman")) {
      rlang::abort("Only pearson or spearman methods are currently supported")
    }

    df_cor <- as_cordf(sparklyr::ml_corr(x, method = method))
  }

  if (is.null(df_cor)) {
    if (method != "pearson") rlang::abort("Only 'pearson' method is currently supported")

    col_names <- colnames(x)

    cols <- map_dfr(
      col_names,
      ~ tibble(
        x = .x,
        y = col_names
      )
    )
    combos <- map_chr(transpose(cols), ~ paste0(sort(c(.x$x, .x$y)), collapse = "_"))
    cols$combos <- combos
    unique_combos <- unique(combos)

    f_cols <- map_dfr(unique_combos, ~ head(cols[cols$combos == .x, ], 1))

    if (!all(unique(f_cols$x) == col_names)) rlang::abort("Not all variable combinations are present")
    if (!all(unique(f_cols$y) == col_names)) rlang::abort("Not all variable combinations are present")

    f_cols <- f_cols[f_cols$x != f_cols$y, ]

    mnprod <- map(transpose(f_cols), ~ expr(sum(!!sym(.x$x) * !!sym(.x$y), na.rm = TRUE)))
    mnprod <- set_names(mnprod, f_cols$combos)

    mnsum <- map(col_names, ~ expr(sum(!!sym(.x), na.rm = TRUE)))
    mnsum <- set_names(mnsum, paste0(col_names, "_sum"))

    mntwo <- map(col_names, ~ expr(sum(!!sym(.x) * !!sym(.x), na.rm = TRUE)))
    mntwo <- set_names(mntwo, paste0(col_names, "_two"))
    obs <- set_names(list(expr(n())), "obs")
    db_totals <- collect(summarise(x, !!!c(mnsum, mntwo, mnprod, obs)))

    f_cols$x_sum <- paste0(f_cols$x, "_sum")
    f_cols$y_sum <- paste0(f_cols$y, "_sum")
    f_cols$x_two <- paste0(f_cols$x, "_two")
    f_cols$y_two <- paste0(f_cols$y, "_two")

    l_cols <- transpose(f_cols)

    top <- map(l_cols, ~ expr((obs * !!sym(.x$combos)) - (!!sym(.x$x_sum) * !!sym(.x$y_sum))))
    bottom <- map(l_cols, ~ expr((sqrt(((obs * !!sym(.x$x_two)) - (!!sym(.x$x_sum) * !!sym(.x$x_sum))) * ((obs * !!sym(.x$y_two)) - (!!sym(.x$y_sum) * !!sym(.x$y_sum)))))))
    f_cor <- map(seq_along(top), ~ expr(!!top[[.x]] / !!bottom[[.x]]))
    f_cor <- set_names(f_cor, f_cols$combos)

    f_cors <- summarise(db_totals, !!!f_cor)
    f_combos <- map(combos, ~ f_cors[, colnames(f_cors) == .x])
    if ("tbl_df" %in% class(f_cors)) {
      f_combos <- map(f_combos, ~ ifelse(nrow(.x) > 0, .x[1, ], 0)[[1]])
    } else {
      f_combos <- map(f_combos, ~ ifelse(!is.null(nrow(.x)), NA, .x))
    }
    f_combos <- map_dbl(f_combos, ~ ifelse(is.null(.x), NA, .x))

    cor_tbl <- cols
    cor_tbl$cor <- f_combos
    cor_tbl$xn <- map_int(
      cor_tbl$x,
      ~ which(.x == col_names)
    )
    cor_tbl$yn <- map_int(
      cor_tbl$y,
      ~ which(.x == col_names)
    )
    cors_matrix <- matrix(
      ncol = length(col_names),
      nrow = length(col_names)
    )
    for (i in seq_along(combos)) {
      cors_matrix[cor_tbl$xn[[i]], cor_tbl$yn[[i]]] <- cor_tbl$cor[[i]]
    }
    colnames(cors_matrix) <- col_names
    df_cor <- as_cordf(cors_matrix)
  }

  if (!is.null(df_cor)) {
    df_cor <- new_cordf(df_cor)
    if (!quiet) {
      message(
        "\nCorrelation method: '", method, "'",
        "\nMissing treated using: '", use, "'\n"
      )
    }
  }
  df_cor
}
utils::globalVariables(c("term"))
