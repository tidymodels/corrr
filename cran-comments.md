## Release summary

* Adds `remove.dups` argument to `stretch()`.  It removes duplicates with out removing all NAs.
* Adds `dice()` function, wraps `focus(x,..., mirror = TRUE)`
* Adds `retract()` function, opposite of `stretch()` 
* Improves `correlate()` for database backed tables
* Fixes compatibility issues with `dplyr` 

## Test environments
* Local windows 10 install, R 3.6.0
* Ubuntu 18.04.2 LTS, R 3.6.1
* Ubuntu 14.04 (on travis-ci)

## R CMD check results
* 0 errors | 0 warnings | 0 notes

## revdep check results

* Package has no current reverse dependencies
