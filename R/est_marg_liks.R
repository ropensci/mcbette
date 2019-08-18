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
#' library(testthat)
#'
#' fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#' # Only compare two site models
#' df <- est_marg_liks(
#'   fasta_filename,
#'   site_models = list(
#'     create_jc69_site_model(),
#'     create_hky_site_model()
#'   ),
#'   clock_models = list(create_strict_clock_model()),
#'   tree_priors = list(create_yule_tree_prior()),
#'   epsilon = 1e7
#' )
#'
#' expect_true(is.data.frame(df))
#' expect_true("site_model_name" %in% colnames(df))
#' expect_true("clock_model_name" %in% colnames(df))
#' expect_true("tree_prior_name" %in% colnames(df))
#' expect_true("marg_log_lik" %in% colnames(df))
#' expect_true("marg_log_lik_sd" %in% colnames(df))
#' expect_true("weight" %in% colnames(df))
#' expect_true("ess" %in% colnames(df))
#'
#' expect_true(is.factor(df$site_model_name))
#' expect_true(is.factor(df$clock_model_name))
#' expect_true(is.factor(df$tree_prior_name))
#' expect_true(!is.factor(df$marg_log_lik))
#' expect_true(!is.factor(df$marg_log_lik_sd))
#' expect_true(!is.factor(df$weight))
#'
#' expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
#' expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
#' expect_true(all(df$weight >= 0.0))
#' expect_true(all(df$weight <= 1.0))
#' @author Richèl J.C. Bilderbeek
#' @export
est_marg_liks <- function(
  fasta_filename,
  site_models = beautier::create_site_models(),
  clock_models = beautier::create_clock_models(),
  tree_priors = beautier::create_tree_priors(),
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
  beautier::check_site_models(site_models)
  beautier::check_clock_models(clock_models)
  beautier::check_tree_priors(tree_priors)
  if (!beautier::is_one_double(epsilon)) {
    stop("'epsilon' must be one numerical value. Actual value(s): ", epsilon)
  }

  n_models <- length(site_models) * length(clock_models) * length(tree_priors)

  # Create inference models
  row_index <- 1
  inference_models <- list()
  for (site_model in site_models) {
    for (clock_model in clock_models) {
      for (tree_prior in tree_priors) {
        inference_model <- beautier::create_inference_model(
          site_model = site_model,
          clock_model = clock_model,
          tree_prior = tree_prior,
          mcmc = beautier::create_nested_sampling_mcmc(epsilon = epsilon)
        )
        inference_models[[row_index]] <- inference_model
        row_index <- row_index + 1
      }
    }
  }
  testit::assert(length(inference_models) == n_models)

  beast2_options <- beastier::create_beast2_options(
    rng_seed = rng_seed,
    verbose = verbose,
    beast2_path = beastier::get_default_beast2_bin_path(),
    beast2_working_dir = beast2_working_dir
  )
  beast2_optionses <- rep(list(beast2_options), times = n_models)
  testit::assert(length(beast2_optionses) == n_models)

  est_marg_liks_from_models(
    fasta_filename = fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses,
    verbose = verbose,
    os = os
  )
}
