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
#' @examples
#'   # Use an example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   # Create two inference models
#'   inference_model_1 <- beautier::create_inference_model(
#'     site_model = beautier::create_jc69_site_model(),
#'     mcmc = beautier::create_nested_sampling_mcmc()
#'   )
#'   inference_model_2 <- beautier::create_inference_model(
#'     site_model = beautier::create_hky_site_model(),
#'     mcmc = beautier::create_nested_sampling_mcmc()
#'   )
#'   inference_models <- list(inference_model_1, inference_model_2)
#'
#'   # Need the BEAST2 binary's path
#'   beast2_options <- beastier::create_beast2_options(
#'     beast2_path = beastier::get_default_beast2_bin_path()
#'   )
#'
#'   # Need as much beast2_optionses as inference models
#'   beast2_optionses <- list(beast2_options, beast2_options)
#'
#'   df <- est_marg_liks_from_models(
#'     fasta_filename,
#'     inference_models = inference_models,
#'     beast2_optionses = beast2_optionses,
#'     epsilon = 1e7
#'   )
#'
#'   # Testing the results
#'   library(testthat)
#'   expect_true(is.data.frame(df))
#'   expect_true("site_model_name" %in% colnames(df))
#'   expect_true("clock_model_name" %in% colnames(df))
#'   expect_true("tree_prior_name" %in% colnames(df))
#'   expect_true("marg_log_lik" %in% colnames(df))
#'   expect_true("marg_log_lik_sd" %in% colnames(df))
#'   expect_true("weight" %in% colnames(df))
#'
#'   expect_true(is.factor(df$site_model_name))
#'   expect_true(is.factor(df$clock_model_name))
#'   expect_true(is.factor(df$tree_prior_name))
#'   expect_true(!is.factor(df$marg_log_lik))
#'   expect_true(!is.factor(df$marg_log_lik_sd))
#'   expect_true(!is.factor(df$weight))
#'
#'   expect_true(all(df$weight >= 0.0))
#'   expect_true(all(df$weight <= 1.0))
#'   expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
#'   expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
#' @author Richel J.C. Bilderbeek
#' @export
est_marg_liks_from_models <- function(
  fasta_filename,
  inference_models = list(
    beautier::create_inference_model(
      mcmc = beautier::create_nested_sampling_mcmc()
    )
  ),
  beast2_optionses = rep(
    list(
      beastier::create_beast2_options(
        beast2_path = get_default_beast2_bin_path()
      )
    ),
    times = length(inference_models)
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
    if (verbose == TRUE) {
      print(
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
    testit::assert(beautier::is_nested_sampling_mcmc(inference_model$mcmc))

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
    if (verbose == TRUE) {
      print(
        paste0(
          "Log evidence for model ", i, "/", n_rows, ": ", marg_log_liks[i]
        )
      )
    }
  }

  weights <- as.numeric(
    calc_weights(marg_liks = exp(Rmpfr::mpfr(marg_log_liks, 512)))
  )
  if (abs(1.0 - sum(weights)) > 0.01) {
    warning(
      "Sum of weights should be 1.0. ",
      "Actual sum: ", sum(weights),
      "Maybe forgot to install libmpfr-dev? "
    )
  }

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
