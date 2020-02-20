test_that("use", {
  expect_silent(set_mcbette_state(get_mcbette_state()))
})

test_that("all transitions", {

  if (!beastier::is_on_travis()) return()

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
  # Transition | From        | To                                               # nolint this is no code
  # -----------|-------------|-------------                                     # nolint this is no code
  # 1          | Neither     | BEAST2                                           # nolint this is no code
  # 2          | BEAST2      | BEAST2 + NA                                      # nolint this is no code
  # 3          | BEAST2 + NS | BEAST2                                           # nolint this is no code
  # 4          | BEAST2      | Neither                                          # nolint this is no code
  # 5          | Neither     | BEAST2 + NS                                      # nolint this is no code
  # 6          | BEAST2 + NS | Neither                                          # nolint this is no code
  #
  state_neither   <- list(beast2_installed = FALSE, ns_installed = FALSE)
  state_beast2    <- list(beast2_installed = TRUE, ns_installed = NA)
  state_beast2_ns <- list(beast2_installed = TRUE, ns_installed = TRUE)
  expect_silent(check_mcbette_state(state_neither))
  expect_silent(check_mcbette_state(state_beast2))
  expect_silent(check_mcbette_state(state_beast2_ns))

  # First go to state neither
  set_mcbette_state(state_neither)

  # 1          | Neither     | BEAST2                                           # nolint this is no code
  set_mcbette_state(state_beast2)

  # 2          | BEAST2      | BEAST2 + NS                                      # nolint this is no code
  set_mcbette_state(state_beast2_ns)

  # 3          | BEAST2 + NS | BEAST2                                           # nolint this is no code
  set_mcbette_state(state_beast2)

  # 4          | BEAST2      | Neither                                          # nolint this is no code
  set_mcbette_state(state_neither)

  # 5          | Neither     | BEAST2 + NS                                      # nolint this is no code
  set_mcbette_state(state_beast2_ns)

  # 6          | BEAST2 + NS | Neither                                          # nolint this is no code
  set_mcbette_state(state_neither)

  # Restore the state
  set_mcbette_state(before)
})
