#' Install the mcbette dependencies, including BEAST2
#'
#' Installs newer code of the \code{mcbette} dependencies
#' that is not on CRAN yet, but still on GitHub only.
#' This function installs the GitHub's master/stable branch
#' of these dependencies.
#'
#' This function also installs BEAST2 if absent and installs the
#' \code{NS} BEAST2 package.
#' @author Richèl J.C. Bilderbeek
#' @export
install_mcbette_deps <- function() {
  remotes::install_github(
    paste0("ropensci/babette"),
    dependencies = TRUE
  )
  babette::install_babette_deps()
}
