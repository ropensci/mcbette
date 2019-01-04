library(mcbette)
testit::assert(beastier::is_beast2_installed())
testit::assert(mauricer::is_beast2_pkg_installed("NS"))

fasta_filename <- "my_alignment.fas"

# mcbette will check if FASTA file exists
df <- mcbette::est_marg_liks(fasta_filename)

# Show all models
cat("-------------------------------------------------------------------------")
knitr::kable(df)

################################################################################
# Create an ordered data frame
################################################################################
# Keep rows without an NA
df_ordered <- na.omit(df)

# Order from high to low
df_ordered <- df_ordered[ order(-df_ordered$weight), ]


# Show most convincing first
cat("-------------------------------------------------------------------------")
knitr::kable(df_ordered, row.names = FALSE)


# Show weights
cat("-------------------------------------------------------------------------")
txtplot::txtplot(x = seq(1, length(df_ordered$weight)), y = df_ordered$weight)

################################################################################
# Create a best model data frame
################################################################################
# Show the best model
best_row_index <- which(df_ordered$marg_log_lik == max(df_ordered$marg_log_lik))
df_best <- df_ordered[best_row_index, ]
cat("-------------------------------------------------------------------------")
cat("Best model:")
knitr::kable(df_best, row.names = FALSE)
