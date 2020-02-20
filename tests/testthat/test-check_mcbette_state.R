test_that("use", {
  expect_silent(check_mcbette_state(get_mcbette_state()))
})

test_that("abuse", {
  expect_error(
    check_mcbette_state("nonsense"),
    "'mcbette_state' must be a list"
  )
  expect_error(
    check_mcbette_state(NA),
    "'mcbette_state' must be a list"
  )
  expect_error(
    check_mcbette_state(NULL),
    "'mcbette_state' must be a list"
  )

  valid_state <- get_mcbette_state()
  expect_silent(check_mcbette_state(valid_state))

  state <- valid_state
  state$beast2_installed <- "nonsense"
  expect_error(check_mcbette_state(state))

  state <- valid_state
  state$ns_installed <- "nonsense"
  expect_error(check_mcbette_state(state))

  state <- valid_state
  state$beast2_installed <- NULL
  expect_error(check_mcbette_state(state))

  state <- valid_state
  state$ns_installed <- NULL
  expect_error(check_mcbette_state(state))
})
