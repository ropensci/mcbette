test_that("use", {

  if (is_on_travis()) {
    # Store the current state
    was_beast2_installed <- is_beast2_installed()
    was_beast2_ns_pkg_installed <- FALSE
    if (was_beast2_installed) {
      was_beast2_ns_pkg_installed <- is_beast2_ns_pkg_installed()
    }

    # 1. Check for BEAST2 and BEAST2 NS package installed
    if (!is_beast2_installed()) install_beast2()
    if (!is_beast2_ns_pkg_installed()) install_beast2_pkg("NS")
    expect_true(is_beast2_installed())
    expect_true(is_beast2_ns_pkg_installed())
    expect_silent(mcbette_self_test())

    # 2. Check for BEAST2 installed
    uninstall_beast2_pkg("NS")
    expect_true(is_beast2_installed())
    expect_true(!is_beast2_ns_pkg_installed())
    expect_error(
      mcbette_self_test(),
      "BEAST2 'NS' package not installed"
    )

    # 3. Check for nothing installed
    uninstall_beast2()
    expect_true(!is_beast2_installed())
    expect_error(
      mcbette_self_test(),
      "BEAST2 not installed. Tip: use beastier::install_beast2()"
    )

    # Restore current state
    if (was_beast2_installed) {
      expect_false(is_beast2_installed())
      install_beast2()
    }
    if (was_beast2_ns_pkg_installed) {
      expect_false(is_beast2_ns_pkg_installed())
      install_beast2_pkg("NS")
    }
  }
})
