#' Estimate the marginal likelihoods for one or more inference models
#'
#' Estimate the marginal likelihoods (aka evidence)
#' for one or more inference models, based on a single alignment.
#' Also, the marginal likelihoods are compared, resulting in a
#' relative weight for each model, where a relative weight of a model
#' close to \code{1.0} means that that model is way likelier than
#' the others.
#'
#' In the process, multiple (temporary) files are created (where
#' \code{[x]} denotes the index in a list)
#'
#' \itemize{
#'   \item \code{beast2_optionses[x]$input_filename}
#'     path to the the BEAST2 XML input file
#'   \item \code{beast2_optionses[x]$output_state_filename}
#'     path to the BEAST2 XML state file
#'   \item \code{inference_models[x]$mcmc$tracelog$filename}
#'     path to the BEAST2 trace file with parameter estimates
#'   \item \code{inference_models[x]$mcmc$treelog$filename}
#'     path to the BEAST2 \code{trees} file with the posterior trees
#'   \item \code{inference_models[x]$mcmc$screenlog$filename}
#'     path to the BEAST2 screen output file
#' }
#'
#' These file can be deleted manually by \link[babette]{bbt_delete_temp_files},
#' else these will be deleted automatically by the operating system.
#' @inheritParams default_params_doc
#' @return a \link{data.frame} showing the estimated marginal likelihoods
#' (and its estimated error) per combination of models. Columns are:
#' \itemize{
#'   \item \code{site_model_name}: name of the site model
#'   \item \code{clock_model_name}: name of the clock model
#'   \item \code{tree_prior_name}: name of the tree prior
#'   \item \code{marg_log_lik}: estimated marginal (natural) log likelihood
#'   \item \code{marg_log_lik_sd}: estimated error of \code{marg_log_lik}
#'   \item \code{weight}: relative model weight, a value from 1.0 (all
#'     evidence is in favor of this model combination) to 0.0 (no
#'     evidence in favor of this model combination)
#'   \item \code{ess}: effective sample size of the marginal likelihood
#'     estimation
#' }
#' @seealso
#' \itemize{
#'   \item \link{can_run_mcbette}: see if 'mcbette' can run
#'   \item \link{est_marg_liks}: estimate multiple marginal likelihood of a
#'     single inference mode
#' }
#' @examples
#' if (can_run_mcbette()) {
#'
#'   # Use an example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   # Create two inference models
#'   inference_model_1 <- beautier::create_ns_inference_model(
#'     site_model = beautier::create_jc69_site_model()
#'   )
#'   inference_model_2 <- beautier::create_ns_inference_model(
#'     site_model = beautier::create_hky_site_model()
#'   )
#'
#'   # Shorten the run, by doing a short (dirty, unreliable) MCMC
#'   inference_model_1$mcmc <- beautier::create_test_ns_mcmc()
#'   inference_model_2$mcmc <- beautier::create_test_ns_mcmc()
#'
#'   # Combine the inference models
#'   inference_models <- list(inference_model_1, inference_model_2)
#'
#'   # Create the BEAST2 options, that will write the output
#'   # to different (temporary) filanems
#'   beast2_options_1 <- beastier::create_mcbette_beast2_options()
#'   beast2_options_2 <- beastier::create_mcbette_beast2_options()
#'
#'   # Combine the two BEAST2 options sets,
#'   # use reduplicated plural
#'   beast2_optionses <- list(beast2_options_1, beast2_options_2)
#'
#'   # Compare the models
#'   marg_liks <- est_marg_liks(
#'     fasta_filename,
#'     inference_models = inference_models,
#'     beast2_optionses = beast2_optionses
#'   )
#'
#'   # Interpret the results
#'   interpret_marg_lik_estimates(marg_liks)
#'
#'   beastier::remove_beaustier_folders()
#'   beastier::check_empty_beaustier_folders()
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
est_marg_liks <- function(
  fasta_filename,
  inference_models = list(
    beautier::create_inference_model(
      mcmc = beautier::create_ns_mcmc()
    )
  ),
  beast2_optionses = rep(
    list(beastier::create_mcbette_beast2_options()),
    times = length(inference_models)
  ),
  verbose = FALSE,
  os = rappdirs::app_dir()$os
) {
  if (!file.exists(fasta_filename)) {
    stop(
      "'fasta_filename' must be the name of an existing FASTA file.\n",
      "File '", fasta_filename, "' not found"
    )
  }
  beautier::check_inference_models(inference_models)
  if (length(inference_models) == 0) {
    stop(
      "'inference_models' must be a list of at least 1 inference model.\n",
      "Tip: use 'create_inference_model'"
    )
  }

  beastier::check_beast2_optionses(beast2_optionses)
  for (inference_model in inference_models) {
    if (!beautier::is_nested_sampling_mcmc(inference_model$mcmc)) {
      stop(
        "'inference_models' must have 'mcmc's for nested sampling.\n",
        "Tip: use 'beautier::create_ns_mcmc'"
      )
    }
  }
  if (os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_ns_pkg_installed())

  n_rows <- length(inference_models)

  site_model_names <- rep(NA, n_rows)
  clock_model_names <- rep(NA, n_rows)
  tree_prior_names <- rep(NA, n_rows)
  marg_log_liks <- rep(NA, n_rows)
  marg_log_lik_sds <- rep(NA, n_rows)
  esses <- rep(NA, n_rows)

  # Iterate over all inference models and BEAST2 optionses
  for (i in seq(1, n_rows)) {
    if (verbose == TRUE) {
      message(
        paste0(
          "Estimating evidence for model ", i, "/", n_rows, " with ",
          inference_models[[i]]$site_model$name, " site model, ",
          inference_models[[i]]$clock_model$name, " clock model and ",
          inference_models[[i]]$tree_prior$name, " tree prior"
        )
      )
    }
    inference_model <- inference_models[[i]]
    beast2_options <- beast2_optionses[[i]]
    beautier::check_inference_model(inference_model)
    beastier::check_beast2_options(beast2_options)
    beautier::check_nested_sampling_mcmc(inference_model$mcmc)
    ns <- mcbette::est_marg_lik(
      fasta_filename = fasta_filename,
      inference_model = inference_model,
      beast2_options = beast2_options,
      os = os
    )
    if (verbose) message(ns)
    testit::assert("marg_log_lik" %in% names(ns))
    testit::assert("marg_log_lik_sd" %in% names(ns))
    marg_log_liks[i] <- ns$marg_log_lik
    marg_log_lik_sds[i] <- ns$marg_log_lik_sd
    esses[i] <- ns$ess
    site_model_names[i] <- inference_model$site_model$name
    clock_model_names[i] <- inference_model$clock_model$name
    tree_prior_names[i] <- inference_model$tree_prior$name
  }

  weights <- as.numeric(
    mcbette::calc_weights(marg_liks = exp(Rmpfr::mpfr(marg_log_liks, 512)))
  )
  df <- data.frame(
    site_model_name = site_model_names,
    clock_model_name = clock_model_names,
    tree_prior_name = tree_prior_names,
    marg_log_lik = marg_log_liks,
    marg_log_lik_sd = marg_log_lik_sds,
    weight = weights,
    ess = esses,
    stringsAsFactors = TRUE
  )
  testthat::expect_true(
    abs(1.0 - sum(weights)) < 0.01,
    info = "Sum of weights should be 1.0. Maybe forgot to install libmpfr-dev?"
  )
  testthat::expect_true(is.factor(df$site_model_name))
  df
}
