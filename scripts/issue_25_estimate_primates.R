# R script to estimate the evidence of the Primates.nex alignment
# Using different settings

library(mcbette)

options(digits = 22)

fasta_filename <- tempfile()

beastier::save_nexus_as_fasta(
  nexus_filename = beastier::get_beast2_example_filename("Primates.nex"),
  fasta_filename = fasta_filename
)

df <- expand.grid(
  epsilon = c(1e20, 1, 1e-20),
  particle_count = c(1, 2),
  marg_log_lik = NA,
  marg_log_lik_sd = NA,
  ess = NA
)

for (i in seq_len(nrow(df))) {
  print(i)
  inference_model <- create_test_ns_inference_model(
    site_model = create_hky_site_model(),
    tree_prior = create_bd_tree_prior()
  )
  inference_model$mcmc$epsilon <- df$epsilon[i]
  inference_model$mcmc$particle_count <- df$particle_count[i]
  inference_model$mcmc$chain_length <- 1e10
  evidence <- mcbette::est_marg_lik(
    fasta_filename = fasta_filename,
    inference_model = inference_model
  )
  df$marg_log_lik <- evidence$marg_log_lik
  df$marg_log_lik_sd <- evidence$marg_log_lik_sd
  df$ess <- evidence$ess
}
df

knitr::kable(df)
df
