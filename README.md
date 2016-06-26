corrr
================

corrr is a package for exploring **corr**elation matrices in **R**. It provides methods for doing routine tasks when exploring correlation matrices such as comparing only some variables against others, or arranging the matrix in terms of the strength of the correlations, and so it. It also provides visualisation methods for extracting useful information such as variable clustering and latent dimensionality.

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

Using corrr tyically begins with the function, `correlate()`. This is a simple extension of, and used is the same manner as, `stats::cor()`, but appends a new class to the returned matrix: `r_mat`. It also uses pairwise deletion by default. The result can be used like any other matrix object, but new functions support its exploration. For example, by default, it is printed to two decimal places.

corrr is intended to be used for exploration and visualisation, NOT for statistical modeling (obtaining p values, factor analysis, etc.).

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

# Insert some missing values
d[sample(1:nrow(d), 100, replace = TRUE), 1] <- NA
d[sample(1:nrow(d), 200, replace = TRUE), 5] <- NA

# Correlate
r_matrix <- correlate(d)
class(r_matrix)
```

    ## [1] "r_mat"  "matrix"

``` r
r_matrix
```

    ##      [,1] [,2] [,3] [,4] [,5] [,6]
    ## [1,]       .71  .71  .00  .02 -.04
    ## [2,]  .71       .70 -.01  .01 -.03
    ## [3,]  .71  .70      -.03  .00 -.02
    ## [4,]  .00 -.01 -.03       .42  .44
    ## [5,]  .02  .01  .00  .42       .43
    ## [6,] -.04 -.03 -.02  .44  .43

The number of printed decimal places can be altered with a second argument in print. For example, print four decimal places with:

``` r
print(r_matrix, 4)
```

    ##      [,1]   [,2]   [,3]   [,4]   [,5]   [,6]  
    ## [1,]         .7099  .7093  .0002  .0214 -.0435
    ## [2,]  .7099         .6974 -.0133  .0093 -.0338
    ## [3,]  .7093  .6974        -.0253  .0011 -.0201
    ## [4,]  .0002 -.0133 -.0253         .4214  .4425
    ## [5,]  .0214  .0093  .0011  .4214         .4254
    ## [6,] -.0435 -.0338 -.0201  .4425  .4254
