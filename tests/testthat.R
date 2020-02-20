library(testthat)
library(mcbette)

is_beast2_installed_before <- beastier::is_beast2_installed()
is_beast2_ns_pkg_installed_before <- NA # nolint long variable name
if (is_beast2_installed_before) {
  is_beast2_ns_pkg_installed_before <- mauricer::is_beast2_ns_pkg_installed() # nolint long variable name
}

test_check("mcbette")

is_beast2_installed_after <- beastier::is_beast2_installed()
is_beast2_ns_pkg_installed_after <- NA # nolint long variable name
if (is_beast2_installed_before) {
  is_beast2_ns_pkg_installed_after <- mauricer::is_beast2_ns_pkg_installed() # nolint long variable name
}

expect_equal(
  is_beast2_installed_before,
  is_beast2_installed_after
)
if (is.na(is_beast2_ns_pkg_installed_before)) {
  expect_true(is.na(is_beast2_ns_pkg_installed_after))
} else {
  expect_equal(
    is_beast2_ns_pkg_installed_before,
    is_beast2_ns_pkg_installed_after
  )
}
