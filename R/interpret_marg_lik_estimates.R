#' Interpret the marginal likelihood estimates
#'
#' Interpret the marginal likelihood estimates
#' as created by \link{est_marg_liks}.
#'
#' @inheritParams default_params_doc
#' @author Richèl J.C. Bilderbeek
#' @export
interpret_marg_lik_estimates <- function(marg_liks) {
  df <- marg_liks
  # Show all models
  cat(" ", sep = "\n")
  cat("**********************************", sep = "\n")
  cat("* All models (ordered by index)  *", sep = "\n")
  cat("**********************************", sep = "\n")
  cat(" ", sep = "\n")
  cat(knitr::kable(df), sep = "\n")

  ##############################################################################
  # Create an ordered data frame
  ##############################################################################
  # Keep rows without an NA
  df_ordered <- na.omit(df)

  # Order from high to low
  df_ordered <- df_ordered[ order(-df_ordered$weight), ]

  # Show most convincing first
  cat(" ", sep = "\n")
  cat("**********************************", sep = "\n")
  cat("* All models (ordered by weight) *", sep = "\n")
  cat("**********************************", sep = "\n")
  cat(" ", sep = "\n")
  cat(knitr::kable(df_ordered), sep = "\n")

  # Show weights
  cat(" ", sep = "\n")
  txtplot::txtplot(x = seq(1, length(df_ordered$weight)), y = df_ordered$weight)

  ##############################################################################
  # Create a best model data frame
  ##############################################################################
  # Show the best model
  best_row_index <- which(
    df_ordered$marg_log_lik == max(df_ordered$marg_log_lik)
  )
  df_best <- df_ordered[best_row_index, ]
  cat(" ", sep = "\n")
  cat("**********************************", sep = "\n")
  cat("* Best model:                    *", sep = "\n")
  cat("**********************************", sep = "\n")
  cat(" ", sep = "\n")
  cat(knitr::kable(df_best, row.names = FALSE), sep = "\n")
}
