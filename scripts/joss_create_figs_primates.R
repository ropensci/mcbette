# Creates the figures for the JOSS article.
#
# See https://github.com/ropensci/mcbette/issues/15

folder <- "/home/richel/GitHubs/mcbette/man/figures"

phylogeny_filename <- file.path(folder, "phylogeny_primates_joss.png")
fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
alignment_filename <- file.path(folder, "alignment_primates_joss.png")
marg_liks_filename <- file.path(folder, "marg_liks_primates_joss.md")
n_models <- 4
posterior_filenames <- file.path(folder, paste0("posterior_primates_joss_", seq(1, n_models) ,".png"))
consensus_posterior_filename <- file.path(folder, "posterior_primates_consensus_joss.png")

library(testthat)
expect_true(dir.exists(folder))

library(mcbette)

# Plot the alignment
alignment <- ape::read.FASTA(file = fasta_filename)
taxa_names <- names(alignment)
names(alignment) <- toupper(substring(names(alignment), 1, 1))

png(filename = alignment_filename, width = 900, height = 300)
ape::image.DNAbin(
  alignment,
  grid = TRUE,
  show.bases = FALSE,
  legend = FALSE,
  cex.lab = 2.0,
  cex.axis = 2.0
)
dev.off()

# Create the inference models
inference_models <- list()
inference_models[[1]] <- beautier::create_inference_model(site_model = beautier::create_jc69_site_model())
inference_models[[2]] <- beautier::create_inference_model(site_model = beautier::create_hky_site_model())
inference_models[[3]] <- beautier::create_inference_model(site_model = beautier::create_tn93_site_model())
inference_models[[4]] <- beautier::create_inference_model(site_model = beautier::create_gtr_site_model())
expect_equal(n_models, length(inference_models))
# Prepare BEAST2 options
beast2_optionses <- rep(
  list(beastier::create_mcbette_beast2_options(rng_seed = 42)),
  times = n_models
)
expect_equal(n_models, length(beast2_optionses))

# Do marginal likelihood estimation
for (i in seq_len(n_models)) {
  inference_models[[i]]$mcmc <- beautier::create_ns_mcmc()
}
marg_liks <- mcbette::est_marg_liks(
  fasta_filename = fasta_filename,
  inference_models = inference_models,
  beast2_optionses = beast2_optionses

)

# Show results
# ESS cannot be interpreted anyways
marg_liks$ess <- NULL
cat(
  knitr::kable(marg_liks, format = "markdown"),
  sep = "\n",
  file = marg_liks_filename
)

# For primates, I know TN93 will win
winning_model_index <-  which(marg_liks$weight == max(marg_liks$weight))
expect_equal(3, winning_model_index)

# Reduplicated plural
posterior_treeses <- list()

# Do an inference with each of the inference models
for (i in seq_len(n_models)) {
  # Must be a regular MCMC
  inference_models[[i]]$mcmc <- beautier::create_mcmc()

  # Inference
  output <- babette::bbt_run_from_model(
    fasta_filename = fasta_filename,
    inference_model = inference_models[[i]]
  )

  # Pick the last 50%
  posterior_trees <- output$primates_trees[501:1001]
  posterior_treeses[[i]] <- posterior_trees

  png(filename = posterior_filenames[i], width = 1000, height = 800)
  babette::plot_densitree(
    posterior_trees,
    alpha = 0.1,
    consensus = rev(taxa_names),
    cex = 2.0,
    scaleX = TRUE,
    scale.bar = FALSE
  )
  dev.off()
}

# Plot the consensus tree
consensus_tree <- ape::consensus(
  posterior_treeses[[winning_model_index]],
  p = 0.5
)

if (1 == 2) {
  consensus_tree <- ape::read.tree(
    text = "((((human:1, chimp:1):1, gorilla:2):1, orangutan:3):1, siamang:4);"
  )
}

png(filename = consensus_posterior_filename, width = 400, height = 300)
ape::plot.phylo(
  consensus_tree,
  cex = 2.0,
  edge.width = 2.0,
  x.lim = c(0, 7),
  y.lim = c(0, 6)
)
dev.off()

ggtree::ggtree(
  consensus_tree,
  ladderize = FALSE
) + ggtree::geom_tiplab(cex = 10) + ggtree::xlim(0, 6)
