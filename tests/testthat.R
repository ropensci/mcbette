library(testthat)
library(mcbette)


testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "tracerer")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "beastier")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "mauricer")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "babette")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "mcbette")))
)

test_check("mcbette")

testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "tracerer")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "beastier")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "mauricer")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "babette")))
)
testthat::expect_equal(
  0,
  length(list.files(rappdirs::user_cache_dir(appname = "mcbette")))
)
