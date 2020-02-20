test_that("use", {

  if (is_on_travis()) {
    # Store the current state
    before <- get_mcbette_state()

    # Create the tree states
    state_neither   <- list(beast2_installed = FALSE, ns_installed = NA)
    state_beast2    <- list(beast2_installed = TRUE, ns_installed = FALSE)
    state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
    expect_silent(check_mcbette_state(state_neither))
    expect_silent(check_mcbette_state(state_beast2))
    expect_silent(check_mcbette_state(state_beast2_ns))

    # 1. Check for BEAST2 and BEAST2 NS package installed
    set_mcbette_state(state_beast2_ns)
    expect_true(is_beast2_installed())
    expect_true(is_beast2_ns_pkg_installed())
    expect_silent(mcbette_self_test())

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

    # Restore current state
    set_mcbette_state(before)

    # Check if everything is the same again
    expect_identical(before, get_mcbette_state())
  }
})
