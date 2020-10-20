test_that("use", {
  expect_output(mcbette_report())
})

test_that("use", {
  if (!curl::has_internet()) return()

  beast2_folder <- tempfile()
  beastier::install_beast2(folder_name = beast2_folder)

  expect_output(
    mcbette_report(beast2_folder = beast2_folder)
  )
})
