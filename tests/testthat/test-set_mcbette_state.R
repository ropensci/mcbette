test_that("use", {
  before <- get_mcbette_state()
  expect_silent(set_mcbette_state(before))
  after <- get_mcbette_state()
  expect_equal(before$beast2_installed, after$beast2_installed)
})
