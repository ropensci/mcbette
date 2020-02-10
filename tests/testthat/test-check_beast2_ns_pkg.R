test_that("use", {

  if (is_on_travis()) {
    # Store the current state
    was_beast2_installed <- is_beast2_installed()
    was_beast2_ns_installed <- FALSE
    if (was_beast2_installed) {
      was_beast2_ns_pkg_installed <- is_beast2_ns_pkg_installed()
    }

    # 1. Check for BEAST2 and BEAST2 NS package installed
    if (!is_beast2_installed()) install_beast2()
    if (!is_beast2_ns_pkg_installed()) install_beast2_pkg("NS")
    expect_true(is_beast2_installed())
    expect_true(is_beast2_ns_pkg_installed())
    expect_silent(check_beast2_ns_pkg())

    # 2. Check for BEAST2 installed
    uninstall_beast2_pkg("NS")
    expect_true(is_beast2_installed())
    expect_true(!is_beast2_ns_pkg_installed())
    expect_error(
      check_beast2_ns_pkg(),
      "BEAST2 'NS' package not installed"
    )

    # Restore current state
    if (was_beast2_ns_pkg_installed) {
      install_beast2_pkg("NS")
    }
    if (was_beast2_installed) {
      install_beast2()
    }
  }
})
