#' Checks if the BEAST2 'NS' package is installed.
#'
#' Checks if the BEAST2 'NS' package is installed.
#' Will \link{stop} if not
#' @export
check_beast2_ns_pkg <- function() {
  beastier::check_beast2()
  if (!is_beast2_ns_pkg_installed()) {
    stop(
      "BEAST2 'NS' package not installed. ",
      "Tip: use mauricer::install_beast2_pkg(\"NS\")"
    )
  }
  invisible(NULL)
}
