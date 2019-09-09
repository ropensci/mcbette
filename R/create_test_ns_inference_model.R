# Create an inference model to be tested by Nested Sampling
#' @export
create_test_ns_inference_model <- function() {
  beautier::create_inference_model(
    mcmc = create_test_ns_mcmc()
  )
}
