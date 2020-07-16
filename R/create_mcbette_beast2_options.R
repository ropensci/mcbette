#' Create a \code{beast2_options} structure, with the filenames
#' indicating \code{mcbette} usage, as well as the correct
#' BEAST2 binary type
#' @inheritParams beastier::default_params_doc
#' @seealso use \link[beastier]{create_beast2_options}
#' @examples
#' library(testthat)
#'
#' beast2_options <- create_mcbette_beast2_options()
#'
#' # To use mcbette, the binary executable of BEAST2 must be used
#' # (instead of the .jar file)
#' expect_true(beastier::is_bin_path(beast2_options$beast2_path))
#' @author Richèl J.C. Bilderbeek
#' @export
create_mcbette_beast2_options <- function(
  input_filename = beastier::create_temp_input_filename(),
  output_state_filename = beastier::create_temp_state_filename(),
  rng_seed = NA,
  n_threads = NA,
  use_beagle = FALSE,
  overwrite = TRUE,
  beast2_bin_path = beastier::get_default_beast2_bin_path(),
  verbose = FALSE
) {
  testit::assert(beastier::is_bin_path(beast2_bin_path))
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
