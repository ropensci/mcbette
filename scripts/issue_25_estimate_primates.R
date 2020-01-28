# R script to estimate the evidence of the Primates.nex alignment
# Using different settings

library(mcbette)

fasta_filename <- tempfile()

beastier::save_nexus_as_fasta(
  nexus_filename = beastier::get_beast2_example_filename("Primates.nex"),
  fasta_filename = fasta_filename
)


infer

create_test_ns_inference_model()


mcbette::est_marg_lik(
  fasta_filename = fasta_filename,
  inference_model = inference_model
)

