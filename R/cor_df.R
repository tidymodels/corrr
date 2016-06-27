#' @export
xselect.cor_df <- function(x, ...) {
  
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
  
  # Exclude these from the rows
  x %>% dplyr::filter(!(rowname %in% vars))
}


