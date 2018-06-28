## Release summary

- `as_cordf` will coerce lists or matrices into correlation data frames if possible

- `focus_if` enables conditional variable selection

- Can use arithmetic operators (e.g., `+` or `-`) with correlation data frames

- `correlate()` now supports data frame with a SQL back-end (`tbl_sql`)

- Small breaking change: The `diagonal` argument of `as_matrix` and `as_matrix.cor_df` is now an optional argument rather than set to `1` by default 

- Other improvements and fixes

## Test environments
* local Windows 10 install, R 3.5.0
* ubuntu 14.04 (on travis-ci)
* Ubuntu 14.04.5 LTS with RStudio Server, R 3.4.3 

## R CMD check results

- 0 errors | 0 warnings | 0 notes

## revdep check results

- 0 packages