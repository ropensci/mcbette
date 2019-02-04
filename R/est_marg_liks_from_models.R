#' Estimate the marginal likelihoods for all combinations of
#' site, clock and tree models
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
#' }
#' @author Richel J.C. Bilderbeek
#' @export
est_marg_liks_from_models <- function(
  fasta_filename,
  inference_models = list(beautier::create_inference_model()),
  beast2_optionses = rep(
    list(beastier::create_beast2_options()), times = length(inference_models)
  ),
  epsilon = 10e-13,
  verbose = FALSE
) {
  if (rappdirs::app_dir()$os == "win") {
    stop(
      "mcbette must run on Linux or Mac.\n",
      "\n",
      "It is not yet supported to call BEAST2 with packages installed\n",
      "in a scripted way"
    )
  }
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
  if (!is.numeric(epsilon) || length(epsilon) != 1) {
    stop("'epsilon' must be one numerical value. Actual value(s): ", epsilon)
  }
  for (inference_model in inference_models) {
    if (!beautier::is_nested_sampling_mcmc(inference_model$mcmc)) {
      stop(
        "'inference_models' must have 'mcmc's for nested sampling.\n",
        "Tip: use 'beautier::create_nested_sampling_mcmc'"
      )
    }
  }
  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_pkg_installed("NS"))

  n_rows <- length(inference_models)

  site_model_names <- rep(NA, n_rows)
  clock_model_names <- rep(NA, n_rows)
  tree_prior_names <- rep(NA, n_rows)
  marg_log_liks <- rep(NA, n_rows)
  marg_log_lik_sds <- rep(NA, n_rows)

  # Pick a site model
  for (i in seq(1, n_rows)) {
    inference_model <- inference_models[[i]]
    beast2_options <- beast2_optionses[[i]]
    beautier::check_inference_model(inference_model)
    beastier::check_beast2_options(beast2_options)

    tryCatch({
        bbt_out <- babette::bbt_run_from_model(
          fasta_filename = fasta_filename,
          inference_model = inference_model,
          beast2_options = beast2_options
        )
        testit::assert("ns" %in% names(bbt_out))
        marg_lik <- bbt_out$ns
        testit::assert("marg_log_lik" %in% names(marg_lik))
        testit::assert("marg_log_lik_sd" %in% names(marg_lik))
        marg_log_liks[i] <- marg_lik$marg_log_lik
        marg_log_lik_sds[i] <- marg_lik$marg_log_lik_sd
      },
      error = function(msg) {
        if (verbose) print(msg)
      }
    )
    site_model_names[i] <- inference_model$site_model$name
    clock_model_names[i] <- inference_model$clock_model$name
    tree_prior_names[i] <- inference_model$tree_prior$name
  }

  weights <- as.numeric(
    calc_weights(marg_liks = exp(Rmpfr::mpfr(marg_log_liks, 256)))
  )

  df <- data.frame(
    site_model_name = site_model_names,
    clock_model_name = clock_model_names,
    tree_prior_name = tree_prior_names,
    marg_log_lik = marg_log_liks,
    marg_log_lik_sd = marg_log_lik_sds,
    weight = weights
  )
  df
}
