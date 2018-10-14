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
#' correlate(iris[-5])
#' 
#' correlate(mtcars)
#' 
#' \dontrun{
#' 
#' # Also supports DB backend and collects results into memory
#' 
#' library(sparklyr)
#' sc <- spark_connect(master = "local")
#' mtcars_tbl <- copy_to(sc, mtcars)
#' mtcars_cors <- mtcars_tbl %>% 
#'   correlate(use = "complete.obs")
#' mtcars_cors
#' spark_disconnect(sc)
#' 
#' }
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

spark_correlate <- function(x, method = "pearson") {
  spark_corr <- ml_corr(x, method = method)
  
  local_corr <- map_df(
    spark_corr,
    ~{
      ones <- .x == 1
      res <- as.numeric(.x)
      res[ones] <- NA
      res
    }
  )
  
  as.tibble(cbind(
    tibble(rowname = colnames(spark_corr)),
    local_corr
  ))
}

#' @export
correlate.tbl_sql <- function(x, y = NULL,
                              use = "pairwise.complete.obs",
                              method = "pearson",
                              diagonal = NA,
                              quiet = FALSE) {

  if(use != "complete.obs") stop("Only 'complete.obs' method are supported")
  if(!is.null(y))           stop("y is not supported for tables with a SQL back-end")
  if(!is.na(diagonal))      stop("Only NA's are supported for same field correlations")
  df_cor <- NULL
    
  if("tbl_spark" %in% class(x)){
    
    if(!method %in% c("pearson", "spearman"))
      stop("Only person or spearman methods are currently supported")
    
    df_cor <- spark_correlate(
      x = x,
      method = method
    )
  }
  
  if(is.null(df_cor)){
    
    if(method != "pearson")   stop("Only person method is currently supported")
    
    
    minus_mean <- mutate_all(
      x,
      funs(. - mean(., na.rm = TRUE))
    ) 
    
    col_names <- colnames(x)
    col_no <- seq_along(col_names)
    
    cols <- map(
      col_no,
      ~{
        x <- .x
        map(col_no, ~ c(.x, x))
      }
    )
    cols <- flatten(cols)
    cols <- map(cols, sort)
    
    dups <- map_lgl(cols, ~all.equal(.x[1], .x[2]) != TRUE)
    
    cols <- cols[dups]
    
    cols_names <-map(cols, paste0, collapse = ",")
    
    unique_cols <- unique(cols_names)
    
    combos <- map(
      unique_cols,
      ~ cols[cols_names == .x][[1]]
    )
    
    f_cor <- map(
      combos,
      ~{
        l <- col_names[.x[[1]]]
        r <- col_names[.x[[2]]]
        map2(
          l,
          r,
          tidyeval_cor
        )
      }
    )
    f_cor <- flatten(f_cor)
    f_cor <- set_names(f_cor, unique_cols)
    
    cors <- summarise(minus_mean, !!! f_cor)
    cors <- collect(cors)
    
    cors_matrix <- matrix(
      ncol = length(col_no), 
      nrow = length(col_no)
    )
    
    for(i in seq_along(cors)){
      loc <- combos[unique_cols == names(cors[i])][[1]]
      cors_matrix[loc[1], loc[2]] <- cors[i][[1]]
      cors_matrix[loc[2], loc[1]] <- cors[i][[1]]
    }
    
    colnames(cors_matrix) <- col_names
    
    cors_tibble <- cbind(
      rowname = col_names,
      as.data.frame(cors_matrix)
    )
    
    df_cor <- as.tibble(cors_tibble)
    df_cor$rowname <- as.character(df_cor$rowname)
  }
 
  if(!is.null(df_cor)){
    class(df_cor) <- c("cor_df", class(df_cor))
    if (!quiet)
      message("\nCorrelation method: '", method, "'",
              "\nMissing treated using: '", use, "'\n")
  }
  df_cor
}

#' @import rlang
tidyeval_cor <- function(x, y) {
  x <- sym(enexpr(x))
  y <- sym(enexpr(y))
  rlang::expr(
    sum(!! x * !! y , na.rm = TRUE) /
      sqrt(
        sum(!! x * !! x, na.rm = TRUE) *
          sum(!! y * !! y, na.rm = TRUE)
      )
  )
}

utils::globalVariables(c("rowname"))
