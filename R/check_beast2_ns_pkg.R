#' Checks if the BEAST2 'NS' package is installed.
#'
#' Checks if the BEAST2 'NS' package is installed.
#' Will \link{stop} if not
#' @inheritParams default_params_doc
#' @return Nothing. The function will \link{stop} with an error message if
#' the BEAST2 'NS' package is not installed.
#' @export
check_beast2_ns_pkg <- function(
  beast2_bin_path = beastier::get_default_beast2_bin_path()
) {
  beastier::check_beast2(beast2_path = beast2_bin_path)
  beast2_folder <- dirname(dirname(dirname(beast2_bin_path)))
  if (!mauricer::is_beast2_ns_pkg_installed(beast2_folder = beast2_folder)) {
    stop(
      "BEAST2 'NS' package not installed. ",
      "Tip: use mauricerinstall::install_beast2_pkg(\"NS\")"
    )
  }
  invisible(beast2_bin_path)
}
