test_that("use", {
  expect_equal(interpret_bayes_factor(0.5), "in favor of other model")
  expect_equal(interpret_bayes_factor(1.5), "barely worth mentioning")
  expect_equal(interpret_bayes_factor(8.5), "substantial")
  expect_equal(interpret_bayes_factor(12.5), "strong")
  expect_equal(interpret_bayes_factor(85.0), "very strong")
  expect_equal(interpret_bayes_factor(123.0), "decisive")

  expect_error(
    interpret_bayes_factor(c(0.1, 0.2)),
    "'bayes_factor' must be one numeric value"
  )
  expect_error(
    interpret_bayes_factor("nonsense"),
    "'bayes_factor' must be one numeric value"
  )
  expect_error(
    interpret_bayes_factor(NA),
    "'bayes_factor' must be one numeric value"
  )
  expect_error(
    interpret_bayes_factor(NULL),
    "'bayes_factor' must be one numeric value"
  )
  expect_error(
    interpret_bayes_factor(Inf),
    "'bayes_factor' must be one numeric value"
  )

})
