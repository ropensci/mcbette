#' Calculate the weights for each marginal likelihood
#' @param marg_liks (non-log) marginal likelihood estimates
#' @return the weight of each marginal likelihood estimate
#' @examples
#'   marg_liks <- c(0.0001, 0.0002, 0.0003, 0.0004)
#'   created <- calc_weights(marg_liks)
#'   expected <- c(0.1, 0.2, 0.3, 0.4)
#'   testthat::expect_equal(created, expected)
#' @author Richèl J.C. Bilderbeek
#' @export
calc_weights <- function(
  marg_liks
) {
  # The marginal likelihoods can be very small and are therefore
  # represented as Rmpfr numbers
  zero <- 0.0
  if (class(marg_liks) == "mpfr") {
    zero <- Rmpfr::mpfr(0.0, 512)
  }

  marg_liks[is.na(marg_liks)] <- zero
  weights <- rep(zero, length(marg_liks))
  if (sum(marg_liks) != zero) {
    weights <- marg_liks / sum(marg_liks)
  }
  weights
}
