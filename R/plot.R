#' @export
plot.cor_df <- function(x) {
  x <- cor_matrix(x)
  plot(x)
}

#' @export
plot.cor_mat <- function(x) {
  # Set the proportion of paths to be drawn
  prop_draw <- .50
  
  # Get var names
  vars <- rownames(x$r)

  # Convert correlations to a distance matrix.
  distance <- sign(x$r) * (1 - abs(x$r))

  # Use multidimensional Scaling to obtain x and y coordinates for points.
  points <- distance %>%
    abs() %>%
    stats::cmdscale() %>%
    data.frame() %>%
    dplyr::rename(x = X1, y = X2) %>%
    dplyr::mutate(id = vars)

  # Create a proximity matrix of the paths to be plotted.
  # This requires:
  #   1. Pruning the distance matrix to
  #      a. only include a proportion of the closest points (prop_draw).
  #      b. Remove any paths between points with a distance of 0 (as path cannot be drawn).
  #   2. Inverting the values (from distance to proximity).
  #   3. Scaling values within range of 0 - 1 to suit `alpha` in the plot.
  proximity <- abs(distance)
  # Step 1a.
  proximity[upper.tri(proximity)] <- NA
  diag(proximity) <- NA
  proximity[proximity > quantile(proximity, prop_draw, na.rm = TRUE)] <- NA
  # Step 1b.
  proximity[proximity == 0] <- NA
  # Step 2.
  proximity <- max(proximity, na.rm = TRUE) - proximity
  # Step 3.
  proximity <- (proximity - min(proximity, na.rm = TRUE)) / (max(proximity, na.rm = TRUE) - min(proximity, na.rm = TRUE))
  proximity <- .7 * proximity  # limit path alpha to .7 instead of 1
  
  # Produce a data frame of data needed for plotting the paths.
  n_paths <- sum(!is.na(proximity))
  paths <- matrix(nrow = n_paths, ncol = 6) %>% data.frame()
  colnames(paths) <- c("x", "y", "xend", "yend", "proximity", "sign")
  
  path <- 1
  for(row in 1:nrow(distance)) {
    for(col in 1:ncol(distance)) {
      path_proximity <- proximity[row, col]
      path_sign <- sign(distance[row, col])
      if (!is.na(path_proximity)) {
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
                        ggplot2::aes(x = x, y = y,
                                     xend = xend, yend = yend,
                                     alpha = proximity,
                                     colour = factor(sign)),
                        show.legend = FALSE) +
    # Plot the points
    ggplot2::geom_point(data = points,
                        ggplot2::aes(x, y),
                        size = 3, alpha = .5, shape = 1, colour = "white") +
    # Plot variable labels
    ggplot2::geom_text(data = points,
                       ggplot2::aes(x, y, label = id),
                       size = 8, colour = "white") +
    # expand the axes to add space for curves etc
    ggplot2::expand_limits(x = c(min(points$x) - .1 * sd(points$x),
                                 max(points$x) + .1 * sd(points$x)),
                           y = c(min(points$y) - .2 * sd(points$y),
                                 max(points$y) + .2 * sd(points$y))
    ) +
    ggplot2::theme(
      axis.title       = ggplot2::element_blank(),
      axis.text        = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "#01001C",
                                               colour = NA),
      panel.grid       = ggplot2::element_blank(),
      axis.ticks.length= unit(0, "cm"),
      panel.margin     = unit(0, "lines"),
      complete         = TRUE
    )
}