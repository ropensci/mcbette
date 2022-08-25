test_that("use", {
  expect_message(mcbette_report())
})

test_that("give output when nothing is installed", {
  if (!beautier::is_on_ci()) return()

  beast2_folder <- tempfile(pattern = "mcbette_mcbette_report_")
  set_mcbette_state(
    mcbette_state = list(beast2_installed = FALSE, ns_installed = FALSE),
    beast2_folder = beast2_folder
  )

  expect_message(
    mcbette_report(beast2_folder = beast2_folder)
  )

  unlink(beast2_folder, recursive = TRUE)
})

test_that("give output when only BEAST2 is installed", {
  if (!beautier::is_on_ci()) return()

  beast2_folder <- tempfile(pattern = "mcbette_mcbette_report_")
  set_mcbette_state(
    mcbette_state = list(beast2_installed = TRUE, ns_installed = FALSE),
    beast2_folder = beast2_folder
  )

  expect_message(
    mcbette_report(beast2_folder = beast2_folder)
  )

  unlink(beast2_folder, recursive = TRUE)
})

test_that("give output when BEAST2 and NS are installed", {
  if (!beautier::is_on_ci()) return()

  beast2_folder <- tempfile(pattern = "mcbette_mcbette_report_")
  set_mcbette_state(
    mcbette_state = list(beast2_installed = TRUE, ns_installed = TRUE),
    beast2_folder = beast2_folder
  )

  expect_message(
    mcbette_report(beast2_folder = beast2_folder)
  )

  unlink(beast2_folder, recursive = TRUE)
})
