## ----setup, echo = FALSE-------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ---- message = F, warning = F-------------------------------------------
library(corrr)
d <- correlate(mtcars)
d

## ---- message=F, warning=F-----------------------------------------------
library(dplyr)

# Filter rows to occasions in which cyl has a correlation of .7 or more with
# another variable.
d %>% filter(cyl > .7)

# Select the mpg, cyl and disp columns (and rowname)
d %>% select(rowname, mpg, cyl, disp)

# Combine above in a single pipeline
d %>%
  filter(cyl > .7) %>% 
  select(rowname, mpg, cyl, disp)

## ---- warning = FALSE, message = FALSE-----------------------------------
# Compute mean of each column
library(purrr)
d %>% select(-rowname) %>% map_dbl(~ mean(., na.rm = TRUE))

## ------------------------------------------------------------------------
d %>% focus(mpg, cyl)

## ------------------------------------------------------------------------
d %>%
  focus(mpg:drat, mirror = TRUE) %>%  # Focus only on mpg:drat
  shave() %>% # Remove the upper triangle
  fashion()   # Print in nice format 

## ---- warning = FALSE----------------------------------------------------
d %>%
  focus(mpg:drat, mirror = TRUE) %>%
  shave(upper = FALSE) %>%
  rplot()     # Plot

## ---- warning = FALSE----------------------------------------------------
d %>%
  focus(mpg:drat, mirror = TRUE) %>%
  rearrange(absolute = FALSE) %>% 
  shave() %>%
  rplot()

