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

The central aspect of corrr is working with a data frame of correlations. To do this, we take a data frame or matrix of columns, and submit it to the function `cor_frame()`:

``` r
library(MASS)
library(corrr)

# Simulate four columns correlating .7 with each other
mu <- rep(0, 4)
Sigma <- matrix(.7, nrow = 4, ncol = 4) + diag(4)*.3
set.seed(1) 
d <- data.frame(mvrnorm(n = 1000, mu = mu, Sigma = Sigma))

# Insert a few missing values
d$X1[100:600] <- NA
d$X4[320:322] <- NA

# Use corrr::cor_frame() to obtain a data frame of the correlations
cor_frame(d)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##     vars         r     n
    ##    (chr)     (dbl) (dbl)
    ## 1 X1<>X2 0.6957043   499
    ## 2 X1<>X3 0.7013888   499
    ## 3 X1<>X4 0.6910351   499
    ## 4 X2<>X3 0.7007180  1000
    ## 5 X2<>X4 0.7022015   997
    ## 6 X3<>X4 0.7024235   997

We also have the option to gain the same information in a list of two matrix objects using `cor_matrix()`

``` r
cor_matrix(d)
```

    ## $r
    ##           X1        X2        X3        X4
    ## X1 1.0000000 0.6957043 0.7013888 0.6910351
    ## X2 0.6957043 1.0000000 0.7007180 0.7022015
    ## X3 0.7013888 0.7007180 1.0000000 0.7024235
    ## X4 0.6910351 0.7022015 0.7024235 1.0000000
    ## 
    ## $n
    ##     X1   X2   X3  X4
    ## X1 499  499  499 499
    ## X2 499 1000 1000 997
    ## X3 499 1000 1000 997
    ## X4 499  997  997 997
    ## 
    ## attr(,"class")
    ## [1] "r_mat" "list"
