#' Documentation of general function arguments.
#' This function does nothing.
#' It is intended to inherit function argument documentation.
#' @param beast2_bin_path path to the the BEAST2 binary file
#' @param beast2_working_dir folder in which BEAST2 will run and
#'   produce intermediate files.
#'   By default, this is a temporary folder
#' @param beast2_options a \code{beast2_options} structure,
#'   as can be created by \link[beastier]{create_mcbette_beast2_options}.
#' @param beast2_optionses list of one or more \code{beast2_options}
#'   structures,
#'   as can be created by \link[beastier]{create_mcbette_beast2_options}.
#'   Use of reduplicated plural to achieve difference with
#'   \code{beast2_options}
#' @param clock_model a clock model,
#'   as can be created by \link[beautier]{create_clock_model}
#' @param clock_models a list of one or more clock models,
#'   as can be created by \link[beautier]{create_clock_models}
#' @param epsilon measure of relative accuracy.
#'   Smaller values result in longer, more precise estimations
#' @param fasta_filename name of the FASTA file
#' @param inference_model an inference model,
#'   as can be created by \link[beautier]{create_inference_model}
#' @param inference_models a list of one or more inference models,
#'   as can be created by \link[beautier]{create_inference_model}
#' @param mcbette_state the \link{mcbette} state,
#' which is a \link{list} with the following elements:
#' \itemize{
#'   \item{
#'     beast2_installed
#'       \link{TRUE} if BEAST2 is installed,
#'       \link{FALSE} otherwise
#'   }
#'   \item{
#'      ns_installed
#'       \link{NA} if BEAST2 is not installed.
#'       \link{TRUE} if the BEAST2 NS package is installed
#'       \link{FALSE} if the BEAST2 NS package is not installed
#'   }
#' }
#' @param mcmc an MCMC for the Nested Sampling run,
#'   as can be created by \link[beautier]{create_mcmc_nested_sampling}
#' @param os name of the operating system,
#'   must be \code{unix} (Linux, Mac) or \code{win} (Windows)
#' @param rng_seed a random number generator seed used for the BEAST2
#'   inference
#' @param site_model a site model,
#'   as can be created by \link[beautier]{create_site_model}
#' @param site_models a list of one or more site models,
#'   as can be created by \link[beautier]{create_site_models}
#' @param tree_prior a tree prior,
#'   as can be created by \link[beautier]{create_tree_prior}
#' @param tree_priors a list of one or more tree priors,
#'   as can be created by \link[beautier]{create_tree_priors}
#' @param verbose if TRUE show debug output
#' @author Richèl J.C. Bilderbeek
#' @note This is an internal function, so it should be marked with
#'   \code{@noRd}. This is not done, as this will disallow all
#'   functions to find the documentation parameters
default_params_doc <- function(
  beast2_bin_path,
  beast2_working_dir,
  beast2_options,
  beast2_optionses,
  clock_model, clock_models,
  epsilon,
  fasta_filename,
  inference_model,
  inference_models,
  mcbette_state,
  mcmc,
  os,
  rng_seed,
  site_model, site_models,
  tree_prior, tree_priors,
  verbose
) {
  # Nothing
}
