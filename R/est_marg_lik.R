#' Estimate the marginal likelihood for an inference model.
#' @inheritParams default_params_doc
#' @return a \link{list} showing the estimated marginal likelihoods
#' (and its estimated error), its items are::
#' \itemize{
#'   \item \code{marg_log_lik}: estimated marginal (natural) log likelihood
#'   \item \code{marg_log_lik_sd}: estimated error of \code{marg_log_lik}
#'   \item \code{esses} the Effective Sample Size
#' }
#' @seealso
#' \itemize{
#'   \item \link{can_run_mcbette}: see if 'mcbette' can run
#'   \item \link{est_marg_liks}: estimate multiple marginal likelihoods
#' }
#' @examples
#' if (can_run_mcbette()) {
#'
#'   # An example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   # A testing inference model with inaccurate (thus fast) marginal
#'   # likelihood estimation
#'   inference_model <- beautier::create_ns_inference_model()
#'
#'   # Shorten the run, by doing a short (dirty, unreliable) MCMC
#'   inference_model$mcmc <- beautier::create_test_ns_mcmc()
#'
#'   # Setup the options for BEAST2 to be able to call BEAST2 packages
#'   beast2_options <- beastier::create_mcbette_beast2_options()
#'
#'   # Estimate the marginal likelihood
#'   est_marg_lik(
#'     fasta_filename = fasta_filename,
#'     inference_model = inference_model,
#'     beast2_options = beast2_options
#'   )
#'
#'   beastier::remove_beaustier_folders()
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
est_marg_lik <- function(
  fasta_filename,
  inference_model = beautier::create_ns_inference_model(),
  beast2_options = beastier::create_mcbette_beast2_options(),
  os = rappdirs::app_dir()$os
) {
  beautier::check_file_exists(fasta_filename)
  beautier::check_inference_model(inference_model)
  beastier::check_beast2_options(beast2_options)
  beastier::check_os(os)
  beast2_folder <- dirname(dirname(dirname(beast2_options$beast2_path)))
  if (!beastier::is_beast2_installed(folder_name = beast2_folder)) {
    stop(
      "BEAST2 not installed. \n",
      "'beast2_options$beast2_path': ", beast2_options$beast2_path, " \n",
      "'beast2_folder': ", beast2_folder, " \n",
      "Tip: use beastierinstall::install_beast2()"
    )
  }
  if (!beastier::is_bin_path(beast2_options$beast2_path)) {
    stop(
      "Use the binary BEAST2 executable for marginal likelihood estimation. \n",
      "Current path: ", beast2_options$beast2_path
    )
  }
  if (os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
  mcbette::check_beast2_ns_pkg(beast2_bin_path =  beast2_options$beast2_path)

  beautier::check_nested_sampling_mcmc(inference_model$mcmc)

  testthat::expect_true(file.exists(fasta_filename))
  testthat::expect_true(
    beastier::is_beast2_installed(folder_name = beast2_folder)
  )
  testthat::expect_true(
    mauricer::is_beast2_ns_pkg_installed(beast2_folder = beast2_folder)
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
        "beast2_options: ", paste0(beast2_options, collapse = " "), "\n",
        "inference_model: ", inference_model, "\n"
      )
    }
  )
  testit::assert(!beautier::is_one_na(ns))
  ns
}
