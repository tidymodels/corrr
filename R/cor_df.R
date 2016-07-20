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
rplot.cor_df <- function(x, print_cor = FALSE, shape = 16) {
  # Store order for factoring the variables
  row_order <- x$rowname
  
  # Prep dots for mutate_
  dots <- stats::setNames(list(lazyeval::interp(~ factor(x, levels = row_order),
                                           x = quote(x)),
                               lazyeval::interp(~ factor(y, levels = rev(row_order)),
                                                y = quote(y)),
                               lazyeval::interp(~ abs(r),
                                                r = quote(r)),
                               lazyeval::interp(~ as.character(fashion(r)),
                                                r = quote(r))
                               #lazyeval::interp(~ as.character(x),
                              #                  x = quote(x))
                              ),
                     list("x", "y", "size", "label"))
  
  # Convert data to relevant format and plot
  p <- x %>%
        # Convert to wide
        stretch(na_omit = TRUE) %>%
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
        ggplot2::labs(x = "", y ="") +
        ggplot2::theme_classic() +
        ggplot2::theme(legend.position = "none")
  
  if (print_cor) {
    p <- p + ggplot2::geom_text(color = "black", size = 3, show.legend = FALSE)
  }
    
  p
}

#' @export
network_plot.cor_df <- function(x, min_cor = .30) {
  
  if (min_cor < 0) {
    stop ("min_cor must be a value greater than zero.")
  }
  
  x %<>% as_matrix()
  distance <- sign(x) * (1 - abs(x))
  
  # Use multidimensional Scaling to obtain x and y coordinates for points.
  points <- distance %>%
    abs() %>%
    stats::cmdscale() %>%
    data.frame() %>%
    dplyr::rename(x = X1, y = X2) %>%
    dplyr::mutate(id = rownames(.))
  
  # Create a proximity matrix of the paths to be plotted.
  proximity <- abs(x)
  proximity[upper.tri(proximity)] <- NA
  diag(proximity) <- NA
  proximity[proximity < min_cor] <- NA
  
  # Produce a data frame of data needed for plotting the paths.
  n_paths <- sum(!is.na(proximity))
  paths <- matrix(nrow = n_paths, ncol = 6) %>% data.frame()
  colnames(paths) <- c("x", "y", "xend", "yend", "proximity", "sign")
  path <- 1
  for(row in 1:nrow(proximity)) {
    for(col in 1:ncol(proximity)) {
      path_proximity <- proximity[row, col]
      if (!is.na(path_proximity)) {
        path_sign <- sign(distance[row, col])
        x    <- points$x[row]
        y    <- points$y[row]
        xend <- points$x[col]
        yend <- points$y[col]
        paths[path, ] <- c(x, y, xend, yend, path_proximity, path_sign)
        path <- path + 1
      }
    }
  }
  
  # Produce the plot.
  ggplot2::ggplot() +
    # Plot the paths
    ggplot2::geom_curve(data = paths,
                        ggplot2::aes(x = x, y = y, xend = xend, yend = yend,
                                     alpha = proximity, size = proximity,
                                     colour = factor(sign)),
                        show.legend = FALSE) +
    # Plot the points
    ggplot2::geom_point(data = points,
                        ggplot2::aes(x, y),
                        size = 3, alpha = .5, shape = 1, colour = "white") +
    # Plot variable labels
    ggplot2::geom_text(data = points,
                       ggplot2::aes(x, y, label = id),
                       size = 5, colour = "black", vjust = 1) +
    # expand the axes to add space for curves
    ggplot2::expand_limits(x = c(min(points$x) - .1,
                                 max(points$x) + .1),
                           y = c(min(points$y) - .1,
                                 max(points$y) + .1)
    ) +
    ggplot2::theme_void()
}