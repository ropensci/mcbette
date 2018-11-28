# McBette

Branch|[![Travis CI logo](pics/TravisCI.png)](https://travis-ci.org)
---|---
master|[![Build Status](https://travis-ci.org/richelbilderbeek/McBette.svg?branch=master)](https://travis-ci.org/richelbilderbeek/McBette)
develop|[![Build Status](https://travis-ci.org/richelbilderbeek/McBette.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/McBette)

Model Comparison using `babette`.

## What is McBette?

McBette allows you to do a Bayesian model comparison on a DNA alignment,
in an easy-to-use way.

To do so, McBette uses the infrastructure of GitHub and Travis CI. For simple
alignments, this costs nothing. Because everything happens online, 
no installation is needed :+1:.

You can 
 
 * [watch a McBette introduction video on YouTube](https://youtu.be/bLhrrSua8OM)
 * [download that video](http://richelbilderbeek.nl/mcbette.ogv)

## How to use McBette?

  1. Get a GitHub account
  2. Get a Travis CI account (one can simply log in with GitHub)
  3. Fork this repo
  4. Activate Travis CI for your fork
  5. Change the alignment FASTA file, called `my_alignment.fas`
  6. See the results in the Travis CI build log

## Example output

Here is the output of the supplied FASTA file:

```
|site_model_name |clock_model_name   |tree_prior_name                | marg_log_lik| marg_log_lik_sd|
|:---------------|:------------------|:------------------------------|------------:|---------------:|
|GTR             |relaxed_log_normal |birth_death                    |    -1811.027|        6.080012|
|GTR             |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA|
|GTR             |relaxed_log_normal |coalescent_constant_population |    -1843.625|        9.135051|
|GTR             |relaxed_log_normal |coalescent_exp_population      |    -1793.983|        4.096881|
|GTR             |relaxed_log_normal |yule                           |    -1804.508|        5.838469|
|GTR             |strict             |birth_death                    |    -1798.271|        4.794403|
|GTR             |strict             |coalescent_bayesian_skyline    |           NA|              NA|
|GTR             |strict             |coalescent_constant_population |    -1803.812|        5.577658|
|GTR             |strict             |coalescent_exp_population      |    -1796.305|        5.341554|
|GTR             |strict             |yule                           |    -1798.523|        4.878357|
|HKY             |relaxed_log_normal |birth_death                    |    -1796.834|        4.383638|
|HKY             |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA|
|HKY             |relaxed_log_normal |coalescent_constant_population |    -1797.376|        4.821398|
|HKY             |relaxed_log_normal |coalescent_exp_population      |    -1805.887|        5.011170|
|HKY             |relaxed_log_normal |yule                           |    -1809.258|        6.583333|
|HKY             |strict             |birth_death                    |    -1793.177|        4.989012|
|HKY             |strict             |coalescent_bayesian_skyline    |           NA|              NA|
|HKY             |strict             |coalescent_constant_population |    -1804.641|        5.254055|
|HKY             |strict             |coalescent_exp_population      |    -1791.317|        4.436302|
|HKY             |strict             |yule                           |    -1799.619|        5.808298|
|JC69            |relaxed_log_normal |birth_death                    |    -1933.366|        2.503555|
|JC69            |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA|
|JC69            |relaxed_log_normal |coalescent_constant_population |    -1938.315|        3.596683|
|JC69            |relaxed_log_normal |coalescent_exp_population      |    -1939.448|        3.606480|
|JC69            |relaxed_log_normal |yule                           |    -1941.170|        3.939826|
|JC69            |strict             |birth_death                    |    -1932.717|        2.139281|
|JC69            |strict             |coalescent_bayesian_skyline    |           NA|              NA|
|JC69            |strict             |coalescent_constant_population |    -1936.867|        3.124300|
|JC69            |strict             |coalescent_exp_population      |    -1934.601|        2.782317|
|JC69            |strict             |yule                           |    -1934.778|        2.996254|
|TN93            |relaxed_log_normal |birth_death                    |    -1801.786|        5.081329|
|TN93            |relaxed_log_normal |coalescent_bayesian_skyline    |           NA|              NA|
|TN93            |relaxed_log_normal |coalescent_constant_population |    -1803.874|        5.392158|
|TN93            |relaxed_log_normal |coalescent_exp_population      |    -1791.263|        4.356108|
|TN93            |relaxed_log_normal |yule                           |    -1803.101|        4.712677|
|TN93            |strict             |birth_death                    |    -1798.743|        4.879048|
|TN93            |strict             |coalescent_bayesian_skyline    |           NA|              NA|
|TN93            |strict             |coalescent_constant_population |    -1806.633|        5.651098|
|TN93            |strict             |coalescent_exp_population      |    -1805.624|        5.675836|
|TN93            |strict             |yule                           |    -1798.215|        3.969258|

[1] "Best model:"

|site_model_name |clock_model_name   |tree_prior_name           | marg_log_lik| marg_log_lik_sd|
|:---------------|:------------------|:-------------------------|------------:|---------------:|
|TN93            |relaxed_log_normal |coalescent_exp_population |    -1791.263|        4.356108|
```

This alignment apparently fits best with an TN93 site model, 
relaxed log-normal clock model and a coalescent exponential population tree prior. 

## Troubleshooting

### My run takes longer than one hour

Travis CI gives you one hour of computation time. 

If your alignment needs more time, one can:

 * get [a Travis CI paid plan](https://travis-ci.com/plans)
 * use less different site, clock and/or tree models
 * use a shorter alignment
 * use an alignment with less taxa

## References

Article about `babette`:

 * Bilderbeek, Richel JC, and Rampal S. Etienne. "babette: BEAUti 2, BEAST 2 and Tracer for R." Methods in Ecology and Evolution (2018). https://doi.org/10.1111/2041-210X.13032
