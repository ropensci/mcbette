#' Get testing \code{marg_liks}
#' @examples
#' get_test_marg_liks()
#'
#' beastier::check_empty_beaustier_folders()
#' @export
get_test_marg_liks <- function() {
  #   site_model_name   clock_model_name tree_prior_name marg_log_lik marg_log_lik_sd     weight      ess # nolint this is an example
  # 1            JC69             strict            yule    -6482.469       0.4620925 0.06560807 2677.995 # nolint this is an example
  # 2            JC69 relaxed_log_normal            yule    -6479.813       0.3761695 0.93439193 3397.03  # nolint this is an example
  data.frame(
    site_model_name = c("JC69", "JC69"),
    clock_model_name = c("strict", "relaxed_log_normal"),
    tree_prior_name = c("yule", "yule"),
    marg_log_lik = c(-6482.469, -6479.813),
    marg_log_lik_sd = c(0.4620925, 0.3761695),
    weight = c(0.06560807, 0.93439193),
    ess = c(2677.995, 3397.03)
  )
}
