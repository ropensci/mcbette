library(babette)
testit::assert(is_beast2_installed())
testit::assert(mauricer::mrc_is_installed("NS"))

fasta_filename <- "my_alignment.fas"
testit::assert(file.exists(fasta_filename))

n_rows <- length(beautier:::create_site_models()) * 
  length(beautier:::create_clock_models()) * 
  length(beautier:::create_tree_priors())

site_model_names <- rep(NA, n_rows)
clock_model_names <- rep(NA, n_rows)
tree_prior_names <- rep(NA, n_rows)
marg_log_liks <- rep(NA, n_rows)
marg_log_lik_sds <- rep(NA, n_rows)

# Pick a site model
row_index <- 1
for (site_model in beautier:::create_site_models()) {
  for (clock_model in beautier:::create_clock_models()) {
    for (tree_prior in beautier:::create_tree_priors()) {
      tryCatch(
        {
          marg_lik <- bbt_run(
            fasta_filenames = fasta_filename,
            site_models = site_model,
            clock_models = clock_model,
            tree_priors = tree_prior,
            mcmc = create_mcmc_nested_sampling(epsilon = 10e-13),
            beast2_path = get_default_beast2_bin_path()
          )$ns
          marg_log_liks[row_index] <- marg_lik$marg_log_lik
          marg_log_lik_sds[row_index] <- marg_lik$marg_log_lik_sd
        }, 
        error = function(msg) {}
      ) 
      site_model_names[row_index] <- site_model$name
      clock_model_names[row_index] <- clock_model$name
      tree_prior_names[row_index] <- tree_prior$name
      row_index <- row_index + 1
    }
  }
}

df <- data.frame(
  site_model_name = site_model_names,
  clock_model_name = clock_model_names,
  tree_prior_name = tree_prior_names,
  marg_log_lik = marg_log_liks,
  marg_log_lik_sd = marg_log_lik_sds
)
knitr::kable(df)

# Keep non-NA
df <- na.omit(df)
best_row_index <- which(df$marg_log_lik == max(df$marg_log_lik))

df_best <- df[best_row_index, ]
print("Best model:")
knitr::kable(df_best, row.names = FALSE)
