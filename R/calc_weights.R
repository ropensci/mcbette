#' Calculate the weights for each marginal likelihood
#' @param marg_liks (non-log) marginal likelihood estimates
#' @return the weight of each marginal likelihood estimate
#' @author Richel J.C. Bilderbeek
#' @export
calc_weights <- function(
  marg_liks
) {
  marg_liks[ is.na(marg_liks) ] <- 0.0
  marg_liks / sum(marg_liks)
}
