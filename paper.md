---
title: 'mcbette: model comparison using 'babette''
tags:
  - R
  - phylogenetics
  - model comparison
authors:
  - name: Richèl J.C. Bilderbeek
    orcid: 0000-0003-1107-7049
    affiliation: 1
affiliations:
 - name: Theoretical & Evolutionary Community Ecology, TRES, GELIFES, University of Groningen
   index: 1
date: 21 January 2020
bibliography: paper.bib
---

> Example text below

# Summary

All species on Earth are related to one another. There even is a name for
the last common ancestor all organisms share: LUCA ('Last Universal Common 
Ancestor'). A feature of all life on Earth is that it uses DNA to store the
blueprint of a species' features. The DNA carries traces of a species'
evolutionary history, as species that are closely related have more similar
DNA. The field of phylogenetics tries to conclude the evolutionary
history of species from their DNA sequences. Doing so is a complex task, as the
researcher needs to select the best of many ways to do so.

![](man/figures/alignment_joss.png)
![](man/figures/arrow.png)
![](man/figures/phylogeny_joss.png)
Caption: phylogenetics in a nutshell: deriving the evolutionary history
of species (at the right) from their DNA sequences (at the left)

``mcbette`` is an R package that helps to pick the best way *how* to conclude 
the evolutionary history of species from their DNA sequences. 
The 'best way', in this context, is that what is 'simple enough, but not 
simpler'. 

``mcbette`` builds heavily upon the ``babette`` R package [@Bilderbeek:2018]

``Gala`` was designed to be used by 
both astronomical researchers and by
students in courses on gravitational dynamics or astronomy. It has already been
used in a number of scientific publications [@Pearson:2017] and has also been
used in graduate courses on Galactic dynamics to, e.g., provide interactive
visualizations of textbook material [@Binney:2008]. The combination of speed,
design, and support for Astropy functionality in ``Gala`` will enable exciting
scientific explorations of forthcoming data releases from the *Gaia* mission
[@gaia] by students and experts alike.

# Mathematics


|site_model_name |clock_model_name |tree_prior_name | marg_log_lik| marg_log_lik_sd|    weight|
|:---------------|:----------------|:---------------|------------:|---------------:|---------:|
|JC69            |strict           |yule            |    -179.9266|        2.427167| 0.2823000|
|HKY             |strict           |yule            |    -182.2376|        1.992356| 0.0279950|
|TN93            |strict           |yule            |    -179.0459|        2.446301| 0.6810869|
|GTR             |strict           |yule            |    -183.4157|        2.636430| 0.0086181|


Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$


# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this: ![Example figure.](figure.png)

# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References



