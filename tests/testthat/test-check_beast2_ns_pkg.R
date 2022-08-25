# STATE IS CHANGED HERE

test_that("use", {
  if (!is_on_ci()) return()

  beast2_folder <- tempfile(pattern = "mcbette_")

  # Create the tree states
  state_neither   <- list(beast2_installed = FALSE, ns_installed = FALSE)
  state_beast2    <- list(beast2_installed = TRUE, ns_installed = FALSE)
  state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
  expect_silent(check_mcbette_state(state_neither))
  expect_silent(check_mcbette_state(state_beast2))
  expect_silent(check_mcbette_state(state_beast2_ns))

  # 1. Check for BEAST2 and BEAST2 NS package installed
  set_mcbette_state(
    mcbette_state = state_beast2_ns,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_silent(
    check_beast2_ns_pkg(
      beast2_bin_path = beastier::get_default_beast2_bin_path(
        beast2_folder = beast2_folder
      )
    )
  )

  # 2. Check for BEAST2 installed
  # Note that this function changes the global state as well!
  set_mcbette_state(
    mcbette_state = state_beast2,
    beast2_folder = beast2_folder,
    verbose = TRUE
  )
  # The global state is changed and will not have NS installed as well

  expect_true(is_beast2_installed(folder_name = beast2_folder))
  expect_true(!is_beast2_ns_pkg_installed(beast2_folder = beast2_folder))
  expect_error(
    check_beast2_ns_pkg(
      beast2_bin_path = beastier::get_default_beast2_bin_path(
        beast2_folder = beast2_folder
      )
    ),
    "BEAST2 'NS' package not installed"
  )
  unlink(beast2_folder, recursive = TRUE)
})
