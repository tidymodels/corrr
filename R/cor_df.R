# Utility --------------------------------------------------------------

#' @export
as_matrix.cor_df <- function(x, diagonal) {
  
  # Separate rownames
  row_name <- x$rowname
  x <- x[, colnames(x) != "rowname"]
  # Convert to matrix and set rownames
  class(x) <- "data.frame"
  x <- as.matrix(x)
  # Reset diagonal
  if (!missing(diagonal)) diag(x) <- diagonal
  rownames(x) <- row_name
  x
}

# Internal --------------------------------------------------------------------

#' @export
shave.cor_df <- function(x, upper = TRUE) {
  
  # Separate rownames
  row_name <- x$rowname
  x <- x[, colnames(x) != "rowname"]
  
  # Remove upper matrix
  if (upper) {
    x[upper.tri(x)] <- NA
  } else {
    x[lower.tri(x)] <- NA
  }
  
  # Reappend rownames and class
  x <-  first_col(x, row_name)
  class(x) <- c("cor_df", class(x))
  x
}

#' @export
rearrange.cor_df <- function(x, method = "PCA", absolute = TRUE) {
  
  # Convert to original matrix
  m <- as_matrix(x, diagonal = 1)
  
  if (absolute) abs(m) 
  
  if (method %in% c("BEA", "BEA_TSP", "PCA", "PCA_angle")) {
    ord <- seriation::seriate(m, method = method)
  } else {
    ord <- seriation::seriate(dist(m), method = method)
  }
  
  ord <- seriation::get_order(ord)
  
  # Arrange and return matrix
  # "c(1, 1 + ..." to handle rowname column
  x <- x[ord, c(1, 1 + ord)]
  class(x) <- c("cor_df", class(x))
  return(x)
}


# Reshape -----------------------------------------------------------------

#' @export
focus_.cor_df <- function(x, ..., .dots = NULL, mirror = FALSE) {
  vars <- enquos(...)
  row_name <- x$rowname
  if(length(vars) > 0) {
    x <-  dplyr::select(x, !!! vars)  
  } else {
    x <-  dplyr::select(x, .dots)
  }
  # Get selected column names and
  # append back rownames if necessary
  vars <- colnames(x)
  if ("rowname" %in% vars) {
    vars <- vars[vars != "rowname"]
  } else {
    x <-  first_col(x, row_name)
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
focus_if.cor_df <- function(x, .predicate, ..., mirror = FALSE) {
  
  # Identify which variables to keep
  to_keep <- map_lgl(
    x[, colnames(x) != "rowname"], 
    .predicate, ...
    )

  to_keep <- names(to_keep)[!is.na(to_keep) & to_keep]
  
  if (!length(to_keep)) {
    stop("No variables were TRUE given the function.")
  }
  # Create the network plot
  focus_(x, .dots = to_keep, mirror = mirror)
}

# Output --------------------------------------------------------------------

#' @export
rplot.cor_df <- function(rdf,
                         legend = TRUE,
                         shape = 16,
                         colours = c("indianred2", "white", "skyblue1"),
                         print_cor = FALSE,
                         colors,
                         keep.order = TRUE) {
  
  if (!missing(colors))
    colours <- colors
  
  # Store order for factoring the variables
  row_order <- rdf$rowname
  
  # Convert data to relevant format for plotting
  pd <- stretch(rdf, na.rm = TRUE, keep.order = TRUE) 
  pd$size = abs(pd$r)
  pd$label = fashion(pd$r)
  
  plot_ <- list(
    # Geoms
    geom_point(shape = shape),
    if (print_cor) geom_text(color = "black", size = 3, show.legend = FALSE),
    scale_colour_gradientn(limits = c(-1, 1), colors = colours),
    # Theme, labels, and legends
    theme_classic(),
    labs(x = "", y =""),
    guides(size = "none", alpha = "none"),
    if (legend)  labs(colour = NULL),
    if (!legend) theme(legend.position = "none")
  )
  
  ggplot(pd, aes_string(x = "x", y = "y", color = "r",
                        size = "size", alpha = "size",
                        label = "label")) +
    plot_
  
  #   # plot
  #   ggplot(aes_string(x = "x", y = "y", color = "r",
  #                                       size = "size", alpha = "size",
  #                                       label = "label")) +
  #   geom_point(shape = shape) +
  #   scale_colour_gradientn(limits = c(-1, 1), colors = colours) +
  #   labs(x = "", y ="") +
  #   theme_classic()
  # 
  # if (print_cor) {
  #   p <- p + geom_text(color = "black", size = 3, show.legend = FALSE)
  # }
  # 
  # if (!legend) {
  #   p <- p + theme(legend.position = "none")
  # }
  # 
  # p
}

#' @export
network_plot.cor_df <- function(rdf,
                                min_cor = .30,
                                legend = TRUE,
                                colours = c("indianred2", "white", "skyblue1"),
                                repel = TRUE,
                                curved = TRUE,
                                colors) {
  
  if (min_cor < 0 || min_cor > 1) {
    stop ("min_cor must be a value ranging from zero to one.")
  }
  
  if (!missing(colors))
    colours <- colors
  
  rdf <-  as_matrix(rdf, diagonal = 1)
  distance <- sign(rdf) * (1 - abs(rdf))
  
  # Use multidimensional Scaling to obtain x and y coordinates for points.
  points <- data.frame(stats::cmdscale(abs(distance)))
  colnames(points) <-  c("x", "y")
  points$id <- rownames(points)
  
  # Create a proximity matrix of the paths to be plotted.
  proximity <- abs(rdf)
  proximity[upper.tri(proximity)] <- NA
  diag(proximity) <- NA
  proximity[proximity < min_cor] <- NA
  
  # Produce a data frame of data needed for plotting the paths.
  n_paths <- sum(!is.na(proximity))
  paths <- data.frame(matrix(nrow = n_paths, ncol = 6)) 
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
  
  plot_ <- list(
    # For plotting paths
    if (curved) geom_curve(data = paths,
                           aes(x = x, y = y, xend = xend, yend = yend,
                               alpha = proximity, size = proximity,
                               colour = proximity*sign)), 
    if (!curved) geom_segment(data = paths,
                              aes(x = x, y = y, xend = xend, yend = yend,
                                  alpha = proximity, size = proximity,
                                  colour = proximity*sign)), 
    scale_alpha(limits = c(0, 1)),
    scale_size(limits = c(0, 1)),
    scale_colour_gradientn(limits = c(-1, 1), colors = colours),
    # Plot the points
    geom_point(data = points,
                        aes(x, y),
                        size = 3, shape = 19, colour = "white"),
    # Plot variable labels
    if (repel) ggrepel::geom_text_repel(data = points,
                                        aes(x, y, label = id),
                                        fontface = 'bold', size = 5,
                                        segment.size = 0.0,
                                        segment.color = "white"),
    if (!repel) geom_text(data = points,
                          aes(x, y, label = id),
                          fontface = 'bold', size = 5),
    # expand the axes to add space for curves
    expand_limits(x = c(min(points$x) - .1,
                                 max(points$x) + .1),
                           y = c(min(points$y) - .1,
                                 max(points$y) + .1)
    ),
    # Theme and legends
    theme_void(),
    guides(size = "none", alpha = "none"),
    if (legend)  labs(colour = NULL),
    if (!legend) theme(legend.position = "none")
  )

  ggplot() + plot_

}
