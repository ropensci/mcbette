
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mcbette

<!-- badges: start -->

[![peer-review](https://badges.ropensci.org/360_status.svg)](https://github.com/ropensci/software-review/issues/360)

| Branch    | [![Travis CI logo](man/figures/TravisCI.png)](https://travis-ci.org)                                                                 | [![AppVeyor logo](man/figures/AppVeyor.png)](https://www.appveyor.com)                                                                                                           | [![Codecov logo](man/figures/Codecov.png)](https://www.codecov.io)                                                                                                 |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `master`  | [![Build Status](https://travis-ci.org/richelbilderbeek/mcbette.svg?branch=master)](https://travis-ci.org/richelbilderbeek/mcbette)  | [![Build status](https://ci.appveyor.com/api/projects/status/co69b54ljo135b5x/branch/master?svg=true)](https://ci.appveyor.com/project/richelbilderbeek/mcbette/branch/master)   | [![codecov.io](https://codecov.io/github/richelbilderbeek/mcbette/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/mcbette?branch=master)   |
| `develop` | [![Build Status](https://travis-ci.org/richelbilderbeek/mcbette.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/mcbette) | [![Build status](https://ci.appveyor.com/api/projects/status/co69b54ljo135b5x/branch/develop?svg=true)](https://ci.appveyor.com/project/richelbilderbeek/mcbette/branch/develop) | [![codecov.io](https://codecov.io/github/richelbilderbeek/mcbette/coverage.svg?branch=develop)](https://codecov.io/github/richelbilderbeek/mcbette?branch=develop) |

<!-- badges: end -->

![](man/figures/mcbette_logo.png)

`mcbette` allows for doing a Model Comparison using `babette`
\[Bilderbeek & Etienne, 2018\]. It does so using the BEAST2 \[Bouckaert
et al., 2019\] nested sampling package as described in \[Russell et al.,
2019\].

## Installation

:warning: `mcbette` only works on Linux and Mac.

`mcbette` depends on the
[rJava](https://cran.r-project.org/package=rJava) and
[Rmpfr](https://cran.r-project.org/package=Rmpfr) packages.

On Linux, to install these, do (as root):

    apt install r-cran-rjava libmpfr-dev

After this, installing `mcbette` is easy:

``` r
remotes::install_github("richelbilderbeek/mcbette")
beastier::install_beast2()
mauricer::install_beast2_pkg("NS")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mcbette)

# An example FASTA file
fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

# A testing inference model with inaccurate (thus fast) marginal
# likelihood estimation
inference_model <- beautier::create_test_ns_inference_model()

# Estimate the marginal likelihood
marg_lik <- est_marg_lik(
  fasta_filename = fasta_filename,
  inference_model = inference_model
)

cat(marg_lik$marg_log_lik)
#> -20.00817
```

## References

  - Bilderbeek, Richel JC, and Rampal S. Etienne. “babette: BEAUti 2,
    BEAST 2 and Tracer for R.” Methods in Ecology and Evolution (2018).
    <https://doi.org/10.1111/2041-210X.13032>
  - Bouckaert R., Vaughan T.G., Barido-Sottani J., Duchêne S., Fourment
    M., Gavryushkina A., et al. (2019) BEAST 2.5: An advanced software
    platform for Bayesian evolutionary analysis. PLoS computational
    biology, 15(4), e1006650.
  - Russel, Patricio Maturana, et al. “Model selection and parameter
    inference in phylogenetics using nested sampling.” Systematic
    biology 68.2 (2019): 219-233.
