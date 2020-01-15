#' mcbette: Model Comparison Using Babette
#'
#' 'mcbette' does a model comparing using \link[babette]{babette}.
#'
#' @seealso Use \link{can_run_mcbette} to see if 'mcbette' can run.
#' @examples
#' if (can_run_mcbette()) {
#'   library(testthat)
#'
#'   # An example FASTA file
#'   fasta_filename <- system.file("extdata", "simple.fas", package = "mcbette")
#'
#'   inference_model_1 <- create_test_ns_inference_model(
#'     site_model = beautier::create_jc69_site_model()
#'   )
#'   inference_model_2 <- create_test_ns_inference_model(
#'     site_model = beautier::create_gtr_site_model()
#'   )
#'   inference_models <- c(list(inference_model_1), list(inference_model_2))
#'
#'   df <- mcbette::est_marg_liks(
#'     fasta_filename = fasta_filename,
#'     inference_models = inference_models
#'   )
#'
#'   marg_lik_jc <- exp(Rmpfr::mpfr(df$marg_log_lik[1], 512))
#'   marg_lik_gtr <- exp(Rmpfr::mpfr(df$marg_log_lik[2], 512))
#'   bayes_factor <- marg_lik_jc / marg_lik_gtr
#'   interpretation <- interpret_bayes_factor(as.numeric(bayes_factor))
#'   cat(
#'     paste(
#'       "Interpretation from JC69 model's point of view: ", interpretation
#'     )
#'   )
#' }
#' @docType package
#' @name mcbette
#' @import beautier tracerer beastier mauricer babette
NULL
