test_that("set present state", {
  expect_error(set_mcbette_state(get_mcbette_state()), "deprecated")
})
