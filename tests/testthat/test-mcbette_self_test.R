test_that("use", {
  if (!is_on_ci()) return()
  if (!curl::has_internet()) return()

  beast2_folder <- tempfile(pattern = "mcbette_")

  # Create the tree states
  state_neither   <- list(beast2_installed = FALSE, ns_installed = FALSE) # 00
  state_beast2    <- list(beast2_installed = TRUE, ns_installed = FALSE) # 01
  state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)  # 11

  # We'll do the following 6 transitions:
  # 00 -> 11 -> 10 -> 00 -> 10 -> 11 -> 00                                      # nolint these are state transitions
  # First digit: is BEAST2 installed
  # Second digit: is the BEAST2 NS package installed
  expect_silent(check_mcbette_state(state_neither))
  expect_silent(check_mcbette_state(state_beast2))
  expect_silent(check_mcbette_state(state_beast2_ns))

  # 1. 00 -> 11: Check for BEAST2 and BEAST2 NS package installed
  set_mcbette_state(
    mcbette_state = state_beast2_ns,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(beastier::is_beast2_installed(folder_name = beast2_folder))
  expect_true(is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_silent(mcbette_self_test(beast2_folder = beast2_folder))

  # 2. 11 -> 10: Check for BEAST2 installed
  set_mcbette_state(
    mcbette_state = state_beast2,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(!is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_error(
    mcbette_self_test(beast2_folder = beast2_folder),
    "BEAST2 'NS' package not installed"
  )

  # 3. 10 -> 00: Check for nothing installed
  set_mcbette_state(
    mcbette_state = state_neither,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(!is_beast2_installed(folder_name = beast2_folder))
  expect_error(
    mcbette_self_test(beast2_folder = beast2_folder),
    "BEAST2 not installed"
  )

  # 4. 00 -> 10: Check for BEAST2 installed
  set_mcbette_state(
    mcbette_state = state_beast2,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(!is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_error(
    mcbette_self_test(beast2_folder = beast2_folder),
    "BEAST2 'NS' package not installed"
  )

  # 5. 10 -> 11: Check for BEAST2 and BEAST2 NS package installed
  set_mcbette_state(
    mcbette_state = state_beast2_ns,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_silent(mcbette_self_test(beast2_folder = beast2_folder))

  # 6. 11 Check for nothing installed
  set_mcbette_state(
    mcbette_state = state_neither,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(!is_beast2_installed(folder_name = beast2_folder))
  expect_error(
    mcbette_self_test(beast2_folder = beast2_folder),
    "BEAST2 not installed"
  )

  # Clean up
  unlink(beast2_folder, recursive = TRUE)
})
