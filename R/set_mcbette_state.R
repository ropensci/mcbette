#' Set the \link{mcbette} state.
#'
#' Set the \link{mcbette} state to having BEAST2 installed with
#' or without installing the BEAST2 NS package.
#' @note In newer versions of BEAST2, BEAST2 comes pre-installed with the
#' BEAST2 NS package. For such a version, one cannot install BEAST2
#' without NS. A warning will be issues if one intends to only install
#' BEAST2 (i.e. without the BEAST2 NS package) and gets the BEAST2
#' NS package installed as a side effect as well
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
set_mcbette_state <- function(
  mcbette_state,
  beast2_folder = beastier::get_default_beast2_folder(),
  verbose = FALSE
) {
  mcbette::check_mcbette_state(mcbette_state)

  cur_state <- mcbette::get_mcbette_state(beast2_folder = beast2_folder)

  # Uninstall NS if requested
  # Uninstall if ns_installed must be either FALSE or NA
  if (!isTRUE(mcbette_state$ns_installed) &&
    isTRUE(cur_state$ns_installed)
  ) {
    if (isTRUE(verbose)) message("Uninstalling the BEAST2 NS package")
    mauricer::uninstall_beast2_pkg(name = "NS", beast2_folder = beast2_folder)
  }

  # Uninstall BEAST2 if requested
  if (isFALSE(mcbette_state$beast2_installed) &&
    isTRUE(cur_state$beast2_installed)
  ) {
    if (isTRUE(verbose)) message("Uninstalling BEAST2")
    beastier::uninstall_beast2(folder_name = beast2_folder)
  }

  # Install BEAST2 if requested
  if (isTRUE(mcbette_state$beast2_installed) &&
    isFALSE(cur_state$beast2_installed)
  ) {
    if (isTRUE(verbose)) message("Installing BEAST2")
    beastier::install_beast2(folder_name = beast2_folder)
  }

  # Install NS if requested
  if (isTRUE(mcbette_state$ns_installed) &&
    !isTRUE(cur_state$ns_installed)
  ) {
    # BEAST2 comes with the NS package pre-installed for newer version
    if (!mauricer::is_beast2_ns_pkg_installed(beast2_folder = beast2_folder)) {
      if (isTRUE(verbose)) message("Installing the BEAST2 NS package")
      mauricer::install_beast2_pkg("NS", beast2_folder = beast2_folder)
    } else {
      if (isTRUE(verbose)) message("NS came pre-installed with BEAST2")
    }
  }

  # Uninstall NS if requested
  # BEAST2 comes with the NS package pre-installed for newer version
  if (isFALSE(mcbette_state$ns_installed)
  ) {
    # BEAST2 comes with the NS package pre-installed for newer version
    if (mauricer::is_beast2_ns_pkg_installed(beast2_folder = beast2_folder)) {
      if (isTRUE(verbose)) {
        message("Uninstalling pre-installed BEAST2 NS package")
      }
      mauricer::uninstall_beast2_pkg("NS", beast2_folder = beast2_folder)
    }
  }
}
