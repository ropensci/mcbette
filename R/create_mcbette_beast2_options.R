#' Create a \code{beast2_options} structure, with the filenames
#' indicating \code{mcbette} usage
#' @inheritParams default_params_doc
#' @seealso use \link[beastier]{create_beast2_options}
#' @export
create_mcbette_beast2_options <- function(rng_seed = NA) {
  beastier::create_beast2_options(
    input_filename = "mcbette.xml",
    output_log_filename = "mcbette.log",
    output_trees_filenames = "mcbette.trees",
    output_state_filename = "mcbette.xml.state",
    rng_seed = rng_seed,
    beast2_path = beastier::get_default_beast2_bin_path()
  )
}
