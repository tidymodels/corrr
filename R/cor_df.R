# Utility --------------------------------------------------------------

#' @export
as_matrix.cor_df <- function(x, diagonal) {

  # Separate term names
  row_name <- x$term
  x <- x[colnames(x) != "term"]
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

  # Separate term names
  row_name <- x$term
  x <- x[colnames(x) != "term"]

  # Remove upper matrix
  if (upper) {
    x[upper.tri(x)] <- NA
  } else {
    x[lower.tri(x)] <- NA
  }

  # Reappend terms and class
  new_cordf(x, row_name)
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
  # "c(1, 1 + ..." to handle term column
  x <- x[ord, c(1, 1 + ord)]
  new_cordf(x)
}


# Reshape -----------------------------------------------------------------

#' @export
focus_.cor_df <- function(x, ..., .dots = NULL, mirror = FALSE) {
  vars <- enquos(...)
  row_name <- x$term
  if (length(vars) > 0) {
    x <- dplyr::select(x, !!!vars)
  } else {
    x <- dplyr::select(x, .dots)
  }
  # Get selected column names and
  # append back term names if necessary
  vars <- colnames(x)
  if ("term" %in% vars) {
    vars <- vars[vars != "term"]
  } else {
    x <- first_col(x, row_name)
  }

  # Exclude these or others from the rows
  vars <- x$term %in% vars
  if (mirror) {
    x <- new_cordf(x[vars, ])
  } else {
    x <- x[!vars, ]
  }
  x
}

