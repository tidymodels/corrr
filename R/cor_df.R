
# na_x --------------------------------------------------------------------

#' @export
shave.cor_df <- function(x, upper = TRUE) {
  
  # Separate rownames
  row_names <- x$rowname
  x %<>% dplyr::select(-rowname)
  
  # Remove upper matrix
  if (upper) {
    x[upper.tri(x)] <- NA
  } else {
    x[lower.tri(x)] <- NA
  }
  
  # Reappend rownames and class
  rownames(x) <- row_names
  x %<>% dplyr::add_rownames()
  class(x) <- c("cor_df", class(x))
  x
}

# Arrange -----------------------------------------------------------------

#' @export
rearrange.cor_df <- function(x, method = "PCA", absolute = TRUE) {
  
  # Convert to original matrix
  m <- x %>% as_matrix()
  
  if (absolute) {
    m %<>% abs()
  }

  if (method %in% c("BEA", "BEA_TSP", "PCA", "PCA_angle")) {
    ord <- m %>% seriation::seriate(method = method)
  } else {
    ord <- dist(m) %>% seriation::seriate(method = method)
  }
  
  ord %<>% seriation::get_order()

  # Arrange and return matrix
  # "c(1, 1 + ..." to handle rowname column
  x <- x[ord, c(1, 1 + ord)]
  class(x) <- c("cor_df", class(x))
  return(x)
}



# Manipulate --------------------------------------------------------------

#' @export
as_matrix.cor_df <- function(x) {
  # Separate rownames
  row_names <- x$rowname
  x %<>% dplyr::select(-rowname)
  
  # Return diagonal to 1
  diag(x) <- 1
  
  # Convert to matrix and set rownames
  class(x) <- "data.frame"
  x %<>% as.matrix()
  rownames(x) <- row_names
  x
}


#' @export
focus.cor_df <- function(x, ..., rows = FALSE) {
  
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
    x %<>% dplyr::filter(rowname %in% vars)
    class(x) <- c("cor_df", class(x))
    x
  } else {
    x %>% dplyr::filter(!(rowname %in% vars))
  }
}

#' @export
rgather.cor_df <- function(x, ..., na_omit = FALSE) {

  x %<>%
    focus(..., rows = TRUE) %>%
    tidyr::gather(x, r, -rowname) %>%
    dplyr::rename(y = rowname)
  
  if (na_omit) {
    x %<>% dplyr::filter(!is.na(r))
  }
  
  x[, c("x", "y", "r")]
}


# Plot --------------------------------------------------------------------

#' @export
rplot.cor_df <- function(x) {
  # Store order for factoring the variables
  row_order <- x$rowname
  
  # Convert data to relevant format and plot
  x %>%
    # Convert to wide
    rgather(everything()) %>%
    # Factor x and y to correct order
    # and add text column to fill diagonal
    mutate(x = factor(x, levels = row_order),
           y = factor(y, levels = rev(row_order)),
           size = abs(r),
           label = ifelse(is.na(r), as.character(x), NA)) %>%
    # plot
    ggplot2::ggplot(ggplot2::aes(x = x, y = y,
               color = r, size = size, alpha = size,
               label = label)) +
    ggplot2::geom_point() +
    ggplot2::scale_colour_gradient2(limits = c(-1, 1), low = "indianred2", mid= "white", high = "skyblue1") +
    ggplot2::geom_text() +
    ggplot2::labs(x = "", y ="") +
    ggplot2::theme_classic()
}
