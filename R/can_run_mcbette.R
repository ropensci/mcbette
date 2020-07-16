#' Can 'mcbette' run?
#'
#' Can 'mcbette' run?
#' Will return \link{TRUE} if:
#' \itemize{
#'   \item (1) Running on Linux or MacOS
#'   \item (2) BEAST2 is installed
#'   \item (3) The BEAST2 NS package is installed
#' }
#' @export
can_run_mcbette <- function() {
  rappdirs::app_dir()$os != "win" &&
  beastier::is_beast2_installed() &&
    mauricer::is_beast2_ns_pkg_installed()
}
