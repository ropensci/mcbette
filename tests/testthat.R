library(testthat)
library(mcbette)

before <- get_mcbette_state()

test_check("mcbette")

# Check if everything is the same again
expect_identical(before, get_mcbette_state())
