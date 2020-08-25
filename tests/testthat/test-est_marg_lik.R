test_that("use, JC69, strict, Yule", {

  if (!can_run_mcbette()) return()

  marg_lik <- est_marg_lik(
    fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
    inference_model = beautier::create_test_ns_inference_model(),
    beast2_options = beastier::create_mcbette_beast2_options()
  )

  # A list
  expect_true(is.list(marg_lik))

  # with the right elements
  expect_true("marg_log_lik" %in% names(marg_lik))
  expect_true("marg_log_lik_sd" %in% names(marg_lik))
  expect_true("ess" %in% names(marg_lik))

  # elements have the right data type
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik))
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik_sd))
  expect_true(beautier::is_one_double(marg_lik$ess))

  # elements have the right values
  expect_true(marg_lik$marg_log_lik < 0.0)
  expect_true(marg_lik$marg_log_lik_sd > 0.0)
  expect_true(marg_lik$ess > 0.0)
})

test_that("use, all non-default: GTR, RLN, BD", {

  if (!can_run_mcbette()) return()

  expect_silent(
    est_marg_lik(
      fasta_filename = system.file(
        "extdata", "simple.fas", package = "mcbette"
      ),
      inference_model = beautier::create_test_ns_inference_model(
        site_model = beautier::create_gtr_site_model(),
        clock_model = beautier::create_rln_clock_model(),
        tree_prior = beautier::create_bd_tree_prior(),
        mcmc = create_ns_mcmc(epsilon = 1e2)
      ),
      beast2_options = beastier::create_mcbette_beast2_options()
    )
  )
})

test_that("use, too few taxa for CBS", {

  if (!can_run_mcbette()) return()

  expect_error(
    est_marg_lik(
      fasta_filename = system.file(
        "extdata", "simple.fas", package = "mcbette"
      ),
      inference_model = beautier::create_test_ns_inference_model(
        tree_prior = beautier::create_cbs_tree_prior()
      ),
      beast2_options = beastier::create_mcbette_beast2_options()
    ),
    "'group_sizes_dimension' .* must be less than the number of taxa"
  )
})

test_that("abuse", {

  # fasta_filename
  expect_error(
    est_marg_lik(fasta_filename = "nonsense"),
    "File not found. Could not find file with path 'nonsense'"
  )
  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  # inference_model
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      inference_model = "nonsense"
    ),
    "'site_model' must be an element of an 'inference_model'"
  )

  # beast2_options
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      beast2_options = "nonsense"
    ),
    "'input_filename' must be an element of an 'beast2_options'"
  )

  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      beast2_options = create_beast2_options(
        beast2_path = beastier::get_default_beast2_jar_path()
      )
    ),
    "Use the binary BEAST2 executable for marginal likelihood estimation"
  )

  # os
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      os = "nonsense"
    ),
    "'os' must be either 'mac', 'unix' or 'win'"
  )
  expect_error(
    est_marg_lik(
      fasta_filename = fasta_filename,
      os = "win"
    ),
    "mcbette must run on Linux or Mac"
  )
})


test_that("more particles, less sd", {

  if (!can_run_mcbette()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  inference_model_1 <- beautier::create_test_ns_inference_model(
    mcmc = create_ns_mcmc(
      particle_count = 1
    )
  )
  inference_model_10 <- beautier::create_test_ns_inference_model(
    mcmc = create_ns_mcmc(
      particle_count = 10
    )
  )
  beast2_options <- beastier::create_mcbette_beast2_options(
    rng_seed = 314
  )

  marg_lik_high_sd <- est_marg_lik(
    fasta_filename = fasta_filename,
    inference_model = inference_model_1,
    beast2_options = beast2_options
  )
  marg_lik_low_sd <- est_marg_lik(
    fasta_filename = fasta_filename,
    inference_model = inference_model_10,
    beast2_options = beast2_options
  )
  expect_lt(
    marg_lik_low_sd$marg_log_lik_sd,
    marg_lik_high_sd$marg_log_lik_sd
  )
})

test_that("use BEAST2 installed at a different location", {

  if (!is_on_travis()) return()

  folder_name <- tempfile()
  beastier::install_beast2(folder_name = folder_name)
  expect_true(beastier::is_beast2_installed(folder_name = folder_name))

  beast2_bin_path <- beastier::get_default_beast2_bin_path(
    beast2_folder = folder_name
  )
  expect_true(file.exists(beast2_bin_path))
  beast2_options <- beastier::create_mcbette_beast2_options(
    beast2_bin_path = beast2_bin_path
  )

  expect_silent(beastier::check_beast2_options(beast2_options))

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

  expect_silent(
    est_marg_lik(
      fasta_filename = fasta_filename,
      inference_model = beautier::create_test_ns_inference_model(),
      beast2_options = beast2_options
    )
  )
})
