#' Calculate the weights for each marginal likelihood
#' @param marg_liks (non-log) marginal likelihood estimates
#' @return the weight of each marginal likelihood estimate
#' @author Richel J.C. Bilderbeek
#' @export
calc_weights <- function(
  marg_liks
) {
  # The marginal likelihoods can be very small and are therefore
  # represented as Rmpfr numbers
  zero <- 0.0
  if (class(marg_liks) == "mpfr") {
    zero <-Rmpfr::mpfr(0.0, 256)
  }

  marg_liks[is.na(marg_liks)] <- zero
  weights <- rep(zero, length(marg_liks))
  if (sum(marg_liks) != zero) {
    weights <- marg_liks / sum(marg_liks)
  }
  weights
}
