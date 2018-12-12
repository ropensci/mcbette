#' Estimate the marginal likelihoods for all combinations of\
#' site, clock and tree models
#' @param fasta_filename name of the FASTA file
#' @param epsilon measure of relative accuracy.
#'   Smaller values result in longer, more precise estimations
#' @param verbose if TRUE show debug output
#' @return a \code{\link[dplyr]{tibble}} showing the estimated marginal likelihoods
#' (and its estimated error) per combination of models
#' @author Richel J.C. Bilderbeek
#' @export
est_marg_liks <- function(
  fasta_filename,
  epsilon = 10e-13,
  verbose = FALSE
) {
  if (!file.exists(fasta_filename)) {
    stop(
      "FASTA file does not exists. ",
      "File '", fasta_filename,"' not found"
    )
  }
  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::mrc_is_installed("NS"))

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
        tryCatch({
            marg_lik <- babette::bbt_run(
              fasta_filename = fasta_filename,
              site_model = site_model,
              clock_model = clock_model,
              tree_prior = tree_prior,
              mcmc = beautier::create_mcmc_nested_sampling(epsilon = epsilon),
              beast2_path = beastier::get_default_beast2_bin_path(),
              overwrite = TRUE
            )$ns
            marg_log_liks[row_index] <- marg_lik$marg_log_lik
            marg_log_lik_sds[row_index] <- marg_lik$marg_log_lik_sd
          },
          error = function(msg) {
            if (verbose) print(msg)
          }
        )
        site_model_names[row_index] <- site_model$name
        clock_model_names[row_index] <- clock_model$name
        tree_prior_names[row_index] <- tree_prior$name
        row_index <- row_index + 1
      }
    }
  }
  weights <- calc_weights(marg_liks = exp(Rmpfr::mpfr(marg_log_liks, 256)))

  dplyr::tibble(
    site_model_name = site_model_names,
    clock_model_name = clock_model_names,
    tree_prior_name = tree_prior_names,
    marg_log_lik = Rmpfr::mpfr(marg_log_liks, 256),
    marg_log_lik_sd = Rmpfr::mpfr(marg_log_lik_sds, 256),
    weight = weights
  )
}
