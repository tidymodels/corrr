corrr
================

corrr is a package for exploring **corr**elation matrices in **R**. It makes it possible to easily perform routine tasks when exploring correlation matrices such as focusing on the correlations of certain variables against others, or arranging the matrix in terms of the strength of the correlations, and so on. `corrr` also provides visualisation methods for extracting useful information such as variable clustering and latent dimensionality.

`corrr` is intended to be used for exploration and visualisation, NOT for statistical modeling (obtaining p values, factor analysis, etc.).

You can install:

-   the latest development version from github with

``` r
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("drsimonj/corrr")
```

Using corrr
-----------

Using `corrr` starts with `correlate()`, which acts just like `stats::cor()` (though with pairwise deletion by default), but returns the result as a correlation data frame (`cor_df`). A correlation data frame is simply a correlation matrix in the following structure:

-   A *tbl* with an additional class, `cor_df`
-   An extra "rowname" column
-   Standardised variances (the matrix diagonal) set to missing values (`NA`) so they can be omitted in calculations.

### API

The API of corrr is designed with data pipelines in mind (e.g., to use `%>%` from the magrittr package). After `correlate()`, all functions take a `cor_df` as their first arguement, and return a `cor_df` or `tbl` (or output like a plot). The primary corrr functions do one of three major tasks with a `cor_df`:

Change internal values (`cor_df` in, `cor_df` out):

-   `shave()` sets the upper (or lower) triangle to NA.
-   `rearrange()` uses seriation to arrange the columns (and rows) in terms of the correlation strengths.

Reshape values (`cor_df` in, `tbl` or `cor_df` out):

-   `focus()` reduces to some columns against others (or themselves).
-   `stretch()` converts to a long format.

Generate output/visualsations (`cor_df` in, console/plot out):

-   `rplot()` plots the correlations.

Examples
--------

``` r
library(MASS)
library(corrr)
set.seed(1)

# Simulate three columns correlating about .7 with each other
mu <- rep(0, 3)
Sigma <- matrix(.7, nrow = 3, ncol = 3) + diag(3)*.3
seven <- mvrnorm(n = 1000, mu = mu, Sigma = Sigma)

# Simulate three columns correlating about .4 with each other
mu <- rep(0, 3)
Sigma <- matrix(.4, nrow = 3, ncol = 3) + diag(3)*.6
four <- mvrnorm(n = 1000, mu = mu, Sigma = Sigma)

# Bind together
d <- cbind(seven, four)
colnames(d) <- paste0("v", 1:ncol(d))

# Insert some missing values
d[sample(1:nrow(d), 100, replace = TRUE), 1] <- NA
d[sample(1:nrow(d), 200, replace = TRUE), 5] <- NA

# Correlate
x <- correlate(d)
class(x)
```

    ## [1] "cor_df"     "tbl_df"     "tbl"        "data.frame"

``` r
x
```

    ## Source: local data frame [6 x 7]
    ## 
    ##   rowname            v1          v2           v3            v4          v5
    ##     <chr>         <dbl>       <dbl>        <dbl>         <dbl>       <dbl>
    ## 1      v1            NA  0.70986371  0.709330652  0.0001947192 0.021359764
    ## 2      v2  0.7098637068          NA  0.697411266 -0.0132575510 0.009280530
    ## 3      v3  0.7093306516  0.69741127           NA -0.0252752456 0.001088652
    ## 4      v4  0.0001947192 -0.01325755 -0.025275246            NA 0.421380212
    ## 5      v5  0.0213597639  0.00928053  0.001088652  0.4213802123          NA
    ## 6      v6 -0.0435135083 -0.03383145 -0.020057495  0.4424697437 0.425441795
    ## Variables not shown: v6 <dbl>.

Being a *tbl*, we can automatically leverage functions from packages like `dplyr`, `tidyr`, `ggplot2`, and so on:

``` r
library(dplyr)

# Filter rows by correlation size
x %>% filter(v1 > .6)
```

    ## Source: local data frame [2 x 7]
    ## 
    ##   rowname        v1        v2        v3          v4          v5
    ##     <chr>     <dbl>     <dbl>     <dbl>       <dbl>       <dbl>
    ## 1      v2 0.7098637        NA 0.6974113 -0.01325755 0.009280530
    ## 2      v3 0.7093307 0.6974113        NA -0.02527525 0.001088652
    ## Variables not shown: v6 <dbl>.

``` r
# Calculate the mean correlation for each variable
x %>%
  select(-rowname) %>%
  summarise_each(funs(mean(., na.rm = TRUE))) %>%
  round(2)
```

    ## Source: local data frame [1 x 6]
    ## 
    ##      v1    v2    v3    v4    v5    v6
    ##   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1  0.28  0.27  0.27  0.17  0.18  0.15

corrr functions are developed with the same data pipeline style in mind:

``` r
datasets::mtcars %>%
  correlate() %>%    # Create correlation data frame (cor_df)
  focus(-cyl, -vs, rows = TRUE) %>%  # Focus on cor_df without 'cyl' and 'vs'
  rearrange(method = "HC", absolute = FALSE) %>%  # arrange by correlations
  shave() %>%  # Shave off the upper triangle for a clean plot
  rplot()  # Plot the results
```

![](README_files/figure-markdown_github/combination-1.png)
