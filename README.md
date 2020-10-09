
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mcbette

<!-- badges: start -->

[![peer-review](https://badges.ropensci.org/360_status.svg)](https://github.com/ropensci/software-review/issues/360)

| Branch    | [![Travis CI logo](man/figures/TravisCI.png)](https://travis-ci.org)                                                 | [![AppVeyor logo](man/figures/AppVeyor.png)](https://www.appveyor.com)                                                                                                    | [![Codecov logo](man/figures/Codecov.png)](https://www.codecov.io)                                                                                 |
| --------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `master`  | [![Build Status](https://travis-ci.org/ropensci/mcbette.svg?branch=master)](https://travis-ci.org/ropensci/mcbette)  | [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/mcbette?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/mcbette)  | [![codecov.io](https://codecov.io/github/ropensci/mcbette/coverage.svg?branch=master)](https://codecov.io/github/ropensci/mcbette?branch=master)   |
| `develop` | [![Build Status](https://travis-ci.org/ropensci/mcbette.svg?branch=develop)](https://travis-ci.org/ropensci/mcbette) | [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/mcbette?branch=develop&svg=true)](https://ci.appveyor.com/project/ropensci/mcbette) | [![codecov.io](https://codecov.io/github/ropensci/mcbette/coverage.svg?branch=develop)](https://codecov.io/github/ropensci/mcbette?branch=develop) |

<!-- badges: end -->

![](man/figures/mcbette_logo.png)

`mcbette` allows for doing a Model Comparison using `babette` (hence the
name), that is, given a (say, DNA) alignment, it compares multiple
phylogenetic inference models to find the model that is likeliest to
generate that alignment. With this, one can find the phylogenetic
inference model that is simple enough, but not too simple.

To do so, `mcbette` uses `babette` \[Bilderbeek and Etienne, 2018\] with
the addition of using the BEAST2 \[Bouckaert et al., 2019\] nested
sampling package as described in \[Russell et al., 2019\].

## Installation

:warning: `mcbette` only works on Linux and Mac.

`mcbette` depends on the
[rJava](https://cran.r-project.org/package=rJava) and
[Rmpfr](https://cran.r-project.org/package=Rmpfr) packages.

On Linux, to install these, do (as root):

    apt install r-cran-rjava libmpfr-dev

After this, installing `mcbette` is easy:

``` r
remotes::install_github("ropensci/mcbette")
beastier::install_beast2()
mauricer::install_beast2_pkg("NS")
```

## Example

``` r
library(mcbette)
```

Suppose we have a DNA alignment, obtained by sequencing multiple
species:

``` r
fasta_filename <- beautier::get_beautier_path("anthus_aco_sub.fas")
ape::image.DNAbin(ape::read.FASTA(fasta_filename))
```

<img src="man/figures/README-example_alignment-1.png" width="100%" />

Note that this alignment holds too little information to really base a
publishable research on.

To create a posterior distribution of phylogenies from this alignment,
one needs to specify an inference model. An inference model is (among
others) a combination of a site model, clock model and tree model. See
the ‘Available models’ section to see the available models.

In this example we let two inference models compete.

Here is the default inference model:

``` r
inference_model_1 <- beautier::create_ns_inference_model()
print(
  paste(
    inference_model_1$site_model$name,
    inference_model_1$clock_model$name,
    inference_model_1$tree_prior$name
  )
)
#> [1] "JC69 strict yule"
```

The JC69 site model assumes that the four DNA nucleotides are equally
likely to mutate from/to. The strict clock model assumes that mutation
rates of all species are equal. The Yule tree model assumes that new
species form at a constant rate for an extinction rate of zero.

The competing model has a different site, clock and tree model:

``` r
inference_model_2 <- inference_model_1
inference_model_2$site_model <- beautier::create_hky_site_model()
inference_model_2$clock_model <- beautier::create_rln_clock_model()
inference_model_2$tree_prior <- beautier::create_bd_tree_prior()
```

The HKY site model assumes that DNA substitution rates differ between
transitions (purine-to-purine or pyrimidine-to-pyrimidine) and
translations (purine-to-pyrimidine or the other way around). The relaxed
log-normal clock model assumes that mutation rates of all species are
differ, where all these rates together follow a log-normal distribution.
The birth-death tree model assumes that new species form and go extinct
at a constant rate.

`mcbette` shows the evidence (also called marginal likelihood) for each
inference model, which is the likelihood that a model has generated the
data.

``` r
if (can_run_mcbette()) {
  knitr::kable(
    est_marg_liks(
      fasta_filename = fasta_filename,
      inference_models = list(inference_model_1, inference_model_2)
    )
  )
}
```

| site\_model\_name | clock\_model\_name   | tree\_prior\_name | marg\_log\_lik | marg\_log\_lik\_sd | weight |      ess |
| :---------------- | :------------------- | :---------------- | -------------: | -----------------: | -----: | -------: |
| JC69              | strict               | yule              |     \-143.8551 |           1.919144 | 0.1369 | 7.568266 |
| HKY               | relaxed\_log\_normal | birth\_death      |     \-142.0138 |           2.625996 | 0.8631 | 4.159713 |

The most important result are the model weights. When a model’s weight
is very close to one, one would prefer to use that inference model in
doing a Bayesian inference. If these model weights are rather similar,
one could argue to use either model.

## Available models

The available site models:

``` r
beautier::get_site_model_names()
#> [1] "JC69" "HKY"  "TN93" "GTR"
```

The available clock models:

``` r
beautier::get_clock_model_names()
#> [1] "relaxed_log_normal" "strict"
```

The available tree models:

``` r
beautier::get_tree_prior_names()
#> [1] "birth_death"                    "coalescent_bayesian_skyline"   
#> [3] "coalescent_constant_population" "coalescent_exp_population"     
#> [5] "yule"
```

## Using an existing BEAST2 installation

When BEAST2 is already installed, yet at a non-default location, one can
use the `beast2_bin_path` argument in `create_mcbette_beast2_options`.

## Code of conduct

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.

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
