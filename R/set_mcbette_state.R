#' Set the \link{mcbette} state.
#' @inheritParams default_params_doc
#' @seealso
#' \itemize{
#'   \item Use \link{get_mcbette_state} to
#'     get the current \link{mcbette} state
#'   \item Use \link{check_mcbette_state} to
#'     check the current \link{mcbette} state
#' }
#' @examples
#' mcbette_state <- get_mcbette_state()
#' mcbette_state$beast2_installed <- TRUE
#' mcbette_state$ns_installed <- TRUE
#' \dontrun{
#'   set_mcbette_state(mcbette_state)
#' }
#' @export
set_mcbette_state <- function(mcbette_state) {
  mcbette::check_mcbette_state(mcbette_state)

  cur_state <- mcbette::get_mcbette_state()

  # Uninstall NS if requested
  # Uninstall if ns_installed must be either FALSE or NA
  if (!isTRUE(mcbette_state$ns_installed) &&
    isTRUE(cur_state$ns_installed)
  ) {
    mauricer::uninstall_beast2_pkg("NS")
  }

  # Uninstall BEAST2 if requested
  if (isFALSE(mcbette_state$beast2_installed) &&
    isTRUE(cur_state$beast2_installed)
  ) {
    beastier::uninstall_beast2()
  }

  # Install BEAST2 if requested
  if (isTRUE(mcbette_state$beast2_installed) &&
    isFALSE(cur_state$beast2_installed)
  ) {
    beastier::install_beast2()
  }

  # Install NS if requested
  if (isTRUE(mcbette_state$ns_installed) &&
    !isTRUE(cur_state$ns_installed)
  ) {
    mauricer::install_beast2_pkg("NS")
  }
}