#' @export
focus_if.cor_df <- function(x, .predicate, ..., mirror = FALSE) {

  # Identify which variables to keep
  to_keep <- map_lgl(
    x[colnames(x) != "term"],
    .predicate, ...
  )

  to_keep <- names(to_keep)[!is.na(to_keep) & to_keep]

  if (!length(to_keep)) {
    rlang::abort("No variables were TRUE given the function.")
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
                         .order = c("default", "alphabet")) {
  .order <- match.arg(.order)

  if (!missing(colors)) {
    colours <- colors
  }

  # Store order for factoring the variables
  row_order <- rdf$term

  # Convert data to relevant format for plotting
  pd <- stretch(rdf, na.rm = TRUE)
  pd$size <- abs(pd$r)
  pd$label <- as.character(fashion(pd$r))

  if (.order == "default") {
    pd$x <- factor(pd$x, levels = row_order)
    pd$y <- factor(pd$y, levels = rev(row_order))
  }

  plot_ <- list(
    # Geoms
    geom_point(shape = shape),
    if (print_cor) geom_text(color = "black", size = 3, show.legend = FALSE),
    scale_colour_gradientn(limits = c(-1, 1), colors = colours),
    # Theme, labels, and legends
    theme_classic(),
    labs(x = "", y = ""),
    guides(size = "none", alpha = "none"),
    if (legend) labs(colour = NULL),
    if (!legend) theme(legend.position = "none")
  )

  ggplot(pd, aes_string(
    x = "x", y = "y", color = "r",
    size = "size", alpha = "size",
    label = "label"
  )) +
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
                                legend = c("full", "range", "none"),
                                colours = c("indianred2", "white", "skyblue1"),
                                repel = TRUE,
                                curved = TRUE,
                                colors) {
  legend <- rlang::arg_match(legend)

  if (min_cor < 0 || min_cor > 1) {
    rlang::abort("min_cor must be a value ranging from zero to one.")
  }

  if (!missing(colors)) {
    colours <- colors
  }

  rdf <- as_matrix(rdf, diagonal = 1)
  distance <- 1 - abs(rdf)

  points <- if (ncol(rdf) == 1) {
    # 1 var: a single central point
    matrix(c(0, 0), ncol = 2, dimnames = list(colnames(rdf)))
  } else if (ncol(rdf) == 2) {
    # 2 vars: 2 opposing points
    matrix(c(0, -0.1, 0, 0.1), ncol = 2, dimnames = list(colnames(rdf)))
  } else {
    # More than 2 vars: multidimensional scaling to obtain x and y coordinates for points.
    suppressWarnings(stats::cmdscale(distance, k = 2))
  }

  if (ncol(points) < 2) {
    cont_flag <- FALSE
    shift_matrix <- matrix(1,
      nrow = nrow(rdf),
      ncol = ncol(rdf)
    )
    diag(shift_matrix) <- 0

    for (shift in 10^(-6:-1)) {
      shifted_distance <- distance + shift * shift_matrix
      points <- suppressWarnings(stats::cmdscale(shifted_distance))

      if (ncol(points) > 1) {
        cont_flag <- TRUE
        break
      }
    }

    if (!cont_flag) rlang::abort("Can't generate network plot.\nAttempts to generate 2-d coordinates failed.")

    rlang::warn("Plot coordinates derived from correlation matrix have dimension < 2.\nPairwise distances have been adjusted to facilitate plotting.")
  }



  points <- data.frame(points)
  colnames(points) <- c("x", "y")
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
  for (row in 1:nrow(proximity)) {
    for (col in 1:ncol(proximity)) {
      path_proximity <- proximity[row, col]
      if (!is.na(path_proximity)) {
        path_sign <- sign(rdf[row, col])
        x <- points$x[row]
        y <- points$y[row]
        xend <- points$x[col]
        yend <- points$y[col]
        paths[path, ] <- c(x, y, xend, yend, path_proximity, path_sign)
        path <- path + 1
      }
    }
  }

  if(legend %in% c("full", "none")){
    legend_range = c(-1, 1)
  }
  else if(legend == "range"){
    legend_range = c(min(rdf[row(rdf)!=col(rdf)]),
                     max(rdf[row(rdf)!=col(rdf)]))
  }
  plot_ <- list(
    # For plotting paths
    if (curved) {
      geom_curve(
        data = paths,
        aes(
          x = x, y = y, xend = xend, yend = yend,
          alpha = proximity, size = proximity,
          colour = proximity * sign
        )
      )
    },
    if (!curved) {
      geom_segment(
        data = paths,
        aes(
          x = x, y = y, xend = xend, yend = yend,
          alpha = proximity, size = proximity,
          colour = proximity * sign
        )
      )
    },
    scale_alpha(limits = c(0, 1)),
    scale_size(limits = c(0, 1)),
    scale_colour_gradientn(limits = legend_range, colors = colours),
    # Plot the points
    geom_point(
      data = points,
      aes(x, y),
      size = 3, shape = 19, colour = "white"
    ),
    # Plot variable labels
    if (repel) {
      ggrepel::geom_text_repel(
        data = points,
        aes(x, y, label = id),
        fontface = "bold", size = 5,
        segment.size = 0.0,
        segment.color = "white"
      )
    },
    if (!repel) {
      geom_text(
        data = points,
        aes(x, y, label = id),
        fontface = "bold", size = 5
      )
    },
    # expand the axes to add space for curves
    expand_limits(
      x = c(
        min(points$x) - .1,
        max(points$x) + .1
      ),
      y = c(
        min(points$y) - .1,
        max(points$y) + .1
      )
    ),
    # Theme and legends
    theme_void(),
    guides(size = "none", alpha = "none"),
    if (legend != "none") labs(colour = NULL),
    if (legend == "none") theme(legend.position = "none")
  )

  ggplot() + plot_
}

#' Create a correlation matrix from a cor_df object
#'
#' This method provides a good first visualization of the correlation matrix.
#'
#' @param object A `cor_df` object.
#' @param ... this argument is ignored.
#' @inheritParams rearrange
#' @param triangular Which part of the correlation matrix should be shown?
#' Must be one of `"upper"`, `"lower"`, or `"full"`, and defaults to `"upper"`.
#' @param barheight A single, non-negative number. Is passed to
#' [ggplot2::guide_colourbar()] to determine the height of the guide colorbar.
#' Defaults to 20, is likely to need manual adjustments.
#' @param low A single color. Is passed to [ggplot2::scale_fill_gradient2()].
#' The color of negative correlation. Defaults to `"#B2182B"`.
#' @param mid A single color. Is passed to [ggplot2::scale_fill_gradient2()].
#' The color of no correlation. Defaults to `"#F1F1F1"`.
#' @param high A single color. Is passed to [ggplot2::scale_fill_gradient2()].
#' The color of the positive correlation. Defaults to `"#2166AC"`.
#' @return A ggplot object
#'
#' @rdname autoplot.cor_df
#'
#' @examples
#' x <- correlate(mtcars)
#'
#' autoplot(x)
#'
#' autoplot(x, triangular = "lower")
#'
#' autoplot(x, triangular = "full")
#' @export
autoplot.cor_df <- function(object, ...,
                            method = "PCA",
                            triangular = c("upper", "lower", "full"),
                            barheight = 20,
                            low = "#B2182B",
                            mid = "#F1F1F1",
                            high = "#2166AC") {

  triangular <- rlang::arg_match(triangular)

  object <- rearrange(object, method = method)
  if (triangular == "upper") {
    object <- shave(object, upper = FALSE)
  } else if (triangular == "lower") {
    object <- shave(object, upper = TRUE)
  }
  object <- stretch(object)
  object <- dplyr::mutate(object, x = factor(x, levels = unique(x)))
  object <- dplyr::mutate(object, y = factor(y, levels = rev(unique(y))))
  object <- dplyr::filter(object, !is.na(r))

  res <- ggplot2::ggplot(object, ggplot2::aes(x, y, fill = r)) +
    ggplot2::geom_tile(color = "white", size = 0.5) +
    ggplot2::scale_fill_gradient2(
      low = low, mid = mid, high = high, breaks = seq(-1, 1, by = 0.2),
      limits = c(-1, 1)
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust = 1)
    ) +
    ggplot2::coord_fixed() +
    ggplot2::labs(x = NULL, y = NULL, fill = NULL) +
    ggplot2::guides(fill = ggplot2::guide_colourbar(barheight = barheight))

  if (triangular == "upper") {
    res <- res +
      scale_x_discrete(position = "top") +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(angle = 315, vjust = 1, hjust = 1)
      )
  }

  res
}

#' @importFrom ggplot2 autoplot
#' @export
ggplot2::autoplot
