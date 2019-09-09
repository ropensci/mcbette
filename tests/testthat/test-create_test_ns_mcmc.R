test_that("use", {
  ns_mcmc <- create_test_ns_mcmc()
  expect_true(beautier::is_nested_sampling_mcmc(ns_mcmc))
  # Short max MCMC chain
  expect_true(ns_mcmc$chain_length <= 1e4)

  # Default store_every
  expect_equal(
    ns_mcmc$store_every,
    beautier::create_nested_sampling_mcmc()$store_every
  )

  # Default sub-chain length
  expect_equal(
    ns_mcmc$sub_chain_length,
    beautier::create_nested_sampling_mcmc()$sub_chain_length
  )

  # Default particle count
  expect_equal(
    ns_mcmc$particle_count,
    beautier::create_nested_sampling_mcmc()$particle_count
  )

  # Epsilon of low accuracy
  expect_true(ns_mcmc$epsilon >= 10.0)
})
