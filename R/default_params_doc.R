#' Documentation of general function arguments.
#' This function does nothing.
#' It is intended to inherit function argument documentation.
#' @param beast2_optionses list of one or more \code{beast2_options}
#'   structures,
#'   as can be created by \link[beastier]{create_beast2_options}.
#'   Use of reduplicated plural to achieve difference with
#'   \code{beast2_options}
#' @param clock_models a list of one or more clock models,
#'   as can be created by \link[beautier]{create_clock_models}
#' @param epsilon measure of relative accuracy.
#'   Smaller values result in longer, more precise estimations
#' @param fasta_filename name of the FASTA file
#' @param inference_models a list of one or more inference models,
#'   as can be created by \link[beautier]{create_inference_model}
#' @param os name of the operating system,
#'   must be \code{unix} (Linux, Mac) or \code{win} (Windows)
#' @param rng_seed a random number generator seed used for the BEAST2
#'   inference
#' @param site_models a list of one or more site models,
#'   as can be created by \link[beautier]{create_site_models}
#' @param tree_priors a list of one or more tree priors,
#'   as can be created by \link[beautier]{create_tree_priors}
#' @param verbose if TRUE show debug output
#' @author Richel J.C. Bilderbeek
#' @note This is an internal function, so it should be marked with
#'   \code{@noRd}. This is not done, as this will disallow all
#'   functions to find the documentation parameters
default_params_doc <- function(
  beast2_optionses,
  clock_models,
  epsilon,
  fasta_filename,
  inference_models,
  os,
  rng_seed,
  site_models,
  tree_priors,
  verbose
) {
  # Nothing
}
