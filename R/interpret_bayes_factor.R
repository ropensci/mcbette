#' Interpret a Bayes factor
#'
#' Interpret a Bayes factor, using the interpretation from [1].
#'
#' \itemize{
#'   \item [1] H. Jeffreys (1961). The Theory of Probability (3rd ed.).
#'     Oxford. p. 432
#' }
#' @param bayes_factor Bayes factor to be interpreted
#' @return a string with the interpretation in English
#' @examples
#' interpret_bayes_factor(0.5)
#'
#' beastier::remove_beaustier_folders()
#' beastier::check_empty_beaustier_folders()
#' @author Richèl J.C. Bilderbeek
#' @export
interpret_bayes_factor <- function(bayes_factor) {

  if (!beautier::is_one_double(bayes_factor)) {
    stop(
      "'bayes_factor' must be one numeric value. \n",
      "Actual value: ", bayes_factor
    )
  }

  if (bayes_factor < 10^0.0) {
    "in favor of other model"
  } else if (bayes_factor < 10^0.5) {
    "barely worth mentioning"
  } else if (bayes_factor < 10^1.0) {
    "substantial"
  } else if (bayes_factor < 10^1.5) {
    "strong"
  } else if (bayes_factor < 10^2.0) {
    "very strong"
  } else {
    "decisive"
  }
}
