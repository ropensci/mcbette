#' Create a \code{beast2_options} structure, with the filenames
#' indicating \code{mcbette} usage, as well as the correct
#' BEAST2 binary type
#' @inheritParams default_params_doc
#' @param n_threads the number of computational threads to use.
#' Use \link{NA} to use the BEAST2 default of 1.
#' @param use_beagle use BEAGLE if present
#' @param overwrite if TRUE: overwrite the \code{.log}
#' and \code{.trees} files if one of these exists.
#' If FALSE, BEAST2 will not be started if
#' \itemize{
#'   \item{the \code{.log} file exists}
#'   \item{the \code{.trees} files exist}
#'   \item{the \code{.log} file created by BEAST2 exists}
#'   \item{the \code{.trees} files created by BEAST2 exist}
#' }
#' @seealso use \link[beastier]{create_beast2_options}
#' @export
create_mcbette_beast2_options <- function(
  input_filename = beastier::create_temp_input_filename(),
  output_state_filename = beastier::create_temp_output_state_filename(),
  rng_seed = NA,
  n_threads = NA,
  use_beagle = FALSE,
  overwrite = TRUE,
  beast2_bin_path = beastier::get_default_beast2_bin_path(),
  verbose = FALSE
) {
  beastier::create_beast2_options(
    input_filename = input_filename,
    output_state_filename = output_state_filename,
    rng_seed = rng_seed,
    n_threads = n_threads,
    use_beagle = use_beagle,
    overwrite = overwrite,
    beast2_path = beast2_bin_path,
    verbose = verbose
  )
}
