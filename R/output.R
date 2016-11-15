#' Fashion a correlation data frame for printing.
#' 
#' For the purpose of printing, convert a correlation data frame into a noquote 
#' matrix with the correlations cleanly formatted (leading zeros removed; spaced
#' for signs) and the diagonal (or any NA) left blank.
#' 
#' @param x Scalar, vector, matrix or data frame.
#' @param decimals Number of decimal places to display for numbers.
#' @param leading_zeros Should leading zeros be displayed for decimals (e.g., 0.1)? If FALSE, they will be removed. 
#' @param na_print Character string indicating NA values in printed output
#' @return noquote. Also a data frame if x is a matrix or data frame.
#' @export
#' @examples 
#' # Examples with correlate()
#' mtcars %>% correlate() %>% fashion()
#' mtcars %>% correlate() %>% fashion(decimals = 1)
#' mtcars %>% correlate() %>% fashion(leading_zeros = TRUE)
#' mtcars %>% correlate() %>% fashion(na_print = "*")
#' 
#' # But doesn't have to include correlate()
#' mtcars %>% fashion(decimals = 3)
#' c(0.234, 134.23, -.23, NA) %>% fashion(na_print = "X")
fashion <- function(x, decimals = 2, leading_zeros = FALSE, na_print = "") {
  UseMethod("fashion")
}

#' @export
fashion.default <- function(x, decimals = 2, leading_zeros = FALSE, na_print = "") {
  
  # Handle numbers
  if (is.numeric(x)) {
    tmp <- stats::na.omit(x)
    n_dig <- length(tmp)
    
    if (n_dig) {
      
      # Format to correct number of decimals and keep/remove any leading zeros
      if (leading_zeros) {
        tmp <- sprintf(paste0("%.", decimals, "f"), tmp)
      } else {
        tmp <- sub("^-0.", "-\\1.", sprintf(paste0("%.", decimals, "f"), tmp))
        tmp <- sub("^0.", " \\1.", tmp) 
      }
      
      # Pad mulitple digits to appear right justified
      if (n_dig > 1) {
        n_chars <- nchar(tmp)
        longest <- max(n_chars)
        tmp <- (longest - n_chars) %>%
          purrr::map_chr(~paste(rep(" ", .), collapse = "")) %>% 
          paste0(tmp) 
      }
      
      # Insert back to x
      x[!is.na(x)] <- tmp
    }
  }
  
  x <- as.character(x)
  x[is.na(x) | x == "NA"] <- na_print
  noquote(x)
}

#' Plot a correlation data frame.
#' 
#' Plot a correlation data frame using ggplot2.
#' 
#' @param rdf Correlation data frame (see \code{\link{correlate}}) or object
#'   that can be coerced to one (see \code{\link{as_cordf}}).
#' @param legend Boolean indicating whether a legend mapping the colours to the correlations should be displayed.
#' @param shape \code{\link{geom_point}} aesthetic.
#' @param print_cor Boolean indicating whether the correlations should be printed over the shapes.
#' @param colours,colors Vector of colours to use for n-colour gradient.
#' @return Plots a correlation data frame
#' @export
#' @examples 
#' x <- correlate(mtcars)
#' rplot(x)
#' 
#' # Common use is following rearrange and shave
#' x <- rearrange(x, absolute = FALSE)
#' x <- shave(x)
#' rplot(x)
#' rplot(x, print_cor = TRUE)
#' rplot(x, shape = 20, colors = c("red", "green"), legend = TRUE)
rplot <- function(rdf,
                  legend = FALSE,
                  shape = 16,
                  colours = c("indianred2", "white", "skyblue1"),
                  print_cor = FALSE,
                  colors) {
  UseMethod("rplot")
}

#' @export
rplot.default <- function(rdf, ...) {
  rdf <- as_cordf(rdf)
  rplot.cor_df(rdf, ...)  
}

#' Network plot of a correlation data frame
#' 
#' Output a network plot of a correlation data frame in which variables that are
#' more highly correlated appear closer together and are joined by stronger
#' paths. Paths are also coloured by their sign (blue for positive and red for
#' negative). The proximity of the points are determined using multidimensional
#' clustering.
#' 
#' @param min_cor Number from 0 to 1 indicating the minimum value of
#'   correlations (in absolute terms) to plot.
#' @param colours,colors Vector of colours to use for n-colour gradient.
#' @param repel Should variable labels repel each other? If TRUE, text is added
#'   via ggrepel::geom_text_repel instead of ggplot2::geom_text
#' @inheritParams rplot
#' @export
#' @examples 
#' x <- correlate(mtcars)
#' network_plot(x)
#' network_plot(x, min_cor = .1)
#' network_plot(x, min_cor = .6)
#' network_plot(x, min_cor = .7, colors = c("red", "green"), legend = TRUE)
network_plot <- function(rdf,
                         min_cor = .3,
                         legend = FALSE,
                         colours = c("indianred2", "white", "skyblue1"),
                         repel = TRUE,
                         colors) {
  UseMethod("network_plot")
}


#' @export
network_plot.default <- function(rdf, ...) {
  rdf <- as_cordf(rdf)
  network_plot.cor_df(rdf, ...)  
}