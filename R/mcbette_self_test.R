#' Performs a minimal \link{mcbette} run
#' @export
mcbette_self_test <- function() {
  est_marg_lik(
    fasta_filename = system.file("extdata", "simple.fas", package = "mcbette"),
    inference_model = beautier::create_test_ns_inference_model()
  )
  invisible(NULL)
}
