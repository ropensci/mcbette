context("test-est_marg_liks")

test_that("use", {
  fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
  df <- est_marg_liks(fasta_filename)
  expect_true(is.data.frame(df))
  expect_true(is.factor(df$site_model_name))
  expect_true(is.factor(df$clock_model_name))
  expect_true(is.factor(df$tree_prior_name))

})
