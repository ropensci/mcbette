# test_that("correct", {
#   expect_equal(
#     rappdirs::app_dir()$os != "win" &&
#       beastier::is_beast2_installed() &&
#       mauricer::is_beast2_ns_pkg_installed(),
#     can_run_mcbette()
#   )
# })
#
# test_that("from custom location", {
#   if (!is_on_travis()) return()
#
#   beast2_folder <- tempfile(pattern = "mcbette_")
#   expect_false(can_run_mcbette(beast2_folder = beast2_folder))
#
#   state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
#   set_mcbette_state(
#     mcbette_state = state_beast2_ns,
#     beast2_folder = beast2_folder
#   )
#
#   expect_true(can_run_mcbette(beast2_folder = beast2_folder))
# })
