context("test-est_marg_liks_from_models")

test_that("use", {
  fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
  inference_model_1 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model()
  )
  inference_model_2 <- beautier::create_inference_model(
    site_model = beautier::create_jc69_site_model()
  )
  inference_models <- list(inference_model_1, inference_model_2)

  df <- est_marg_liks_from_models(
    fasta_filename,
    inference_models = inference_models,
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

  expect_true(all(df$weight >= 0.0))
  expect_true(all(df$weight <= 1.0))

  skip("WIP #2")
  expect_true(sum(df$marg_log_lik < 0.0, na.rm = TRUE) > 0)
  expect_true(sum(df$marg_log_lik_sd > 0.0, na.rm = TRUE) > 0)
})
