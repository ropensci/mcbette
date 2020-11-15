test_that("use", {
  marg_liks <- get_test_marg_liks()
  expect_silent(check_marg_liks(marg_liks))

  expect_error(check_marg_liks("nonsense"))
})
