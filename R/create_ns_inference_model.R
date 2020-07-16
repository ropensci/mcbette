#' Create an inference model to measure the evidence of.
#'
#' Create an inference model to measure the evidence of.
#' To do so, the inference model is created as usual (see
#' \link[beautier]{create_inference_model}), except
#' for using a Nested Sampling MCMC (see \link[beautier]{create_ns_mcmc})
#' @inheritParams beautier::default_params_doc
#' @examples
#' if (can_run_mcbette()) {
#'
#'   library(testthat)
#'
#'   inference_model <- create_ns_inference_model()
#'   expect_true(beautier::is_nested_sampling_mcmc(inference_model$mcmc))
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
create_ns_inference_model <- function(
  site_model = beautier::create_jc69_site_model(),
  clock_model = beautier::create_strict_clock_model(),
  tree_prior = beautier::create_yule_tree_prior(),
  mcmc = beautier::create_ns_mcmc()
) {
  beautier::check_site_model(site_model)
  beautier::check_clock_model(clock_model)
  beautier::check_tree_prior(tree_prior)
  beautier::check_nested_sampling_mcmc(mcmc)
  beautier::create_inference_model(
    site_model = site_model,
    clock_model = clock_model,
    tree_prior = tree_prior,
    mcmc = mcmc
  )
}
