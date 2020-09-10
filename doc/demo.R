## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mcbette)

## -----------------------------------------------------------------------------
if (rappdirs::app_dir()$os == "win") {
  message("'mcbette' can only run on Linux and MacOS")
} else if (!beastier::is_beast2_installed()) {
  message(
    "BEAST2 must be installed. ",
    "Tip: use 'beastier::install_beast2()'"
  )
} else if (!mauricer::is_beast2_ns_pkg_installed()) {
  message(
    "The BEAST2 'NS' package must be installed. ",
    "Tip: use 'mauricer::install_beast2_pkg(\"NS\")'"
  )
}

## -----------------------------------------------------------------------------
fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")

## -----------------------------------------------------------------------------
alignment <- ape::read.FASTA(fasta_filename)
image(alignment)

## -----------------------------------------------------------------------------
inference_model_1 <- beautier::create_ns_inference_model()
inference_model_1$site_model$name

## -----------------------------------------------------------------------------
if (can_run_mcbette()) {
  # Create the two inference models
  inference_model_1 <- beautier::create_ns_inference_model(
    site_model = beautier::create_jc69_site_model()
  )
  inference_model_2 <- beautier::create_ns_inference_model(
    site_model = beautier::create_gtr_site_model()
  )
  # Shorten the run, by doing a short (dirty, unreliable) MCMC
  inference_model_1$mcmc <- beautier::create_test_ns_mcmc()
  inference_model_2$mcmc <- beautier::create_test_ns_mcmc()
  
  
  # Combine the two inference models
  inference_models <- c(list(inference_model_1), list(inference_model_2))

  # Compare the the two inference models
  marg_liks <- est_marg_liks(
    fasta_filename = fasta_filename,
    inference_models = inference_models
  )
  knitr::kable(marg_liks)
}

## -----------------------------------------------------------------------------
if (can_run_mcbette()) {
  interpret_marg_lik_estimates(marg_liks)
}

