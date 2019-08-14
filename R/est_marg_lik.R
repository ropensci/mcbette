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
#' marg_lik <- est_marg_liks(
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
  site_model = beautier::create_jc69_site_model(),
  clock_model = beautier::create_strict_clock_model(),
  tree_prior = beautier::create_yule_tree_prior(),
  epsilon = 10e-13,
  rng_seed = 1,
  verbose = FALSE,
  beast2_working_dir = tempfile(pattern = "beast2_mcbette_tmp_folder"),
  beast2_bin_path = beastier::get_default_beast2_bin_path(),
  os = rappdirs::app_dir()$os
) {
  if (os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
  if (!beastier::is_bin_path(beast2_bin_path)) {
    stop(
      "Use the binary BEAST2 executable for marginal likelihood estimation. \n",
      "Actual path: ", beast2_bin_path
    )
  }
  if (!file.exists(fasta_filename)) {
    stop(
      "'fasta_filename' must be the name of an existing FASTA file.\n",
      "File '", fasta_filename, "' not found"
    )
  }
  beautier::check_site_model(site_model)
  beautier::check_clock_model(clock_model)
  beautier::check_tree_prior(tree_prior)
  if (!beautier::is_one_double(epsilon)) {
    stop("'epsilon' must be one numerical value. Actual value(s): ", epsilon)
  }

  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_ns_pkg_installed())

  ns <- list()

  inference_model <- beautier::create_inference_model(
    site_model = site_model,
    clock_model = clock_model,
    tree_prior = tree_prior,
    mcmc = beautier::create_mcmc_nested_sampling(epsilon = epsilon)
  )
  beast2_options <- beastier::create_beast2_options(
    rng_seed = rng_seed,
    overwrite = TRUE,
    beast2_working_dir = beast2_working_dir,
    beast2_path = beast2_bin_path,
    verbose = verbose
  )

  ns <- NULL

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
      if (verbose) {
        print(e$message)
      }
    }
  )

  ns
}
