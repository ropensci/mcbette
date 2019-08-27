.onLoad <- function(libname, pkgname) { # nolint .onLoad cannot be snake_case

  suppressPackageStartupMessages(
    lapply(
      c("babette", "beautier", "beastier", "mauricer", "tracerer"),
      library,
      character.only = TRUE,
      warn.conflicts = FALSE
    )
  )
  invisible()
}
