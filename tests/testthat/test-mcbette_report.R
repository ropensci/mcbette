test_that("use", {
  expect_message(mcbette_report())

  beastier::remove_beaustier_folders()
  beastier::check_empty_beaustier_folders()
})
