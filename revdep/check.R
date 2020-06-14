#remotes::install_github("r-lib/revdepcheck")
library(revdepcheck)
revdep_reset()
revdep_check(num_workers = 4, bioc = FALSE)
