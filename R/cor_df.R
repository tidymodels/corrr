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
    x %<>% dplyr::filter(!is.na(r))
  }
  
  x
}

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
