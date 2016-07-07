## Test environments
* local OS X install, R 3.3.1

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking R code for possible problems ... NOTE
  as_matrix.cor_df: no visible binding for global variable 'rowname'
  correlate: no visible binding for global variable '.'
  fashion.cor_df: no visible binding for global variable 'rowname'
  fashion.cor_df: no visible binding for global variable '.'
  focus.cor_df: no visible binding for global variable '.'
  focus.cor_df: no visible binding for global variable 'rowname'
  rplot.cor_df: no visible binding for global variable 'y'
  rplot.cor_df: no visible binding for global variable 'r'
  rplot.cor_df: no visible binding for global variable 'size'
  rplot.cor_df: no visible binding for global variable 'label'
  shave.cor_df: no visible binding for global variable 'rowname'
  stretch.cor_df: no visible binding for global variable 'r'
  stretch.cor_df: no visible binding for global variable 'rowname'
  
  This is due to use of non-standard evaluation in functions from dplyr package.

## Downstream dependencies

There are currently no downstream dependencies for this package.
