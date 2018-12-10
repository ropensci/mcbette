devtools::install_github("richelbilderbeek/becosys", ref = "develop")
library(becosys)
library(pirouette)

sim_phylo <- function(n_taxa, crown_age) {

  speciation_rate <- log(n_taxa / 2, base = crown_age) / 10 # Divide by 10 appears to be better

  n_tips <- n_taxa - 1 # Must be different
  while (n_tips != n_taxa) {
    phylo <- becosys::bco_pbd_sim(
      create_pbd_params(erg = 0.0, eri = 0.0, scr = 1e8, sirg = speciation_rate, siri = 0.0),
      crown_age = crown_age
    )$recontree
    n_tips <- ape::Ntip(phylo)
    if (n_tips > n_taxa) speciation_rate <- speciation_rate / 1.01
    if (n_tips < n_taxa) speciation_rate <- speciation_rate * 1.01
    print(n_tips)
  }
  phylo
}

crown_age <- 15
set.seed(42)

for (n_taxa in c(10, 20, 30, 40, 50, 60, 70, 80, 160, 320, 640)) {

  phylogeny <- sim_phylo(n_taxa = n_taxa, crown_age = 15)

  for (sequence_length in c(100, 200, 400, 800, 1000, 2000, 4000, 8000)) {
    alignment <- pirouette::sim_alignment(
      phylogeny = phylogeny,
      sequence_length = NA,
      root_sequence = pirouette::create_blocked_dna(sequence_length),
      mutation_rate = 1.0 / crown_age
    )
    ape::write.FASTA(
      x = alignment, 
      file = paste0("~/", n_taxa, "_", sequence_length,".fas")
    )
  }
}
