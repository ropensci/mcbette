library(babette)
testit::assert(is_beast2_installed())
testit::assert(mauricer::mrc_is_installed("NS"))

df <- mcbette::est_marg_liks("my_alignment.fas")
knitr::kable(df)

# Keep non-NA
df <- na.omit(df)
best_row_index <- which(df$marg_log_lik == max(df$marg_log_lik))

df_best <- df[best_row_index, ]
print("Best model:")
knitr::kable(df_best, row.names = FALSE)
