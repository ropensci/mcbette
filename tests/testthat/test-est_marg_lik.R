test_that("use, 1 model", {

  skip("WIP. Issue 10. Issue #10")
  if (!beastier::is_beast2_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  marg_lik <- est_marg_lik(
    fasta_filename,
    epsilon = 1e7,
    verbose = TRUE
  )

  expect_true(is.list(marg_lik))
  expect_true("marg_log_lik" %in% names(marg_lik))
  expect_true("marg_log_lik_sd" %in% names(marg_lik))
  expect_true("ess" %in% names(marg_lik))
  expect_true("estimates" %in% names(marg_lik))
  expect_true("trees" %in% names(marg_lik))
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik))
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik_sd))
  expect_true(beautier::is_one_double(marg_lik$ess))
  expect_true(marg_lik$marg_log_lik < 0.0)
  expect_true(marg_lik$marg_log_lik_sd > 0.0)
})

test_that("use with same RNG seed must result in identical output", {

  if (!beastier::is_on_travis()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  df_1 <- est_marg_liks(
    fasta_filename,
    site_models = beautier::create_site_models()[1:2],
    clock_models = beautier::create_clock_models()[1:2],
    tree_priors = beautier::create_tree_priors()[1:2],
    epsilon = 1e7,
    rng_seed = 314
  )
  df_2 <- est_marg_liks(
    fasta_filename,
    site_models = beautier::create_site_models()[1:2],
    clock_models = beautier::create_clock_models()[1:2],
    tree_priors = beautier::create_tree_priors()[1:2],
    epsilon = 1e7,
    rng_seed = 314
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
