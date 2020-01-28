# R script to estimate the evidence of the Primates.nex alignment
# Using different settings

library(mcbette)

fasta_filename <- tempfile()

beastier::save_nexus_as_fasta(
  nexus_filename = beastier::get_beast2_example_filename("Primates.nex"),
  fasta_filename = fasta_filename
)

df <- expand.grid(
  epsilon = c(1e12, 1, 1e-12),
  particle_count = c(1, 4, 16),
  marg_log_lik = NA,
  marg_log_lik_sd = NA
)

for (i in seq_len(nrow(df))) {
  print(i)
  inference_model <- create_test_ns_inference_model()
  inference_model$mcmc$epsilon <- df$epsilon[i]
  inference_model$mcmc$particle_count <- df$particle_count[i]
  evidence <- mcbette::est_marg_lik(
    fasta_filename = fasta_filename,
    inference_model = inference_model
  )
  df$marg_log_lik <- evidence$marg_log_lik
  df$marg_log_lik_sd <- evidence$marg_log_lik_sd
}


