library(mcbette)
testit::assert(beastier::is_beast2_installed())
testit::assert(mauricer::mrc_is_installed("NS"))

df <- mcbette::est_marg_liks("my_alignment.fas")

# Show all models
knitr::kable(df)

# Keep non-NA
df <- na.omit(df)

# Order from high to low
df <- df[ order(-df$weight), ]

# Show most convincing first
knitr::kable(df)

# Show weights
txtplot::txtplot(x = seq(1, length(df$weight)), y = df$weight)

# Show the best model
best_row_index <- which(df$marg_log_lik == max(df$marg_log_lik))
df_best <- df[best_row_index, ]
print("Best model:")
knitr::kable(df_best, row.names = FALSE)
