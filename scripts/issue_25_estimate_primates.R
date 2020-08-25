# R script to estimate the evidence of the Primates.nex alignment
# Using different settings

library(mcbette)

options(digits = 22)

fasta_filename <- "~/primates.fas"
beastier::save_nexus_as_fasta(
  nexus_filename = beastier::get_beast2_example_filename("Primates.nex"),
  fasta_filename = fasta_filename
)


df <- expand.grid(
  epsilon = c(100, 1.0, 0.01),
  particle_count = 1,
  marg_log_lik = NA,
  marg_log_lik_sd = NA,
  ess = NA
)

for (i in seq_len(nrow(df))) {
  print(i)
  inference_model <- create_test_ns_inference_model()
  inference_model$mcmc$epsilon <- df$epsilon[i]
  inference_model$mcmc$particle_count <- df$particle_count[i]
  inference_model$mcmc$chain_length <- 1e10
  inference_model$mcmc$sub_chain_length <- 500000
  inference_model$mcmc$tracelog$filename <- path.expand(paste0("~/ns_", i, ".log"))
  inference_model$mcmc$treelog$filename <- path.expand(paste0("~/ns_", i, ".trees"))
  inference_model$mcmc$screenlog$filename <- path.expand(paste0("~/ns_", i, ".txt"))
  beast2_options <- beastier::create_mcbette_beast2_options(
    input_filename = path.expand(paste0("~/ns_", i, ".xml")),
    output_state_filename = path.expand(paste0("~/ns_", i, ".xml.state")),
    rng_seed = 314
  )
  evidence <- mcbette::est_marg_lik(
    fasta_filename = fasta_filename,
    inference_model = inference_model,
    beast2_options = beast2_options
  )
  df$marg_log_lik <- evidence$marg_log_lik
  df$marg_log_lik_sd <- evidence$marg_log_lik_sd
  df$ess <- evidence$ess
}

knitr::kable(df)
