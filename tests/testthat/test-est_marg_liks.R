test_that("use, 8 models", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()
  if (!beastier::is_on_travis()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  # idx | site | clock  | tree                                                  # nolint this is not code
  # ----|------|--------|-----                                                  # nolint this is not code
  #  1  | JC   | strict | Yule                                                  # nolint this is not code
  #  2  | JC   | strict | BD                                                    # nolint this is not code
  #  3  | JC   | RLN    | Yule                                                  # nolint this is not code
  #  4  | JC   | RLN    | BD                                                    # nolint this is not code
  #  5  | HKY  | strict | Yule                                                  # nolint this is not code
  #  6  | HKY  | strict | BD                                                    # nolint this is not code
  #  7  | HKY  | RLN    | Yule                                                  # nolint this is not code
  #  8  | HKY  | RLN    | BD                                                    # nolint this is not code
  mcmc <- beautier::create_test_ns_mcmc()
  inference_model_1 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    clock_model = beautier::create_strict_clock_model(),
    tree_prior = beautier::create_yule_tree_prior(),
    mcmc = mcmc
  )
  inference_model_2 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    clock_model = beautier::create_strict_clock_model(),
    tree_prior = beautier::create_bd_tree_prior(),
    mcmc = mcmc
  )
  inference_model_3 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    clock_model = beautier::create_rln_clock_model(),
    tree_prior = beautier::create_yule_tree_prior(),
    mcmc = mcmc
  )
  inference_model_4 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model(),
    clock_model = beautier::create_rln_clock_model(),
    tree_prior = beautier::create_bd_tree_prior(),
    mcmc = mcmc
  )
  inference_model_5 <- beautier::create_inference_model(
    site_model = beautier::create_hky_site_model(),
    clock_model = beautier::create_strict_clock_model(),
    tree_prior = beautier::create_yule_tree_prior(),
    mcmc = mcmc
  )
  inference_model_6 <- beautier::create_inference_model(
    site_model = beautier::create_hky_site_model(),
    clock_model = beautier::create_strict_clock_model(),
    tree_prior = beautier::create_bd_tree_prior(),
    mcmc = mcmc
  )
  inference_model_7 <- beautier::create_inference_model(
    site_model = beautier::create_hky_site_model(),
    clock_model = beautier::create_rln_clock_model(),
    tree_prior = beautier::create_yule_tree_prior(),
    mcmc = mcmc
  )
  inference_model_8 <- beautier::create_inference_model(
    site_model = beautier::create_hky_site_model(),
    clock_model = beautier::create_rln_clock_model(),
    tree_prior = beautier::create_bd_tree_prior(),
    mcmc = mcmc
  )
  inference_models <- list(
    inference_model_1,
    inference_model_2,
    inference_model_3,
    inference_model_4,
    inference_model_5,
    inference_model_6,
    inference_model_7,
    inference_model_8
  )
  beast2_options <- beastier::create_beast2_options(
    beast2_path = beastier::get_default_beast2_bin_path()
  )
  beast2_optionses <- list(
    beast2_options,
    beast2_options,
    beast2_options,
    beast2_options,
    beast2_options,
    beast2_options,
    beast2_options,
    beast2_options
  )

  df <- est_marg_liks(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses,
    verbose = FALSE
  )

  expect_true(is.data.frame(df))
  expect_equal(
    nrow(df),
    length(inference_models)
  )
  expect_true("site_model_name" %in% colnames(df))
  expect_true("clock_model_name" %in% colnames(df))
  expect_true("tree_prior_name" %in% colnames(df))
  expect_true("marg_log_lik" %in% colnames(df))
  expect_true("marg_log_lik_sd" %in% colnames(df))
  expect_true("weight" %in% colnames(df))
  expect_true("ess" %in% colnames(df))

  expect_true(is.factor(df$site_model_name))
  expect_true(is.factor(df$clock_model_name))
  expect_true(is.factor(df$tree_prior_name))
  expect_true(!is.factor(df$marg_log_lik))
  expect_true(!is.factor(df$marg_log_lik_sd))
  expect_true(!is.factor(df$weight))

  expect_true(all(df$marg_log_lik < 0.0))
  expect_true(all(df$marg_log_lik_sd > 0.0))
  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))
})

test_that("use, 1 model", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  df <- est_marg_liks(
    fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
    inference_models = list(beautier::create_test_ns_inference_model()),
    beast2_optionses = list(create_mcbette_beast2_options())
  )
  expect_equal(1, nrow(df))
  expect_true(df$marg_log_lik < 0.0)
  expect_true(df$marg_log_lik_sd > 0.0)
  expect_equal(1.0, df$weight)
})

test_that("use, 1 model, CBS", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  inference_model <- beautier::create_test_ns_inference_model(
    tree_prior = beautier::create_cbs_tree_prior(),
  )
  inference_models <- list(inference_model)
  beast2_options <- create_mcbette_beast2_options()
  beast2_optionses <- list(beast2_options)

  expect_error(
    est_marg_liks(
      fasta_filename,
      inference_models = inference_models,
      beast2_optionses = beast2_optionses
    ),
    "'group_sizes_dimension' .* must be less than the number of taxa"
  )
})

test_that("use with same RNG seed must result in identical output", {

  if (!beastier::is_on_travis()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  inference_model <- beautier::create_test_ns_inference_model(
    mcmc = beautier::create_test_ns_mcmc()
  )
  inference_models <- list(inference_model, inference_model)
  beast2_options <- create_mcbette_beast2_options(rng_seed = 314)
  beast2_optionses <- list(beast2_options, beast2_options)

  df_1 <- est_marg_liks(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses
  )
  df_2 <- est_marg_liks(
    fasta_filename,
    inference_models = inference_models,
    beast2_optionses = beast2_optionses
  )
  expect_equal(df_1, df_2)
})

test_that("abuse", {

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  # no FASTA file
  expect_error(
    est_marg_liks(
      fasta_filename = "abs.ent",
      inference_models = "irrelevant"
    ),
    "'fasta_filename' must be the name of an existing FASTA file"
  )

  # no inference models
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename,
      inference_models = list()
    ),
    "'inference_models' must be a list of at least 1 inference model"
  )

  # mcmc must be nested_sampling_mcmcs
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename,
      inference_models = list(
        beautier::create_inference_model(mcmc = beautier::create_mcmc())
      )
    ),
    "'inference_models' must have 'mcmc's for nested sampling"
  )

  # Unsupported OS
  expect_error(
    est_marg_liks(
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
