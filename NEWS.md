# News

Newest versions at top.

## `mcbette` 1.9 (2020-10-10)

### NEW FEATURES

 * Transferred repository ownership to rOpenSci 

### MINOR IMPROVEMENTS

 * Processed feedback rOpenSci
 * Processed feedback JOSS

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.8.4 (2020-05-21)

### NEW FEATURES

 * None

### MINOR IMPROVEMENTS

 * Use CRAN versions of babette packages

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.8.3 (2020-02-24)

### NEW FEATURES

 * Add `mcbette_self_test` to self-test `mcbette`
 * Add `mcbette_report` to print all information needed for a bug report
 * Add `get_mcbette_state` and `set_mcbette_state` to store and restore
   the `mcbette` state. `check_mcbette_state` verifies if `mcbette` is in
   one of these three states: (1) both BEAST2 and the BEAST NS are installed,
   (2) only BEAST2 is installed (3) neither BEAST2 and the BEAST NS are 
   installed

### MINOR IMPROVEMENTS

 * Separated the package `mcbette` from a script running it.
   The latter can be found at 
   [https://github.com/ropensci/mcbette_run](https://github.com/ropensci/mcbette_run)
 * Add `README.Rmd`, build `README.md` from it
 * Add AppVeyor build, even though the core feature of `mcbette` 
   requires Linux or MacOS

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.8.2 (2020-01-15)

### NEW FEATURES

 * None

### MINOR IMPROVEMENTS

 * Added `can_run_mcbette` as a shorthand for three if-statements
 * Added `create_ns_inference_model` for convenience, as it is the same
   as `create_inference_model(mcmc = create_ns_mcmc(...), ...)`. This
   function will be moved to `beautier` in a future version
 * Vignette uses BEAST2 example alignment, instead of a simulated alignment
 * Prepare for rOpenSci review
 * Added more and better examples to the documentation

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.8.1 (2020-01-14)

### NEW FEATURES

 * None

### MINOR IMPROVEMENTS

 * Use CRAN version of `babette`

### BUG FIXES

 * None

### DEPRECATED AND DEFUNCT

 * None

## `mcbette` 1.8 (2020-01-06)

### NEW FEATURES

 * Follow interface of beautier v2.3

### MINOR IMPROVEMENTS

 * Use CRAN versions of `beautier`, `beastier`, `tracerer`, `mauricer`
 * Processed all @lintr-bot's comments

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
