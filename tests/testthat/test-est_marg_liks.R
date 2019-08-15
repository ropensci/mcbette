test_that("use, 8 models", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  site_models <- list(create_jc69_site_model(), create_hky_site_model())
  clock_models <- list(create_strict_clock_model(), create_rln_clock_model())
  # Cannot use a CBS tree prior, as the FASTA file has only two taxa
  tree_priors <- list(create_yule_tree_prior(), create_bd_tree_prior())

  df <- est_marg_liks(
    fasta_filename,
    site_models = site_models,
    clock_models = clock_models,
    tree_priors = tree_priors,
    epsilon = 1e7
  )

  expect_true(is.data.frame(df))
  expect_equal(
    nrow(df),
    length(site_models) * length(clock_models) * length(tree_priors)
  )
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

  expect_true(all(df$marg_log_lik < 0.0))
  expect_true(all(df$marg_log_lik_sd > 0.0))
  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))
})

test_that("use, 1 model", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  df <- est_marg_liks(
    fasta_filename,
    site_models = list(beautier::create_jc69_site_model()),
    clock_models = list(beautier::create_strict_clock_model()),
    tree_priors = list(beautier::create_yule_tree_prior()),
    epsilon = 1e7
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
  expect_error(
    est_marg_liks(
      fasta_filename,
      site_models = list(beautier::create_jc69_site_model()),
      clock_models = list(beautier::create_strict_clock_model()),
      tree_priors = list(beautier::create_cbs_tree_prior())
    ),
    "'group_sizes_dimension' .* must be less than the number of taxa"
  )
})

test_that("use with same RNG seed must result in identical output", {

  if (!beastier::is_on_travis()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  site_models <- list(create_jc69_site_model())
  clock_models <- list(create_strict_clock_model())
  # Cannot use a CBS tree prior, as the FASTA file has only two taxa
  tree_priors <- list(create_yule_tree_prior(), create_bd_tree_prior())

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
