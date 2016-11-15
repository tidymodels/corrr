# corrr 0.2.1.9000

## New Functionality

- `as_cordf` added to coerce lists or matrices into correlation data frames.
- Can use arithmetic operators (e.g., `+` or `-`) with correlation data frames.
- `focus_if` added to enable conditional variable selection.

# corrr 0.2.1

## New Functionality

- Can keep leading zeros when using `fashion()` with new argument `leading_zeros = TRUE`.
- New optional arguments added to plotting functions, `network_plot()` and `rplot()`:
  - `legend` to display a legend mapping correlations to size and colour.
  - `colours` (or `colors`) to change colours in plot.

## Fixes

- `network_plot()` no longer plots wrong colours if only positive correlations are included.
- Colour scheme for `network_plot()` changed to match `rplot()`.
- Other bug fixes.

# corrr 0.2.0

## New Functions

- `network_plot()` the correlations.
- `focus_()` for standard evaluation version of `focus()`.

## New Functionality

- `fashion()` will now attempt to work on any object (not just `cor_df`), making it useful for printing any data frame, matrix, vector, etc.
- `print_cor` argument added to `rplot()` to overlay the correlations as text.

## Other

- `na_omit` argument in `stretch()` changed to `na.rm` to match `gather_()`.
- Bug fixes.
- Improvements.

# corrr 0.1.0

- First corrr release!