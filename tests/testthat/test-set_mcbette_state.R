test_that("set present state", {
  before <- get_mcbette_state()
  expect_silent(set_mcbette_state(before))
  after <- get_mcbette_state()
  expect_identical(before$beast2_installed, after$beast2_installed)
  expect_identical(before$ns_installed, after$ns_installed)
})

test_that("uninstall all", {

  if (!beastier::is_on_travis()) return()

  before <- get_mcbette_state()

  state_neither <- list(beast2_installed = FALSE, ns_installed = FALSE)
  expect_silent(set_mcbette_state(state_neither))

  expect_silent(set_mcbette_state(before))
  after <- get_mcbette_state()
  expect_identical(before$beast2_installed, after$beast2_installed)
  expect_identical(before$ns_installed, after$ns_installed)
})

test_that("uninstall all", {

  if (!beastier::is_on_travis()) return()

  before <- get_mcbette_state()

  state_beast2 <- list(beast2_installed = TRUE, ns_installed = FALSE)
  expect_silent(set_mcbette_state(state_beast2))

  expect_silent(set_mcbette_state(before))
  after <- get_mcbette_state()
  expect_identical(before$beast2_installed, after$beast2_installed)
  expect_identical(before$ns_installed, after$ns_installed)
})


test_that("uninstall all", {

  if (!beastier::is_on_travis()) return()

  before <- get_mcbette_state()

  state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
  expect_silent(set_mcbette_state(state_beast2_ns))

  expect_silent(set_mcbette_state(before))
  after <- get_mcbette_state()
  expect_identical(before$beast2_installed, after$beast2_installed)
  expect_identical(before$ns_installed, after$ns_installed)
})
