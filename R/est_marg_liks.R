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
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   # Only compare two site models
#'   df <- est_marg_liks(
#'     fasta_filename,
#'     site_models = list(
#'       beautier::create_jc69_site_model(),
#'       beautier::create_hky_site_model()
#'     ),
#'     clock_models = list(beautier::create_strict_clock_model()),
#'     tree_priors = list(beautier::create_yule_tree_prior()),
#'     epsilon = 1e7
#'   )
#'
#'   testthat::expect_true(is.data.frame(df))
#'   testthat::expect_true("site_model_name" %in% colnames(df))
#'   testthat::expect_true("clock_model_name" %in% colnames(df))
#'   testthat::expect_true("tree_prior_name" %in% colnames(df))
#'   testthat::expect_true("marg_log_lik" %in% colnames(df))
#'   testthat::expect_true("marg_log_lik_sd" %in% colnames(df))
#'   testthat::expect_true("weight" %in% colnames(df))
#'
#'   testthat::expect_true(is.factor(df$site_model_name))
#'   testthat::expect_true(is.factor(df$clock_model_name))
#'   testthat::expect_true(is.factor(df$tree_prior_name))
#'   testthat::expect_true(!is.factor(df$marg_log_lik))
#'   testthat::expect_true(!is.factor(df$marg_log_lik_sd))
#'   testthat::expect_true(!is.factor(df$weight))
#'
#'   testthat::expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
#'   testthat::expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
#'   testthat::expect_true(all(df$weight >= 0.0))
#'   testthat::expect_true(all(df$weight <= 1.0))
#' @author Richel J.C. Bilderbeek
#' @export
est_marg_liks <- function(
  fasta_filename,
  site_models = beautier::create_site_models(),
  clock_models = beautier::create_clock_models(),
  tree_priors = beautier::create_tree_priors(),
  epsilon = 10e-13,
  rng_seed = 1,
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
  beautier::check_site_models(site_models)
  beautier::check_clock_models(clock_models)
  beautier::check_tree_priors(tree_priors)
  if (!is.numeric(epsilon) || length(epsilon) != 1) {
    stop("'epsilon' must be one numerical value. Actual value(s): ", epsilon)
  }

  testit::assert(file.exists(fasta_filename))
  testit::assert(beastier::is_beast2_installed())
  testit::assert(mauricer::is_beast2_pkg_installed("NS"))

  n_rows <- length(site_models) *
    length(clock_models) * length(tree_priors)

  site_model_names <- rep(NA, n_rows)
  clock_model_names <- rep(NA, n_rows)
  tree_prior_names <- rep(NA, n_rows)
  marg_log_liks <- rep(NA, n_rows)
  marg_log_lik_sds <- rep(NA, n_rows)

  # Pick a site model
  row_index <- 1
  for (site_model in site_models) {
    for (clock_model in clock_models) {
      for (tree_prior in tree_priors) {
        tryCatch({
            marg_lik <- babette::bbt_run(
              fasta_filename = fasta_filename,
              site_model = site_model,
              clock_model = clock_model,
              tree_prior = tree_prior,
              mcmc = beautier::create_mcmc_nested_sampling(epsilon = epsilon),
              beast2_path = beastier::get_default_beast2_bin_path(),
              rng_seed = rng_seed,
              overwrite = TRUE
            )$ns
            print(marg_lik)
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

  weights <- as.numeric(
    calc_weights(marg_liks = exp(Rmpfr::mpfr(marg_log_liks, 512)))
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
