context("test-est_marg_liks")

test_that("use, 2 models", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  df <- est_marg_liks(
    fasta_filename,
    site_models = beautier::create_site_models()[1:2],
    clock_models = beautier::create_clock_models()[1:1],
    tree_priors = beautier::create_tree_priors()[1:1],
    epsilon = 1e7
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

  expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
  expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))
})

test_that("use, 1 model", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  df <- est_marg_liks(
    fasta_filename,
    site_models = beautier::create_site_models()[1],
    clock_models = beautier::create_clock_models()[1],
    tree_priors = beautier::create_tree_priors()[1],
    epsilon = 1e7
  )
  expect_true(is.data.frame(df))
  expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
  expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))
  expect_true(1.0 - sum(df$weight) < 0.1)
})

test_that("use with same RNG seed must result in identical output", {

  if (!beastier::is_on_travis()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  site_models <- list()
  site_models[[1]] <- create_jc69_site_model()

  clock_models <- list()
  clock_models[[1]] <- create_strict_clock_model()

  # Cannot use a CBS tree prior, as the FASTA file has only two taxa
  tree_priors <- list()
  tree_priors[[1]] <- create_yule_tree_prior()
  tree_priors[[2]] <- create_bd_tree_prior()

  rng_seed <- 314
  epsilon <- 1e7

  df_1 <- est_marg_liks(
    fasta_filename,
    site_models = site_models,
    clock_models = clock_models,
    tree_priors = tree_priors,
    epsilon = epsilon,
    rng_seed = rng_seed
  )
  df_2 <- est_marg_liks(
    fasta_filename,
    site_models = site_models,
    clock_models = clock_models,
    tree_priors = tree_priors,
    epsilon = epsilon,
    rng_seed = rng_seed
  )
  expect_equal(df_1, df_2)
})

test_that("abuse", {

  # fasta_filename
  expect_error(
    est_marg_liks(fasta_filename = "nonsense"),
    "'fasta_filename' must be the name of an existing FASTA file"
  )
  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  # site_models
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, site_models = "nonsense"
    ),
    "'site_models' must be a list of one or more valid site models"
  )

  # clock_models
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, clock_models = "nonsense"
    ),
    "'clock_models' must be a list of one or more valid clock models"
  )

  # tree_priors
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, tree_priors = "nonsense"
    ),
    "'tree_priors' must be a list of one or more valid tree priors"
  )

  # epsilon
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, epsilon = "nonsense"
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, epsilon = c(1.2, 3.4, 5.6)
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, epsilon = NA
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename, epsilon = NULL
    ),
    "'epsilon' must be one numerical value"
  )

  expect_error(
    est_marg_liks(
      fasta_filename = fasta_filename,
      os = "win"
    ),
    "mcbette must run on Linux or Mac"
  )
})
