# Utility --------------------------------------------------------------

#' @export
as_matrix.cor_df <- function(x, diagonal = 1) {

  # Separate rownames
  row_names <- x$rowname
  x %<>% dplyr::select_("-rowname")
  # Return diagonal to 1
  diag(x) <- diagonal
  
  # Convert to matrix and set rownames
  class(x) <- "data.frame"
  #x %<>% as.matrix()
  x <- as.matrix(x)
  rownames(x) <- row_names
  x
}

# Internal --------------------------------------------------------------------

#' @export
shave.cor_df <- function(x, upper = TRUE) {
  
  # Separate rownames
  row_names <- x$rowname
  x %<>% dplyr::select_("-rowname")
  
  # Remove upper matrix
  if (upper) {
    x[upper.tri(x)] <- NA
  } else {
    x[lower.tri(x)] <- NA
  }
  
  # Reappend rownames and class
  x %<>% first_col(row_names)
  class(x) <- c("cor_df", class(x))
  x
}

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


# Reshape -----------------------------------------------------------------

#' @export
focus.cor_df <- function(x, ..., mirror = FALSE) {
  
  # Store rownames in case they're dropped in next step
  row_names <- x$rowname
  
  # Select relevant columns
  x %<>% dplyr::select_(.dots = lazyeval::lazy_dots(...))
  
  # Get selected column names and
  # append back rownames if necessary
  vars <- colnames(x)
  if ("rowname" %in% vars) {
    vars <- vars[vars != "rowname"]
  } else {
    x %<>% first_col(row_names)
  }
  
  # Exclude these or others from the rows
  vars <- x$rowname %in% vars
  if (mirror) {
    x <- x[vars, ]
    class(x) <- c("cor_df", class(x))
  } else {
    x <- x[!vars, ]
  }
  x
}

#' @export
stretch.cor_df <- function(x, na_omit = FALSE) {
  
  vars <- names(x)[names(x) != "rowname"]
  
  x %<>%
    tidyr::gather_("x", "r", vars) %>% 
    dplyr::rename_("y" = "rowname")
  
  if (na_omit) {
    x <- x[!is.na(x$r), ]
  }
  
  x[, c("x", "y", "r")]
}


# Output --------------------------------------------------------------------

#' @export
fashion.cor_df <- function(x, digits = 2) {
  vars <- x$rowname
  
  x %<>% as_matrix(diagonal = NA)
  x <- sub("^-0.", "-\\1.", sprintf(paste0("%.", digits, "f"), x))
  x <- sub("^0.", " \\1.", x)
  x <- sub("NA", "", x)
  x %<>% matrix(nrow = length(vars))
  rownames(x) <- colnames(x) <- vars
  noquote(x)
}

#' @export
rplot.cor_df <- function(x, shape = 16) {
  # Store order for factoring the variables
  row_order <- x$rowname
  
  # Prep dots for mutate_
  dots <- stats::setNames(list(lazyeval::interp(~ factor(x, levels = row_order),
                                           x = quote(x)),
                          lazyeval::interp(~ factor(y, levels = rev(row_order)),
                                           y = quote(y)),
                          lazyeval::interp(~ abs(r),
                                           r = quote(r)),
                          lazyeval::interp(~ ifelse(is.na(r), as.character(x), NA),
                                           r = quote(r), x = quote(x))
                          ),
                     list("x", "y", "size", "label"))
  
  # Convert data to relevant format and plot
  x %>%
    # Convert to wide
    stretch() %>%
    # Factor x and y to correct order
    # and add text column to fill diagonal
    # See dots above
    dplyr::mutate_(.dots = dots) %>% 
    # plot
    ggplot2::ggplot(ggplot2::aes_string(x = "x", y = "y", color = "r",
                                        size = "size", alpha = "size",
                                        label = "label")) +
    ggplot2::geom_point(shape = shape) +
    ggplot2::scale_colour_gradient2(limits = c(-1, 1),
                                    low    = "indianred2",
                                    mid    = "white",
                                    high   = "skyblue1") +
    ggplot2::geom_text(show.legend = FALSE) +
    ggplot2::labs(x = "", y ="") +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = "none")
}
