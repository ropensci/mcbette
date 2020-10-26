library(testthat)
library(mcbette)

before <- get_mcbette_state()

test_check("mcbette")

# Check if everything is the same again
after <- get_mcbette_state()
if (is.na(before$ns_installed)) {
  expect_equal(before$beast2_installed, after$beast2_installed)
  expect_true(is.na(after$ns_installed))
} else {
  expect_identical(before, get_mcbette_state())
}
