#' Estimate the marginal likelihood for an inference model.
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
#' @seealso
#' \itemize{
#'   \item \link{can_run_mcbette}: see if 'mcbette' can run
#'   \item \link{est_marg_lik}: estimate multiple marginal likelihoods
#' }
#' @examples
#' if (can_run_mcbette()) {
#'
#'   library(testthat)
#'
#'   # An example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   # A testing inference model with inaccurate (thus fast) marginal
#'   # likelihood estimation
#'   inference_model <- beautier::create_test_ns_inference_model()
#'
#'   # Setup the options for BEAST2 to be able to call BEAST2 packages
#'   beast2_options <- create_mcbette_beast2_options()
#'
#'   # Estimate the marginal likelihood
#'   marg_lik <- est_marg_lik(
#'     fasta_filename = fasta_filename,
#'     inference_model = inference_model,
#'     beast2_options = beast2_options
#'   )
#'
#'   # Results are:
#'   # a list ...
#'   expect_true(is.list(marg_lik))
#'
#'   # with these elements ...
#'   expect_true("marg_log_lik" %in% names(marg_lik))
#'   expect_true("marg_log_lik_sd" %in% names(marg_lik))
#'   expect_true("ess" %in% names(marg_lik))
#'
#'   # with these data types ...
#'   expect_true(beautier::is_one_double(marg_lik$marg_log_lik))
#'   expect_true(beautier::is_one_double(marg_lik$marg_log_lik_sd))
#'   expect_true(beautier::is_one_double(marg_lik$ess))
#'
#'   # with these values
#'   expect_true(marg_lik$marg_log_lik < 0.0)
#'   expect_true(marg_lik$marg_log_lik_sd > 0.0)
#'   expect_true(marg_lik$ess > 0.0)
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
est_marg_lik <- function(
  fasta_filename,
  inference_model = create_ns_inference_model(),
  beast2_options = create_mcbette_beast2_options(),
  os = rappdirs::app_dir()$os
) {
  beautier::check_file_exists(fasta_filename)
  beautier::check_inference_model(inference_model)
  beastier::check_beast2_options(beast2_options)
  beastier::check_os(os)
  if (os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
  if (!beastier::is_beast2_installed()) {
    stop("BEAST2 not installed. Tip: use beastier::install_beast2()")
  }
  if (!beastier::is_bin_path(beast2_options$beast2_path)) {
    stop(
      "Use the binary BEAST2 executable for marginal likelihood estimation. \n",
      "Actual path: ", beast2_options$beast2_path
    )
  }
  mcbette::check_beast2_ns_pkg()

  beautier::check_nested_sampling_mcmc(inference_model$mcmc)

  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_ns_pkg_installed())

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
