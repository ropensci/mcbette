test_that("use", {
  expect_true(is_marg_liks(get_test_marg_liks()))
  expect_false(is_marg_liks("nonsense"))
  expect_false(is_marg_liks(NA))
  expect_false(is_marg_liks(NULL))
  expect_false(is_marg_liks(42))
  expect_false(is_marg_liks(3.14))
  expect_false(is_marg_liks(c()))
  expect_false(is_marg_liks(c(1, 2, 3)))
  expect_false(is_marg_liks(c(1, 2, 3)))
})

test_that("verbose", {
  expect_message(is_marg_liks("nonsense", verbose = TRUE))
})
