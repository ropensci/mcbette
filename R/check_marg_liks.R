#' Check if the \code{marg_liks} are of the same type as returned
#' by \link{est_marg_liks}.
#'
#' \link{stop} if not.
#' @inheritParams default_params_doc
#' @return Nothing. Will \link{stop} with an error message if there
#' is a problem with the input.
#' @export
check_marg_liks <- function(marg_liks) {
  if (!is.data.frame(marg_liks)) {
    stop("'marg_liks' must be a data frame")
  }
  testthat::expect_true("site_model_name" %in% names(marg_liks))
  testthat::expect_true("clock_model_name" %in% names(marg_liks))
  testthat::expect_true("tree_prior_name" %in% names(marg_liks))
  testthat::expect_true("marg_log_lik" %in% names(marg_liks))
  testthat::expect_true("marg_log_lik_sd" %in% names(marg_liks))
  testthat::expect_true("weight" %in% names(marg_liks))
  testthat::expect_true("ess" %in% names(marg_liks))
  testthat::expect_true(
    all(marg_liks$site_model_name %in% beautier::get_site_model_names())
  )
  testthat::expect_true(
    all(marg_liks$clock_model_name %in% beautier::get_clock_model_names())
  )
  testthat::expect_true(
    all(marg_liks$tree_prior_name %in% beautier::get_tree_prior_names())
  )
  testthat::expect_true(
    all(is.numeric(marg_liks$marg_log_lik))
  )
  testthat::expect_true(
    all(is.numeric(marg_liks$marg_log_lik_sd))
  )
  testthat::expect_true(
    all(is.numeric(marg_liks$weight))
  )
  testthat::expect_true(
    all(is.numeric(marg_liks$ess))
  )
  invisible(marg_liks)
}
