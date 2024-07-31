#' Can 'mcbette' run?
#'
#' Can 'mcbette' run?
#' Will return \link{TRUE} if:
#' \itemize{
#'   \item (1) Running on Linux or MacOS
#'   \item (2) BEAST2 is installed
#'   \item (3) The BEAST2 NS package is installed
#' }
#' @inheritParams default_params_doc
#' @return \link{TRUE} if 'mcbette' can run.
#' @author Richèl J.C. Bilderbeek
#' @examples
#' can_run_mcbette()
#'
#' beastier::remove_beaustier_folders()
#' beastier::check_empty_beaustier_folders()
#' @export
can_run_mcbette <- function(
  beast2_folder = beastier::get_default_beast2_folder()
) {
  rappdirs::app_dir()$os != "win" &&
  beastier::is_beast2_installed(folder_name = beast2_folder) &&
    mauricer::is_beast2_ns_pkg_installed(beast2_folder = beast2_folder)
}
