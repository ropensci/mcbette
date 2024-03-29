#' Get the current state of \link{mcbette}
#' @inheritParams default_params_doc
#' @return a \link{list} with the following elements:
#' \itemize{
#'   \item{
#'     beast2_installed
#'       \link{TRUE} if BEAST2 is installed,
#'       \link{FALSE} otherwise
#'   }
#'   \item{
#'      ns_installed
#'       \link{TRUE} if the BEAST2 NS package is installed
#'       \link{FALSE} if the BEAST2 or the BEAST2 NS package is not installed
#'   }
#' }
#' @examples
#' get_mcbette_state()
#'
#' beastier::remove_beaustier_folders()
#' beastier::check_empty_beaustier_folders()
#' @export
get_mcbette_state <- function(
  beast2_folder = beastier::get_default_beast2_folder()
) {
  state <- list(
    beast2_installed = NA,
    ns_installed = NA
  )
  if (beastier::is_beast2_installed(folder_name = beast2_folder)) {
    state$beast2_installed <- TRUE
    state$ns_installed <- mauricer::is_beast2_ns_pkg_installed(
      beast2_folder = beast2_folder
    )
  } else {
    state$beast2_installed <- FALSE
    state$ns_installed <- FALSE
  }
  state
}
