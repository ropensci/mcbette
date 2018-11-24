
library(babette)
testit::assert(is_beast2_installed())
testit::assert(mauricer::mrc_is_installed("NS"))

fasta_filename <- "primates.fas"
testit::assert(file.exists(fasta_filename))

print("site_model_name | marg_log_lik | marg_log_lik_sd")

# Pick a site model
site_model <- beautier:::create_site_models()[1]
marg_lik <- bbt_run(
  fasta_filenames = fasta_filename,
  site_models = site_model,
  mcmc = create_mcmc_nested_sampling(),
  beast2_path = get_default_beast2_bin_path()
)$ns

print(paste(site_model[[1]]$name, "|",marg_lik$marg_log_lik, "|", marg_lik$marg_log_lik_sd))
