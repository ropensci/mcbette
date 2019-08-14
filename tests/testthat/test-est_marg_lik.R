test_that("use, JC69, strict, Yule", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  marg_lik <- est_marg_lik(
    fasta_filename,
    epsilon = 1e7
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

test_that("use, all non-default: GTR, RLN, BD", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  marg_lik <- est_marg_lik(
    fasta_filename = fasta_filename,
    site_model = create_gtr_site_model(),
    clock_model = create_rln_clock_model(),
    tree_prior = create_bd_tree_prior(),
    epsilon = 1e7
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

test_that("abuse", {

  # fasta_filename
  expect_error(
    est_marg_lik(fasta_filename = "nonsense"),
    "'fasta_filename' must be the name of an existing FASTA file"
  )
  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  # site_models
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, site_model = "nonsense"
    ),
    "'site_model' must be a valid site model"
  )

  # clock_models
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, clock_model = "nonsense"
    ),
    "'clock_model' must be a valid clock model"
  )

  # tree_priors
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, tree_prior = "nonsense"
    ),
    "'tree_prior' must be a valid tree prior"
  )

  # epsilon
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, epsilon = "nonsense"
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, epsilon = c(1.2, 3.4, 5.6)
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, epsilon = NA
    ),
    "'epsilon' must be one numerical value"
  )
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename, epsilon = NULL
    ),
    "'epsilon' must be one numerical value"
  )

  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      os = "win"
    ),
    "mcbette must run on Linux or Mac"
  )
})

