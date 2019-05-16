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
  # no inference models
  expect_error(
    est_marg_liks_from_models(
      system.file("extdata", "simple.fas", package = "mcbette"),
      inference_models = list()
    ),
    "'inference_models' must be a list of at least 1 inference model"
  )

  # mcmc must be nested_sampling_mcmcs
  expect_error(
    est_marg_liks_from_models(
      system.file("extdata", "simple.fas", package = "mcbette"),
      inference_models = list(
        beautier::create_inference_model(mcmc = beautier::create_mcmc())
      )
    ),
    "'inference_models' must have 'mcmc's for nested sampling"
  )

})


test_that("Issue #7", {

  skip("Issue #7")

  if (!beastier::is_beast2_installed()) return()

  args <- c(33)
  print(paste("Number of arguments:", length(args)))

  example_no <- 3
  root_folder <- path.expand("~/GitHubs/pirouette_article")
  example_folder <- file.path(root_folder, paste0("example_", example_no))
  rng_seed <- 314

  if (length(args) == 1) {
    rng_seed <- as.numeric(args[1])
    example_folder <- file.path(root_folder, paste0("example_", example_no, "_", rng_seed))
  } else {
    stop("Need argument")
  }

  print(rng_seed)
  print(example_folder)

  library(pirouette)
  library(ggplot2)
  library(ggtree)

  dir.create(example_folder, showWarnings = FALSE)
  setwd(example_folder)
  # No need to do 'set.seed(rng_seed)': we use 'rng_seed' arguments instead

  testit::assert(is_beast2_installed())

  phylogeny  <- ape::read.tree(text = "(((A:8, B:8):1, C:9):1, ((D:8, E:8):1, F:9):1);")

  alignment_params <- create_alignment_params(
    root_sequence = create_blocked_dna(length = 100),
    mutation_rate = 0.1,
    rng_seed = rng_seed
  )

  experiments <- list(create_gen_experiment(beast2_options = create_beast2_options(rng_seed = rng_seed)))

  # Testing
  if (1 == 2) {
    for (i in seq_along(experiments)) {
      experiments[[i]]$inference_model$mcmc <- create_mcmc(chain_length = 10000, store_every = 1000)
      experiments[[i]]$est_evidence_mcmc <- create_mcmc_nested_sampling(
        chain_length = 10000,
        store_every = 1000,
        epsilon = 100.0
      )
    }
  }

  twinning_params <- create_twinning_params(
    twin_model = "birth_death",
    method = "random_tree",
   rng_seed = rng_seed
  )

  pir_params <- create_pir_params(
    alignment_params = alignment_params,
    experiments = experiments,
    twinning_params = twinning_params
  )

  if (1 == 1) {
    print("#######################################################################")
    print("Settings to run on Peregrine cluster")
    print("#######################################################################")
    pir_params$alignment_params$fasta_filename <- file.path(example_folder, "true.fasta")
    for (i in seq_along(pir_params$experiments)) {
      pir_params$experiments[[i]]$beast2_options$input_filename <- file.path(example_folder, "beast2_input.xml")
      pir_params$experiments[[i]]$beast2_options$output_log_filename <- file.path(example_folder, "beast2_output.log")
      pir_params$experiments[[i]]$beast2_options$output_trees_filenames <- file.path(example_folder, "beast2_output.trees")
      pir_params$experiments[[i]]$beast2_options$output_state_filename <- file.path(example_folder, "beast2_output.xml.state")
      pir_params$experiments[[i]]$beast2_options$beast2_working_dir <- example_folder
      pir_params$experiments[[i]]$errors_filename <- file.path(example_folder, "error.csv")
    }
    pir_params$evidence_filename <- file.path(example_folder, "evidence_true.csv")
    if (!is_one_na(pir_params$twinning_params)) {
      pir_params$twinning_params$twin_tree_filename <- file.path(example_folder, "twin.tree")
      pir_params$twinning_params$twin_alignment_filename <- file.path(example_folder, "twin.fasta")
      pir_params$twinning_params$twin_evidence_filename <- file.path(example_folder, "evidence_twin.csv")
    }
    rm_pir_param_files(pir_params)
    print("#######################################################################")
  }

  # Shorten run
    for (i in seq_along(pir_params$experiments)) {
      pir_params$experiments[[1]]$inference_model$mcmc$chain_length <- 3698000
    }

  Sys.time()
  # 11:24:52
  expect_silent(
    pir_run(
      phylogeny,
      pir_params = pir_params
    )
  )
  Sys.time()
})
