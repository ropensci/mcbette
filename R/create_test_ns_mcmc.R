#' Create a Nested Sampling MCMC to be used in testing
#' @export
create_test_ns_mcmc <- function() {
  beautier::create_nested_sampling_mcmc(
    chain_length = 1e4,
    epsilon = 1e2
  )
}
