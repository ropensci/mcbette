#' Determine if the \code{marg_liks} is valid
#' @inheritParams default_params_doc
#' @return TRUE if the argument is a valid \code{marg_liks},
#'   FALSE otherwise
is_marg_liks <- function(marg_liks, verbose = FALSE) {
 is <- FALSE
  tryCatch({
      mcbette::check_marg_liks(marg_liks)
      is <- TRUE
    },
    error = function(e) {
      if (verbose) message(e)
    }
  )
  is
}
