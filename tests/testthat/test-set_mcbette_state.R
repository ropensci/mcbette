test_that("use", {
  expect_silent(set_mcbette_state(get_mcbette_state()))
})

test_that("all transitions", {

  before <- get_mcbette_state()

  # We'll do the following 6 transitions:
  #
  #         ------------ 5 ------------>
  #
  #         --- 1 --->        --- 2 --->
  # Neither            BEAST2            BEAST2 + NS
  #         <--- 4 ---        <--- 3 ---
  #
  #         <----------- 6 -------------
  #
  # As a list:
  #
  # Transition | From        | To
  # -----------|-------------|-------------
  # 1          | Neither     | BEAST2
  # 2          | BEAST2      | BEAST2 + NA
  # 3          | BEAST2 + NS | BEAST2
  # 4          | BEAST2      | Neither
  # 5          | Neither     | BEAST2 + NS
  # 6          | BEAST2 + NS | Neither
  #
  state_neither   <- list(beast2_installed = FALSE, ns_installed = FALSE)
  state_beast2    <- list(beast2_installed = TRUE , ns_installed = NA)
  state_beast2_ns <- list(beast2_installed = TRUE , ns_installed = TRUE)
  expect_silent(check_mcbette_state(state_neither))
  expect_silent(check_mcbette_state(state_beast2))
  expect_silent(check_mcbette_state(state_beast2_ns))

  # First go to state neither
  set_mcbette_state(state_neither)

  # 1          | Neither     | BEAST2
  set_mcbette_state(state_beast2)

  # 2          | BEAST2      | BEAST2 + NS
  set_mcbette_state(state_beast2_ns)

  # 3          | BEAST2 + NS | BEAST2
  set_mcbette_state(state_beast2)

  # 4          | BEAST2      | Neither
  set_mcbette_state(state_neither)

  # 5          | Neither     | BEAST2 + NS
  set_mcbette_state(state_beast2_ns)

  # 6          | BEAST2 + NS | Neither
  set_mcbette_state(neither)

  # Restore the state
  set_mcbette_state(before)
})
