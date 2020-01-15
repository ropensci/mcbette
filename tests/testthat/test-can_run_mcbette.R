test_that("correct", {
  expect_equal(
    rappdirs::app_dir()$os != "win" &&
      beastier::is_beast2_installed() &&
      mauricer::is_beast2_ns_pkg_installed(),
    can_run_mcbette()
  )
})
