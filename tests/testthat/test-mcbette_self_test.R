test_that("use", {
  if (!is_on_travis()) return()
  if (!curl::has_internet()) return()

  beast2_folder <- tempfile()

  # Create the tree states
  state_neither   <- list(beast2_installed = FALSE, ns_installed = NA)
  state_beast2    <- list(beast2_installed = TRUE, ns_installed = FALSE)
  state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
  expect_silent(check_mcbette_state(state_neither))
  expect_silent(check_mcbette_state(state_beast2))
  expect_silent(check_mcbette_state(state_beast2_ns))

  # 1. Check for BEAST2 and BEAST2 NS package installed
  set_mcbette_state(state_beast2_ns, beast2_folder = beast2_folder)
  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_silent(mcbette_self_test(beast2_folder = beast2_folder))

  # 2. Check for BEAST2 installed
  set_mcbette_state(state_beast2)
  expect_true(is_beast2_installed())
  expect_true(!is_beast2_ns_pkg_installed())
  expect_error(
    mcbette_self_test(),
    "BEAST2 'NS' package not installed"
  )

  # 3. Check for nothing installed
  set_mcbette_state(state_neither)
  expect_true(!is_beast2_installed())
  expect_error(
    mcbette_self_test(),
    "BEAST2 not installed. Tip: use beastier::install_beast2()"
  )
})
