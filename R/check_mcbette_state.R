#' Check if the \code{mcbette_state} is valid.
#'
#' Will \link{stop} otherwise.
#' @inheritParams default_params_doc
#' @export
check_mcbette_state <- function(mcbette_state) {
  if (!is.list(mcbette_state)) {
    stop("'mcbette_state' must be a list")
  }
  if (!"beast2_installed" %in% names(mcbette_state)) {
    stop("'beast2_installed' must be an element of 'mcbette_state'")
  }
  if (!"ns_installed" %in% names(mcbette_state)) {
    stop("'ns_installed' must be an element of 'mcbette_state'")
  }
  if (!beautier::is_one_bool(mcbette_state$beast2_installed)) {
    stop("'beast2_installed' must be one boolean")
  }
  if (!beautier::is_one_na(mcbette_state$ns_installed) &&
    !beautier::is_one_bool(mcbette_state$ns_installed)) {
    stop("'ns_installed' must be one NA or one boolean")
  }
}
