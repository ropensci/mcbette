test_that("use, JC69, strict, Yule", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  marg_lik <- est_marg_lik(
    fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
    inference_model = create_test_ns_inference_model(),
    beast2_options = create_mcbette_beast2_options()
  )

  # A list
  expect_true(is.list(marg_lik))

  # with the right elements
  expect_true("marg_log_lik" %in% names(marg_lik))
  expect_true("marg_log_lik_sd" %in% names(marg_lik))
  expect_true("ess" %in% names(marg_lik))
  expect_true("estimates" %in% names(marg_lik))
  expect_true("trees" %in% names(marg_lik))

  # elements have the right data type
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik))
  expect_true(beautier::is_one_double(marg_lik$marg_log_lik_sd))
  expect_true(beautier::is_one_double(marg_lik$ess))
  expect_true(assertive::is_data.frame(marg_lik$estimates))
  expect_equal(class(marg_lik$trees), "multiPhylo")

  # elements have the right values
  expect_true(marg_lik$marg_log_lik < 0.0)
  expect_true(marg_lik$marg_log_lik_sd > 0.0)
  expect_true(marg_lik$ess > 0.0)
})

test_that("use, all non-default: GTR, RLN, BD", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  expect_silent(
    est_marg_lik(
      fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
      inference_model = create_test_ns_inference_model(
        site_model = beautier::create_gtr_site_model(),
        clock_model = beautier::create_rln_clock_model(),
        tree_prior = beautier::create_bd_tree_prior(),
        mcmc = create_nested_sampling_mcmc(epsilon = 1e2)
      ),
      beast2_options = create_mcbette_beast2_options()
    )
  )
})

test_that("use, too few taxa for CBS", {

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()


  expect_error(
    est_marg_lik(
      fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
      inference_model = create_test_ns_inference_model(
        tree_prior = beautier::create_cbs_tree_prior()
      ),
      beast2_options = create_mcbette_beast2_options()
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

  if (!beastier::is_beast2_installed()) return()
  if (!mauricer::is_beast2_ns_pkg_installed()) return()

  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  inference_model_1 = create_test_ns_inference_model(
    mcmc = create_nested_sampling_mcmc(
      particle_count = 1
    )
  )
  inference_model_10 = create_test_ns_inference_model(
    mcmc = create_nested_sampling_mcmc(
      particle_count = 10
    )
  )
  beast2_options <- create_mcbette_beast2_options()

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
  marg_lik_low_sd$marg_log_lik_sd
  marg_lik_high_sd$marg_log_lik_sd

  expect_true(
    marg_lik_low_sd$marg_log_lik_sd < marg_lik_high_sd$marg_log_lik_sd
  )
})
