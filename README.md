corrr
================

corrr is a package for making it easy to conduct and interpret correlations.

You can install:

-   the latest development version from github with

``` r
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("drsimonj/corrr")
```

Getting Started
---------------

The central aspect of corrr is working with a data frame of correlations. The primary function of corrr is `cor_frame()`, which extends `stats::cor()` by returning the correlations (`r`) and corresponding sample sizes (`n`) of each pair of variables (`vars`) in a `dplyr::data_frame()`.

``` r
library(MASS)
library(corrr)

# Simulate four columns correlating about .7 with each other
mu <- rep(0, 4)
Sigma <- matrix(.7, nrow = 4, ncol = 4) + diag(4)*.3
set.seed(1) 
d <- mvrnorm(n = 1000, mu = mu, Sigma = Sigma)

# Insert a few missing values
d[100:600, 1] <- NA
d[320:322, 2] <- NA

# Use corrr::cor_frame() to obtain a data frame of the correlations
cor_frame(d)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##     vars         r     n
    ##    (chr)     (dbl) (dbl)
    ## 1 v1<>v2 0.6957043   499
    ## 2 v1<>v3 0.7013888   499
    ## 3 v1<>v4 0.6910351   499
    ## 4 v2<>v3 0.7004749   997
    ## 5 v2<>v4 0.7022015   997
    ## 6 v3<>v4 0.7029762  1000

We also have the option to gain the same information in a list of two matrix objects using `cor_matrix()`

``` r
cor_matrix(d)
```

    ## $r
    ##           [,1]      [,2]      [,3]      [,4]
    ## [1,] 1.0000000 0.6957043 0.7013888 0.6910351
    ## [2,] 0.6957043 1.0000000 0.7004749 0.7022015
    ## [3,] 0.7013888 0.7004749 1.0000000 0.7029762
    ## [4,] 0.6910351 0.7022015 0.7029762 1.0000000
    ## 
    ## $n
    ##      [,1] [,2] [,3] [,4]
    ## [1,]  499  499  499  499
    ## [2,]  499  997  997  997
    ## [3,]  499  997 1000 1000
    ## [4,]  499  997 1000 1000
    ## 
    ## attr(,"class")
    ## [1] "r_mat" "list"
