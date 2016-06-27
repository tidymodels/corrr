#' @export
rselect.cor_df <- function(x, ..., rows = TRUE) {
  
  # Store rownames in case they're dropped in next step
  row_names <- x$rowname
  
  # Select relevant columns
  x %<>% dplyr::select_(.dots = lazyeval::lazy_dots(...))
  
  # Get selected column names and
  # append back rownames if necessary
  vars <- colnames(x)
  if ("rowname" %in% vars) {
    vars %<>% .[. != "rowname"]
  } else {
    rownames(x) <- row_names
    x %<>% dplyr::add_rownames()
  }
  
  # Exclude these or others from the rows
  if (rows) {
    x %>% dplyr::filter(rowname %in% vars)
  } else {
    x %>% dplyr::filter(!(rowname %in% vars))
  }
}

#' @export
rgather.cor_df <- function(x, ..., mirror = TRUE, na_omit = FALSE) {
  
  if (!mirror) {
    # Store rownames while upper triangle is omitted
    row_names <- x$rowname
    x <- dplyr::select(x, -rowname)
    
    # Set upper triangle to missing
    # and na_omit to TRUE
    x[upper.tri(x)] <- NA
    rownames(x) <- row_names
    x %<>% dplyr::add_rownames()
    class(x) <- c("cor_df", class(x))
    na_omit <- TRUE
  }

  x %<>%
    rselect(...) %>%
    tidyr::gather(y, r, -rowname) %>%
    dplyr::rename(x = rowname)
  
  if (na_omit) {
    x %<>% filter(!is.na(r))
  }
  
  x
}