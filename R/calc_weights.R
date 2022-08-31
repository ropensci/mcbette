#' Calculate the weights for each marginal likelihood
#' @param marg_liks (non-log) marginal likelihood estimates
#' @return the weight of each marginal likelihood estimate,
#' which will sum up to 1.0
#' @examples
#' # Evidences (aka marginal likelihoods) can be very small
#' evidences <- c(0.0001, 0.0002, 0.0003, 0.0004)
#'
#' # Sum will be 1.0
#' calc_weights(evidences)
#'
#' beastier::remove_beaustier_folders()
#' beastier::check_empty_beaustier_folders()
#' @author Richèl J.C. Bilderbeek
#' @export
calc_weights <- function(
  marg_liks
) {
  # The marginal likelihoods can be very small and are therefore
  # represented as Rmpfr numbers
  zero <- 0.0
  if (inherits(marg_liks, "mpfr")) {
    zero <- Rmpfr::mpfr(0.0, 512)
  }

  marg_liks[is.na(marg_liks)] <- zero
  weights <- rep(zero, length(marg_liks))
  if (sum(marg_liks) != zero) {
    weights <- marg_liks / sum(marg_liks)
  }
  weights
}
