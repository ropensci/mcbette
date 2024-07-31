#' Check if the \code{mcbette_state} is valid.
#'
#' Check if the \code{mcbette_state} is valid.
#' Will \link{stop} otherwise.
#' @inheritParams default_params_doc
#' @return Nothing. Will \link{stop} if the input is invalid.
#' @author Richèl J.C. Bilderbeek
#' @export
check_mcbette_state <- function(mcbette_state) {
  if (!is.list(mcbette_state)) {
    stop("'mcbette_state' must be a list")
  }
  # List elements
  if (!"beast2_installed" %in% names(mcbette_state)) {
    stop("'beast2_installed' must be an element of 'mcbette_state'")
  }
  if (!"ns_installed" %in% names(mcbette_state)) {
    stop("'ns_installed' must be an element of 'mcbette_state'")
  }
  # Data types
  if (!beautier::is_one_bool(mcbette_state$beast2_installed)) {
    stop("'beast2_installed' must be one boolean")
  }
  if (!beautier::is_one_bool(mcbette_state$ns_installed)) {
    stop("'ns_installed' must be one boolean")
  }
  # States that make sense
  if (!mcbette_state$beast2_installed && mcbette_state$ns_installed) {
    stop("If 'beast2_installed' is FALSE, 'ns_installed' must be FALSE")
  }
  invisible(mcbette_state)
}
