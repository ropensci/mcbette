# News

Newest versions at top.

## `mcbette` 1.8 (2019-10-27)

### NEW FEATURES

 * Follow interface of beautier v2.3

### MINOR IMPROVEMENTS

 * None

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.7 (2019-09-10)

### NEW FEATURES

 * Higher number of particles do result in a better estimation
 * Renamed `est_marg_liks_from_models` to `est_marg_liks`,
   removed the old `est_marg_liks`

### MINOR IMPROVEMENTS

 * None

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None


## `mcbette` 1.6 (2019-08-27)

### NEW FEATURES

 * None

### MINOR IMPROVEMENTS

 * Creates BEAST2 temporary files in same folder as the BEAST2 working
   folder. This allows `mcbette` to run on the Groninger Peregrine
   computer cluster

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.5 (2019-08-18)

### NEW FEATURES

 * Show effective sample size in marginal likelihood estimation

### MINOR IMPROVEMENTS

 * None

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None


## `mcbette` 1.4 (2019-08-15)

### NEW FEATURES

 * Removed duplicate `epsilon` argument from `est_marg_liks_from_model`:
   use the `epsilon` supplied in the inference models' nested sampling
   MCMC

### MINOR IMPROVEMENTS

 * Better error message when using a CBS site model and too few taxa

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.3 (2019-08-14)

### NEW FEATURES

 * Added `est_marg_lik` to estimate a single marginal likelihood
 * Disallow failed marginal likelihood estimations in `est_marg_liks`:
   the resulting table will never contain `NA`s

### MINOR IMPROVEMENTS

 * Better error message when using a CBS site model and too few taxa
 * Builds on Bionic

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.2

An untagged release

## `mcbette` 1.1 (2019-05-29)

### NEW FEATURES

 * None

### MINOR IMPROVEMENTS

 * Travis builds on three operating systems

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None
