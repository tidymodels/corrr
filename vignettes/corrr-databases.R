## ----setup, include = FALSE----------------------------------------------
library(dplyr)
library(dbplyr)
library(corrr)

knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ------------------------------------------------------------------------
con <- DBI::dbConnect(RSQLite::SQLite(), path = ":dbname:")

db_mtcars <- copy_to(con, mtcars)

## ------------------------------------------------------------------------
library(dplyr)
library(corrr)

db_mtcars %>%
  correlate(use = "complete.obs")

## ------------------------------------------------------------------------
db_mtcars %>%
  correlate(use = "complete.obs") %>%
  rplot()

