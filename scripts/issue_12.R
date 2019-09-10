# R script to test if pirouette runs on peregrine

# Added an extra check
remotes::install_github("ropensci/beastier", ref = "develop")

# Copied from peregrine
get_pff_tempdir <- function() {
  dirname <- file.path(
    rappdirs::user_cache_dir(),
    basename(tempfile())
  )
  dirname
}

# Copied from peregrine
get_pff_tempfile <- function(
  pattern = "pff_",
  pff_tmpdir = get_pff_tempdir(),
  fileext = ""
) {
  filename <- tempfile(
    pattern = pattern,
    tmpdir = pff_tmpdir,
    fileext = fileext
  )
  testit::assert(!file.exists(filename))
  filename
}


fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")

# Inaccurate MCMC
mcmc <- beautier::create_nested_sampling_mcmc(epsilon = 1e2)

inference_model_1 <- beautier::create_inference_model(
  site_model = beautier::create_jc69_site_model(),
  clock_model = beautier::create_strict_clock_model(),
  tree_prior = beautier::create_yule_tree_prior(),
  mcmc = mcmc
)
inference_model_2 <- beautier::create_inference_model(
  site_model = beautier::create_jc69_site_model(),
  clock_model = beautier::create_strict_clock_model(),
  tree_prior = beautier::create_bd_tree_prior(),
  mcmc = mcmc
)

inference_models <- list(
  inference_model_1,
  inference_model_2
)



beast2_options <- beastier::create_beast2_options(
  input_filename = get_pff_tempfile(pattern = "in_", fileext = ".xml"),
  output_log_filename = get_pff_tempfile(pattern = "out_", fileext = ".log"),
  output_trees_filenames = get_pff_tempfile(pattern = "out_", fileext = ".trees"),
  output_state_filename = get_pff_tempfile(pattern = "out_", fileext = ".state.xml"),
  beast2_working_dir = get_pff_tempfile(),
  beast2_path = beastier::get_default_beast2_bin_path()
)
beast2_optionses <- list(
  beast2_options,
  beast2_options
)

mcbette::est_marg_liks(
  fasta_filename,
  inference_models = inference_models,
  beast2_optionses = beast2_optionses,
  verbose = TRUE
)

