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
#' mtcars %>% fashion(decimlas = 3)
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
#' Plot a correlation data frame using ggplot.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param print_cor Boolean indicating whether the correlations should be printed over the shapes.
#' @param shape \code{\link{geom_point}} aesthetic.
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
rplot <- function(x, print_cor, shape) {
  UseMethod("rplot")
}

#' Network plot of a correlation data frame
#' 
#' Output a network plot of a correlation data frame in which variables that are
#' more highly correlated appear closer together and are joined by stronger
#' paths. Paths are also coloured by their sign (blue for positive and red for
#' negative). The proximity of the points are determined using multidimensional
#' clustering.
#' 
#' @param x cor_df. See \code{\link{correlate}}.
#' @param min_cor Number from 0 to 1 indicating the minimum value of
#'   correlations (in absolute terms) to plot.
#' @export
#' @examples 
#' x <- correlate(mtcars)
#' network_plot(x)
#' network_plot(x, min_cor = .1)
#' network_plot(x, min_cor = .6)
network_plot <- function(x, min_cor) {
  UseMethod("network_plot")
}
