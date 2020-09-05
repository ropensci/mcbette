test_that("use", {
  if (!can_run_mcbette()) return()

  marg_liks <- est_marg_liks(
    fasta_filename = system.file(
      "extdata", "simple.fas", package = "mcbette"
    ),
    inference_models = list(beautier::create_test_ns_inference_model()),
    beast2_optionses = list(beastier::create_mcbette_beast2_options()),
  )
  interpret_marg_lik_estimates(marg_liks)
})
