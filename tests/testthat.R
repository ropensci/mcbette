library(testthat)
library(mcbette)

beastier::remove_beaustier_folders()
beastier::check_empty_beaustier_folders()

test_check("mcbette")

beastier::remove_beaustier_folders()
beastier::check_empty_beaustier_folders()
