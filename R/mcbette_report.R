#' Create a \link{mcbette} report, to be used when reporting bugs
#' @export
mcbette_report <- function() {
  print("****************")
  print("* Dependencies *")
  print("****************")
  print(paste0("beautier version: ", packageVersion("beautier")))
  print(paste0("tracerer version: ", packageVersion("tracerer")))
  print(paste0("beastier version: ", packageVersion("beastier")))
  print(paste0("mauricer version: ", packageVersion("mauricer")))
  print(paste0("babette version: ", packageVersion("babette")))
  print("***************")
  print("* BEAST2      *")
  print("***************")
  print(paste0("Is BEAST2 installed: ", beastier::is_beast2_installed()))
  if (beastier::is_beast2_installed())
  {
    print(paste0("BEAST2 version: ", beastier::get_beast2_version()))
  }
  if (beastier::is_beast2_installed())
  {
    print("*******************")
    print("* BEAST2 packages *")
    print("*******************")
    print(
      paste0(
        "Is BEAST2 NS package installed: ",
        mauricer::is_beast2_ns_pkg_installed()
      )
    )
    if (curl::has_internet()) {
      df <- mauricer::get_beast2_pkg_names()
      print(
        paste0(
          "BEAST2 NS installed version: ",
          df[ df$name == "NS",  ]$installed_version
        )
      )
      print(
        paste0(
          "BEAST2 NS latest version: ",
          df[ df$name == "NS",  ]$latest_version
        )
      )
    }
  }
  print("***************")
  print("* sessionInfo *")
  print("***************")
  print(sessionInfo())
}
