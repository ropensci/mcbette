#' Create a \link{mcbette} report,
#' to be used when reporting bugs
#' @return nothing. It is intended that the output (not
#' the return value) is copy-pasted from screen.
#' @examples
#' mcbette_report()
#' @author Richèl J.C. Bilderbeek
#' @export
mcbette_report <- function(
  beast2_folder = beastier::get_default_beast2_folder()
) {
  kat <- function(x) cat(x, sep = "\n")
  kat("***********")
  kat("* mcbette *")
  kat("***********")
  kat(paste0("Can run mcbette: ", mcbette::can_run_mcbette()))
  kat(paste0("OS: ", rappdirs::app_dir()$os))
  kat("****************")
  kat("* Dependencies *")
  kat("****************")
  kat(paste0("beautier version: ", utils::packageVersion("beautier")))
  kat(paste0("tracerer version: ", utils::packageVersion("tracerer")))
  kat(paste0("beastier version: ", utils::packageVersion("beastier")))
  kat(paste0("mauricer version: ", utils::packageVersion("mauricer")))
  kat(paste0("babette version: ", utils::packageVersion("babette")))
  kat("**********")
  kat("* BEAST2 *")
  kat("**********")
  kat(paste0("Java version: ", beastier::get_java_version()))
  kat(
    paste0(
      "Is BEAST2 installed: ",
      beastier::is_beast2_installed(folder_name = beast2_folder)
    )
  )
  if (beastier::is_beast2_installed(folder_name = beast2_folder)) {
    kat(
      paste0(
        "BEAST2 version: ",
        beastier::get_beast2_version(beast2_path = beast2_folder)
      )
    )
    kat(
      paste0(
        "BEAST2 default path: ",
        beastier::get_default_beast2_bin_path(beast2_folder = beast2_folder)
      )
    )
  }
  if (beastier::is_beast2_installed(folder_name = beast2_folder)) {
    kat("*******************")
    kat("* BEAST2 packages *")
    kat("*******************")
    kat(
      paste0(
        "Is BEAST2 NS package installed: ",
        mauricer::is_beast2_ns_pkg_installed(beast2_path = beast2_folder)
      )
    )
    if (curl::has_internet()) {
      df <- mauricer::get_beast2_pkg_names(folder_name = beast2_folder)
      kat(
        paste0(
          "BEAST2 NS installed version: ",
          df[df$name == "NS", ]$installed_version
        )
      )
      kat(
        paste0(
          "BEAST2 NS latest version: ",
          df[df$name == "NS", ]$latest_version
        )
      )
    }
  }
  kat("***************")
  kat("* sessionInfo *")
  kat("***************")
  print(utils::sessionInfo())
  invisible(NULL)
}
