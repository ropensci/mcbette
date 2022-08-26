#' Set the \link{mcbette} state.
#'
#' Set the \link{mcbette} state to having BEAST2 installed with
#' or without installing the BEAST2 NS package.
#'
#' @note In newer versions of BEAST2, BEAST2 comes pre-installed with the
#' BEAST2 NS package. For such a version, one cannot install BEAST2
#' without NS. A warning will be issues if one intends to only install
#' BEAST2 (i.e. without the BEAST2 NS package) and gets the BEAST2
#' NS package installed as a side effect as well.
#'
#' Also, installing or uninstalling a BEAST2 package from a BEAST2
#' installation will affect all installations.
#' @inheritParams default_params_doc
#' @seealso
#' \itemize{
#'   \item Use \link{get_mcbette_state} to
#'     get the current \link{mcbette} state
#'   \item Use \link{check_mcbette_state} to
#'     check the current \link{mcbette} state
#' }
#' @export
set_mcbette_state <- function(
  mcbette_state,
  beast2_folder = beastier::get_default_beast2_folder(),
  verbose = FALSE
) {
  stop(
    "This function is deprecated, as it violated CRAN policies.\n",
    "\n",
    "Tip: use 'mcbetteinstall::set_mcbette_state' instead:\n",
    "\n",
    "  remotes::install_github(\"richelbilderbeek/mcbetteinstall\")\n",
    "  mcbetteinstall::set_mcbette_state(...)\n"
  )

}
