# `mcbette`

Branch|[![Travis CI logo](pics/TravisCI.png)](https://travis-ci.org)|[![Codecov logo](pics/Codecov.png)](https://www.codecov.io)
---|---|---
`master`|[![Build Status](https://travis-ci.org/richelbilderbeek/mcbette.svg?branch=master)](https://travis-ci.org/richelbilderbeek/mcbette) | [![codecov.io](https://codecov.io/github/richelbilderbeek/mcbette/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/mcbette?branch=master)
`develop`|[![Build Status](https://travis-ci.org/richelbilderbeek/mcbette.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/mcbette) | [![codecov.io](https://codecov.io/github/richelbilderbeek/mcbette/coverage.svg?branch=develop)](https://codecov.io/github/richelbilderbeek/mcbette?branch=develop)

Model Comparison using `babette`.

## What is `mcbette`?

`mcbette` allows you to do a Bayesian model comparison on a DNA alignment,
in an easy-to-use way.

To do so, mcbette uses the infrastructure of GitHub and Travis CI. For simple
alignments, this costs nothing. Because everything happens online, 
no installation is needed :+1:.

You can 
 
 * [watch a mcbette introduction video on YouTube](https://youtu.be/bLhrrSua8OM)
 * [download that video](http://richelbilderbeek.nl/mcbette.ogv)

## How to use `mcbette` online?

  1. Get a GitHub account
  2. Get a Travis CI account (one can simply log in with GitHub)
  3. Fork this repo
  4. Activate Travis CI for your fork
  5. Change the alignment FASTA file, called `my_alignment.fas`
  6. See the results in the Travis CI build log

## How to use `mcbette` offline?

:warning: `mcbette` only works on Linux and Mac

### Installation

```r
usethis::install_github("ropensci/beautier")
usethis::install_github("ropensci/tracerer")
usethis::install_github("ropensci/beastier")
usethis::install_github("ropensci/mauricer")
usethis::install_github("ropensci/babette")
usethis::install_github("richelbilderbeek/mcbette")
beastier::install_beast2()
mauricer::install_beast2_pkg("NS")
```

## Example

`mcbette` starts from an alignment:

![A DNA alignment](pics/alignment.png)

`mcbette` estimates the evidence (also known as marginal likelihood)
of each model.

```{r}
mcbette::est_marg_liks(
  fasta_filename = system.file("extdata", "primates.fas", package = "mcbette")
)
```

Here is the `mcbette` output of that alignment:

```
|site_model_name |clock_model_name   |tree_prior_name                | marg_log_lik| marg_log_lik_sd|    weight|
|:---------------|:------------------|:------------------------------|------------:|---------------:|---------:|
|GTR             |relaxed_log_normal |birth_death                    |    -1811.027|        6.080012| 0.0000000|
|GTR             |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|GTR             |relaxed_log_normal |coalescent_constant_population |    -1843.625|        9.135051| 0.0000000|
|GTR             |relaxed_log_normal |coalescent_exp_population      |    -1793.983|        4.096881| 0.0302719|
|GTR             |relaxed_log_normal |yule                           |    -1804.508|        5.838469| 0.0000008|
|GTR             |strict             |birth_death                    |    -1798.271|        4.794403| 0.0004154|
|GTR             |strict             |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|GTR             |strict             |coalescent_constant_population |    -1803.812|        5.577658| 0.0000016|
|GTR             |strict             |coalescent_exp_population      |    -1796.305|        5.341554| 0.0029673|
|GTR             |strict             |yule                           |    -1798.523|        4.878357| 0.0003231|
|HKY             |relaxed_log_normal |birth_death                    |    -1796.834|        4.383638| 0.0017480|
|HKY             |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|HKY             |relaxed_log_normal |coalescent_constant_population |    -1797.376|        4.821398| 0.0010168|
|HKY             |relaxed_log_normal |coalescent_exp_population      |    -1805.887|        5.011170| 0.0000002|
|HKY             |relaxed_log_normal |yule                           |    -1809.258|        6.583333| 0.0000000|
|HKY             |strict             |birth_death                    |    -1793.177|        4.989012| 0.0677362|
|HKY             |strict             |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|HKY             |strict             |coalescent_constant_population |    -1804.641|        5.254055| 0.0000007|
|HKY             |strict             |coalescent_exp_population      |    -1791.317|        4.436302| 0.4352616|
|HKY             |strict             |yule                           |    -1799.619|        5.808298| 0.0001080|
|JC69            |relaxed_log_normal |birth_death                    |    -1933.366|        2.503555| 0.0000000|
|JC69            |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|JC69            |relaxed_log_normal |coalescent_constant_population |    -1938.315|        3.596683| 0.0000000|
|JC69            |relaxed_log_normal |coalescent_exp_population      |    -1939.448|        3.606480| 0.0000000|
|JC69            |relaxed_log_normal |yule                           |    -1941.170|        3.939826| 0.0000000|
|JC69            |strict             |birth_death                    |    -1932.717|        2.139281| 0.0000000|
|JC69            |strict             |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|JC69            |strict             |coalescent_constant_population |    -1936.867|        3.124300| 0.0000000|
|JC69            |strict             |coalescent_exp_population      |    -1934.601|        2.782317| 0.0000000|
|JC69            |strict             |yule                           |    -1934.778|        2.996254| 0.0000000|
|TN93            |relaxed_log_normal |birth_death                    |    -1801.786|        5.081329| 0.0000124|
|TN93            |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|TN93            |relaxed_log_normal |coalescent_constant_population |    -1803.874|        5.392158| 0.0000015|
|TN93            |relaxed_log_normal |coalescent_exp_population      |    -1791.263|        4.356108| 0.4594322|
|TN93            |relaxed_log_normal |yule                           |    -1803.101|        4.712677| 0.0000033|
|TN93            |strict             |birth_death                    |    -1798.743|        4.879048| 0.0002591|
|TN93            |strict             |coalescent_bayesian_skyline    |           NA|              NA| 0.0000000|
|TN93            |strict             |coalescent_constant_population |    -1806.633|        5.651098| 0.0000001|
|TN93            |strict             |coalescent_exp_population      |    -1805.624|        5.675836| 0.0000003|
|TN93            |strict             |yule                           |    -1798.215|        3.969258| 0.0004394|
|   |site_model_name |clock_model_name   |tree_prior_name                | marg_log_lik| marg_log_lik_sd|    weight|
|:--|:---------------|:------------------|:------------------------------|------------:|---------------:|---------:|
|34 |TN93            |relaxed_log_normal |coalescent_exp_population      |    -1791.263|        4.356108| 0.4594322|
|19 |HKY             |strict             |coalescent_exp_population      |    -1791.317|        4.436302| 0.4352616|
|16 |HKY             |strict             |birth_death                    |    -1793.177|        4.989012| 0.0677362|
|4  |GTR             |relaxed_log_normal |coalescent_exp_population      |    -1793.983|        4.096881| 0.0302719|
|9  |GTR             |strict             |coalescent_exp_population      |    -1796.305|        5.341554| 0.0029673|
|11 |HKY             |relaxed_log_normal |birth_death                    |    -1796.834|        4.383638| 0.0017480|
|13 |HKY             |relaxed_log_normal |coalescent_constant_population |    -1797.376|        4.821398| 0.0010168|
|40 |TN93            |strict             |yule                           |    -1798.215|        3.969258| 0.0004394|
|6  |GTR             |strict             |birth_death                    |    -1798.271|        4.794403| 0.0004154|
|10 |GTR             |strict             |yule                           |    -1798.523|        4.878357| 0.0003231|
|36 |TN93            |strict             |birth_death                    |    -1798.743|        4.879048| 0.0002591|
|20 |HKY             |strict             |yule                           |    -1799.619|        5.808298| 0.0001080|
|31 |TN93            |relaxed_log_normal |birth_death                    |    -1801.786|        5.081329| 0.0000124|
|35 |TN93            |relaxed_log_normal |yule                           |    -1803.101|        4.712677| 0.0000033|
|8  |GTR             |strict             |coalescent_constant_population |    -1803.812|        5.577658| 0.0000016|
|33 |TN93            |relaxed_log_normal |coalescent_constant_population |    -1803.874|        5.392158| 0.0000015|
|5  |GTR             |relaxed_log_normal |yule                           |    -1804.508|        5.838469| 0.0000008|
|18 |HKY             |strict             |coalescent_constant_population |    -1804.641|        5.254055| 0.0000007|
|39 |TN93            |strict             |coalescent_exp_population      |    -1805.624|        5.675836| 0.0000003|
|14 |HKY             |relaxed_log_normal |coalescent_exp_population      |    -1805.887|        5.011170| 0.0000002|
|38 |TN93            |strict             |coalescent_constant_population |    -1806.633|        5.651098| 0.0000001|
|15 |HKY             |relaxed_log_normal |yule                           |    -1809.258|        6.583333| 0.0000000|
|1  |GTR             |relaxed_log_normal |birth_death                    |    -1811.027|        6.080012| 0.0000000|
|3  |GTR             |relaxed_log_normal |coalescent_constant_population |    -1843.625|        9.135051| 0.0000000|
|26 |JC69            |strict             |birth_death                    |    -1932.717|        2.139281| 0.0000000|
|21 |JC69            |relaxed_log_normal |birth_death                    |    -1933.366|        2.503555| 0.0000000|
|29 |JC69            |strict             |coalescent_exp_population      |    -1934.601|        2.782317| 0.0000000|
|30 |JC69            |strict             |yule                           |    -1934.778|        2.996254| 0.0000000|
|28 |JC69            |strict             |coalescent_constant_population |    -1936.867|        3.124300| 0.0000000|
|23 |JC69            |relaxed_log_normal |coalescent_constant_population |    -1938.315|        3.596683| 0.0000000|
|24 |JC69            |relaxed_log_normal |coalescent_exp_population      |    -1939.448|        3.606480| 0.0000000|
|25 |JC69            |relaxed_log_normal |yule                           |    -1941.170|        3.939826| 0.0000000|
    ++--------+-------+--------+-------+--------+--------+-----+
    |  **                                                      |
0.4 +                                                          +
    |                                                          |
    |                                                          |
0.3 +                                                          +
    |                                                          |
    |                                                          |
0.2 +                                                          +
    |                                                          |
    |                                                          |
0.1 +     *                                                    +
    |                                                          |
  0 +       * ** * ** * * ** * * ** * ** * * ** * * ** * ** *  +
    ++--------+-------+--------+-------+--------+--------+-----+
     0        5      10       15      20       25       30      
[1] "Best model:"
|site_model_name |clock_model_name   |tree_prior_name           | marg_log_lik| marg_log_lik_sd|    weight|
|:---------------|:------------------|:-------------------------|------------:|---------------:|---------:|
|TN93            |relaxed_log_normal |coalescent_exp_population |    -1791.263|        4.356108| 0.4594322|
```

This alignment apparently fits best with an TN93 site model, 
relaxed log-normal clock model and a coalescent exponential population tree prior. 

But it does go neck-to-neck with another model combination (HKY, strict, CEP).

## [FAQ](doc/faq.md)

See [FAQ](doc/faq.md)

## Package dependencies

Package|[![Travis CI logo](pics/TravisCI.png)](https://travis-ci.org)|[![AppVeyor logo](pics/AppVeyor.png)](https://www.appveyor.com)|[![Codecov logo](pics/Codecov.png)](https://www.codecov.io)
---|---|---|---
[babette](https://github.com/ropensci/babette)|[![Build Status](https://travis-ci.org/ropensci/babette.svg?branch=master)](https://travis-ci.org/ropensci/babette)|[![Build status](https://ci.appveyor.com/api/projects/status/qlahq0nofnpg3i8j/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/babette/branch/master)|[![codecov.io](https://codecov.io/github/ropensci/babette/coverage.svg?branch=master)](https://codecov.io/github/ropensci/babette/branch/master)
[beautier](https://github.com/ropensci/beautier)|[![Build Status](https://travis-ci.org/ropensci/beautier.svg?branch=master)](https://travis-ci.org/ropensci/beautier)|[![Build status](https://ci.appveyor.com/api/projects/status/qlahq0nofnpg3i8j/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/beautier/branch/master)|[![codecov.io](https://codecov.io/github/ropensci/beautier/coverage.svg?branch=master)](https://codecov.io/github/ropensci/beautier/branch/master)
[beastier](https://github.com/ropensci/beastier)|[![Build Status](https://travis-ci.org/ropensci/beastier.svg?branch=master)](https://travis-ci.org/ropensci/beastier)|[![Build status](https://ci.appveyor.com/api/projects/status/tny9jb7jkwbfamm2/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/beastier/branch/master)|[![codecov.io](https://codecov.io/github/ropensci/beastier/coverage.svg?branch=master)](https://codecov.io/github/ropensci/beastier/branch/master)
[mauricer](https://github.com/ropensci/mauricer)|[![Build Status](https://travis-ci.org/ropensci/mauricer.svg?branch=master)](https://travis-ci.org/ropensci/mauricer)|[![Build status](https://ci.appveyor.com/api/projects/status/1jf90vxixax0qd7y/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/mauricer/branch/master)|[![codecov.io](https://codecov.io/github/ropensci/mauricer/coverage.svg?branch=master)](https://codecov.io/github/ropensci/mauricer/branch/master)
[phangorn](https://github.com/KlausVigo/phangorn)|[![Build Status](https://travis-ci.org/KlausVigo/phangorn.svg?branch=master)](https://travis-ci.org/KlausVigo/phangorn)|.|[![codecov.io](https://codecov.io/github/KlausVigo/phangorn/coverage.svg?branch=master)](https://codecov.io/github/KlausVigo/phangorn/branch/master)
[tracerer](https://github.com/ropensci/tracerer)|[![Build Status](https://travis-ci.org/ropensci/tracerer.svg?branch=master)](https://travis-ci.org/ropensci/tracerer)|[![Build status](https://ci.appveyor.com/api/projects/status/6ulxqop64tgbujch/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/tracerer/branch/master)|[![codecov.io](https://codecov.io/github/ropensci/tracerer/coverage.svg?branch=master)](https://codecov.io/github/ropensci/tracerer/branch/master)

## References

Article about `babette`:

 * Bilderbeek, Richel JC, and Rampal S. Etienne. "babette: BEAUti 2, BEAST 2 and Tracer for R." Methods in Ecology and Evolution (2018). https://doi.org/10.1111/2041-210X.13032
