#' Get the current state of \link{mcbette}
#' @return a \link{list} with the following elements:
#' \itemize{
#'   \item{
#'     beast2_installed
#'       \link{TRUE} if BEAST2 is installed,
#'       \link{FALSE} otherwise
#'   }
#'   \item{
#'      ns_installed
#'       \link{NA} if BEAST2 is not installed.
#'       \link{TRUE} if the BEAST2 NS package is installed
#'       \link{FALSE} if the BEAST2 NS package is not installed
#'   }
#' }
#' @examples
#' library(testthat)
#'
#' state <- get_mcbette_state()
#' expect_true("beast2_installed" %in% names(state))
#' expect_true("ns_installed" %in% names(state))
#' @export
get_mcbette_state <- function() {
  state <- list(
    beast2_installed = NA,
    ns_installed = NA
  )
  if (beastier::is_beast2_installed()) {
    state$beast2_installed <- TRUE
    state$ns_installed <- mauricer::is_beast2_ns_pkg_installed()
  } else {
    state$beast2_installed <- FALSE
  }
  testthat::expect_silent(check_mcbette_state(state))
  state
}
