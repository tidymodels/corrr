# corrr 0.2.0.9000

## New Functionality

- Can keep leading zeros when using `fashion()` with new arguement `leading_zeros = TRUE`.
- Optional `legend` argument added to `network_plot()` and `rplot()` to display a legend mapping correlations to size and colour.

## Fixes

- `network_plot()` no longer plots wrong colours if only positive correlations are included.
- Colour scheme for `network_plot()` changed to match `rplot()`.

# corrr 0.2.0

## New Functions

- `network_plot()` the correlations.
- `focus_()` for standard evaluation version of `focus()`.

## New Functionality

- `fashion()` will now attempt to work on any object (not just `cor_df`), making it useful for printing any data frame, matrix, vector, etc.
- `print_cor` argument added to `rplot()` to overlay the correlations as text.

## Other

- `na_omit` arguement in `stretch()` changed to `na.rm` to match `gather_()`.
- Bug fixes.
- Improvements.

# corrr 0.1.0

- First corrr release!