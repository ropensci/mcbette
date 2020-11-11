# Creates the figures for the JOSS article.
#
# See https://github.com/ropensci/mcbette/issues/15

folder <- "/home/richel/GitHubs/mcbette/man/figures"
phylogeny_filename <- file.path(folder, "phylogeny_joss.png")
fasta_filename <- file.path(folder, "alignment_joss.fasta")
alignment_filename <- file.path(folder, "alignment_joss.png")
marg_liks_filename <- file.path(folder, "marg_liks_joss.md")
n_models <- 4
posterior_filenames <- file.path(folder, paste0("posterior_joss_", seq(1, n_models) ,".png"))

library(testthat)
expect_true(dir.exists(folder))

library(mcbette)

phylogeny <- ape::read.tree(text = "(((1:1,2:1):1, 3:2):1, 4:3);")

# Plot phylogeny
png(filename = phylogeny_filename, width = 400, height = 300)
ape::plot.phylo(phylogeny, cex = 2.0, edge.width = 2.0)
dev.off()

# Simulate an alignment
pirouette::create_tral_file(
  phylogeny = phylogeny,
  alignment_params = pirouette::create_alignment_params(
    root_sequence = pirouette::create_blocked_dna(length = 40),
    sim_tral_fun = pirouette::get_sim_tral_with_std_nsm_fun(
      mutation_rate = 0.5 * 1.0 / 3.0,
      site_model = create_tn93_site_model()
    ),
    fasta_filename = fasta_filename,
    rng_seed = 42
  )
)

# Plot the alignment
png(filename = alignment_filename, width = 800, height = 300)
ape::image.DNAbin(
  ape::read.FASTA(file = fasta_filename),
  grid = TRUE,
  show.bases = FALSE,
  legend = FALSE,
  cex.lab = 2.0,
  cex.axis = 2.0
)
dev.off()

# Create the inference models
inference_models <- list()
inference_models[[1]] <- create_inference_model(site_model = create_jc69_site_model())
inference_models[[2]] <- create_inference_model(site_model = create_hky_site_model())
inference_models[[3]] <- create_inference_model(site_model = create_tn93_site_model())
inference_models[[4]] <- create_inference_model(site_model = create_gtr_site_model())
expect_equal(n_models, length(inference_models))
# Prepare BEAST2 options
beast2_optionses <- rep(
  list(beastier::create_mcbette_beast2_options(rng_seed = 42)),
  times = n_models
)
expect_equal(n_models, length(beast2_optionses))

# Do marginal likelihood estimation
for (i in seq_len(n_models)) {
  inference_models[[i]]$mcmc <- create_ns_mcmc()
}
marg_liks <- mcbette::est_marg_liks(
  fasta_filename = fasta_filename,
  inference_models = inference_models,
  beast2_optionses = beast2_optionses

)

# Show results
# ESS cannot be interpreted anyways
marg_liks$ess <- NULL
message(
  knitr::kable(marg_liks, format = "markdown"),
  sep = "\n",
  file = marg_liks_filename
)

# We expect TN93 to win, as it generated the alignment
winning_model_index <-  which(marg_liks$weight == max(marg_liks$weight))
expect_equal(3, winning_model_index)


# Do an inference with each of the inference models
for (i in seq_len(n_models)) {
  # Must be a regular MCMC
  inference_models[[i]]$mcmc <- create_mcmc()

  # Inference
  output <- babette::bbt_run_from_model(
    fasta_filename = fasta_filename,
    inference_model = inference_models[[i]]
  )

  # Pick the last 50%
  posterior_trees <- output$alignment_joss_trees[501:1001]

  png(filename = posterior_filenames[i], width = 1000, height = 800)
  babette::plot_densitree(
    posterior_trees, library = "phangorn",
    alpha = 0.1,
    consensus = as.character(c(1:4)),
    cex = 2.0,
    scaleX = TRUE,
    scale.bar = FALSE
  )
  dev.off()
}



