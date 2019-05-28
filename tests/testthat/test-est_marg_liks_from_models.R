context("test-est_marg_liks_from_models")

test_that("use", {

  if (!beastier::is_beast2_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  inference_model_1 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    mcmc = beautier::create_nested_sampling_mcmc()
  )
  inference_model_2 <- beautier::create_inference_model(
    site_model = beautier::create_hky_site_model(),
    mcmc = beautier::create_nested_sampling_mcmc()
  )
  inference_models <- list(inference_model_1, inference_model_2)
  beast2_options <- beastier::create_beast2_options(
    beast2_path = beastier::get_default_beast2_bin_path()
  )
  beast2_optionses <- list(beast2_options, beast2_options)

  df <- est_marg_liks_from_models(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses,
    epsilon = 1e7,
    verbose = TRUE
  )

  expect_true(is.data.frame(df))
  expect_true("site_model_name" %in% colnames(df))
  expect_true("clock_model_name" %in% colnames(df))
  expect_true("tree_prior_name" %in% colnames(df))
  expect_true("marg_log_lik" %in% colnames(df))
  expect_true("marg_log_lik_sd" %in% colnames(df))
  expect_true("weight" %in% colnames(df))

  expect_true(is.factor(df$site_model_name))
  expect_true(is.factor(df$clock_model_name))
  expect_true(is.factor(df$tree_prior_name))
  expect_true(!is.factor(df$marg_log_lik))
  expect_true(!is.factor(df$marg_log_lik_sd))
  expect_true(!is.factor(df$weight))

  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))

  expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
  expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
})

test_that("use with same RNG seed must result in identical output", {

  if (!beastier::is_on_travis()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  inference_model_1 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    mcmc = beautier::create_nested_sampling_mcmc()
  )
  inference_model_2 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    mcmc = beautier::create_nested_sampling_mcmc()
  )
  inference_models <- list(inference_model_1, inference_model_2)
  beast2_options <- beastier::create_beast2_options(
    beast2_path = beastier::get_default_beast2_bin_path(),
    rng_seed = 314
  )
  beast2_optionses <- list(beast2_options, beast2_options)
  epsilon <- 100
  df_1 <- est_marg_liks_from_models(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses,
    epsilon = epsilon
  )
  df_2 <- est_marg_liks_from_models(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses,
    epsilon = epsilon
  )
  expect_equal(df_1, df_2)

})

test_that("abuse", {

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  # no FASTA file
  expect_error(
    est_marg_liks_from_models(
      fasta_filename = "abs.ent",
      inference_models = "irrelevant"
    ),
    "'fasta_filename' must be the name of an existing FASTA file"
  )

  # no inference models
  expect_error(
    est_marg_liks_from_models(
      fasta_filename = fasta_filename,
      inference_models = list()
    ),
    "'inference_models' must be a list of at least 1 inference model"
  )

  # mcmc must be nested_sampling_mcmcs
  expect_error(
    est_marg_liks_from_models(
      fasta_filename = fasta_filename,
      inference_models = list(
        beautier::create_inference_model(mcmc = beautier::create_mcmc())
      )
    ),
    "'inference_models' must have 'mcmc's for nested sampling"
  )

  # epsilon
  expect_error(
    est_marg_liks_from_models(
      fasta_filename = fasta_filename,
      inference_models = list(
        beautier::create_inference_model(
          mcmc = beautier::create_nested_sampling_mcmc()
        )
      ),
      epsilon = "nonsense"
    ),
    "'epsilon' must be one numerical value"
  )

  # Unsupported OS
  expect_error(
    est_marg_liks_from_models(
      fasta_filename = fasta_filename,
      inference_models = list(
        beautier::create_inference_model(
          mcmc = beautier::create_neste_sampling_mcmc()
        )
      ),
      os = "win"
    ),
    "mcbette must run on Linux or Mac"
  )
})
