#' 
#' From [1] H. Jeffreys (1961). The Theory of Probability (3rd ed.). Oxford. p. 432
interpret_bayes_factor <- function(bayes_factor) {
  
  if (!beautier::is_one_double(bayes_factor)) {
    stop(
      "'bayes_factor' must be one numeric value. \n",
      "Actual value: ", bayes_factor
    )
  }

  if (bayes_factor < 10^0.0) {
    "in favor of other model"
  } else if (bayes_factor < 10^0.5) {
    "barely worth mentioning"
  } else if (bayes_factor < 10^1.0) {
    "substantial"
  } else if (bayes_factor < 10^1.5) {
    "strong"
  } else if (bayes_factor < 10^2.0) {
    "very strong"
  } else {
    "decisive"
  }
}
