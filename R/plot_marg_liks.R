#' Plot the \code{marg_liks}
#' @inheritParams default_params_doc
#' @return a \link[ggplot2]{ggplot}
#' @export
plot_marg_liks <- function(marg_liks) {
  mcbette::check_marg_liks(marg_liks)
  marg_liks$i <- seq(1, nrow(marg_liks))
  min_y <- min(marg_liks$marg_log_lik) -
    (2.0 * max(marg_liks$marg_log_lik_sd))
  max_y <- max(marg_liks$marg_log_lik) +
    (2.0 * max(marg_liks$marg_log_lik_sd))

  i <- NULL; rm(i) # nolint, fixes warning: no visible binding for global variable
  marg_log_lik <- NULL; rm(marg_log_lik) # nolint, fixes warning: no visible binding for global variable
  marg_log_lik_sd <- NULL; rm(marg_log_lik_sd) # nolint, fixes warning: no visible binding for global variable

  ggplot2::ggplot(marg_liks, ggplot2::aes(x = i, y = marg_log_lik)) +
    ggplot2::geom_point(shape = 3) +
    ggplot2::geom_errorbar(
      ggplot2::aes(
        ymin = marg_log_lik - marg_log_lik_sd,
        ymax = marg_log_lik + marg_log_lik_sd,
        width = 1.0
      )
    ) +
    ggplot2::scale_y_continuous(
      name = "Marginal log-likelihood",
      limits = c(min_y, max_y),
    ) +
    ggplot2::scale_x_continuous(
      name = "Model",
      breaks = seq(1, nrow(marg_liks))
    )
}
