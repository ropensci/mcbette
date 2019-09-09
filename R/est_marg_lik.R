#' Estimate the marginal likelihood for a combination of
#' site, clock and tree models
#' @inheritParams default_params_doc
#' @return a \link{list} showing the estimated marginal likelihoods
#' (and its estimated error), its items are::
#' \itemize{
#'   \item \code{marg_log_lik}: estimated marginal (natural) log likelihood
#'   \item \code{marg_log_lik_sd}: estimated error of \code{marg_log_lik}
#'   \item \code{esses} the Effective Sample Size
#'   \item \code{estimates} the estimated marginal (natural) log likelihoods
#'   \item \code{trees} the jointly-estimated posterior trees
#' }
#' @examples
#' library(testthat)
#'
#' fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#' marg_lik <- est_marg_lik(
#'   fasta_filename = fasta_filename,
#'   epsilon = 1e7
#' )
#'
#' expect_true(is.list(marg_lik))
#' expect_true("marg_log_lik" %in% names(marg_lik))
#' expect_true("marg_log_lik_sd" %in% names(marg_lik))
#' expect_true("ess" %in% names(marg_lik))
#' expect_true("estimates" %in% names(marg_lik))
#' expect_true("trees" %in% names(marg_lik))
#' expect_true(beautier::is_one_double(marg_lik$marg_log_lik))
#' expect_true(beautier::is_one_double(marg_lik$marg_log_lik_sd))
#' expect_true(beautier::is_one_double(marg_lik$ess))
#' expect_true(marg_lik$marg_log_lik < 0.0)
#' expect_true(marg_lik$marg_log_lik_sd > 0.0)
#' @author Richèl J.C. Bilderbeek
#' @export
est_marg_lik <- function(
  fasta_filename,
  inference_model = beautier::create_inference_model(
    mcmc = beautier::create_nested_sampling_mcmc()
  ),
  beast2_options = create_mcbette_beast2_options(),
  os = rappdirs::app_dir()$os
) {
  beautier::check_file_exists(fasta_filename)
  beautier::check_inference_model(inference_model)
  beastier::check_beast2_options(beast2_options)

  if (os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
  if (!beastier::is_bin_path(beast2_options$beast2_bin_path)) {
    stop(
      "Use the binary BEAST2 executable for marginal likelihood estimation. \n",
      "Actual path: ", beast2_bin_path
    )
  }
  if (!beautier::is_mcmc_nested_sampling(inference_model$mcmc)) {
    stop(
      "'inference_model$mcmc' must be a nested sampling MCMC. ",
      "Tip: use 'beautier::create_mcmc_nested_sampling'. \n",
      "Actual value: ", mcmc
    )
  }

  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_ns_pkg_installed())

  ns <- list()

  inference_model <- beautier::create_inference_model(
    site_model = site_model,
    clock_model = clock_model,
    tree_prior = tree_prior,
    mcmc = mcmc
  )
  beast2_options <- beastier::create_beast2_options(
    rng_seed = rng_seed,
    overwrite = TRUE,
    input_filename = file.path(beast2_working_dir, "mcbette.xml"),
    output_log_filename = file.path(beast2_working_dir, "mcbette.log"),
    output_trees_filenames = file.path(beast2_working_dir, "mcbette.trees"),
    output_state_filename = file.path(beast2_working_dir, "mcbette.xml.state"),
    beast2_working_dir = beast2_working_dir,
    beast2_path = beast2_bin_path,
    verbose = verbose
  )

  ns <- NA

  tryCatch({
      bbt_run_out <- babette::bbt_run_from_model(
        fasta_filename = fasta_filename,
        inference_model = inference_model,
        beast2_options = beast2_options
      )
      testit::assert("ns" %in% names(bbt_run_out))
      ns <- bbt_run_out$ns
    },
    error = function(e) {
      stop(
        "Could not estimate the marginal likelihood. \n",
        "Error message: ", e$message, "\n",
        "fasta_filename: ", fasta_filename, "\n",
        "beast2_options: ", beast2_options, "\n",
        "inference_model: ", inference_model, "\n"
      )
    }
  )
  testit::assert(!beautier::is_one_na(ns))
  ns
}
