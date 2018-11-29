context("test-calc_weights")

test_that("human values", {

  marg_liks <- c(0.1, 0.2, 0.3, 0.4)
  created <- calc_weights(marg_liks)
  expected <- c(0.1, 0.2, 0.3, 0.4)
  expect_equal(created, expected)
})

test_that("small values", {

  marg_liks <- c(0.0001, 0.0002, 0.0003, 0.0004)
  created <- calc_weights(marg_liks)
  expected <- c(0.1, 0.2, 0.3, 0.4)
  expect_equal(created, expected)
})

test_that("using log values", {

  # -9.210340 -8.517193 -8.111728 -7.824046
  log_marg_liks <- log(c(0.0001, 0.0002, 0.0003, 0.0004))

  # 0.0001, 0.0002, 0.0003, 0.0004
  marg_liks <- exp(log_marg_liks)

  created <- calc_weights(marg_liks)
  expected <- c(0.1, 0.2, 0.3, 0.4)
  expect_equal(created, expected)
})

test_that("teach NA as zero", {

  marg_liks <- c(0.1, 0.2, 0.3, 0.4, NA)
  created <- calc_weights(marg_liks)
  expected <- c(0.1, 0.2, 0.3, 0.4, 0.0)
  expect_equal(created, expected)
})
