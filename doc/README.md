# `doc`

## How to create `alignment.png`

```{r}
fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
png("alignment.png")
ape::image.DNAbin(ape::read.FASTA(fasta_filename))
dev.off()

fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
png("alignment.png"); ape::image.DNAbin(ape::read.FASTA(fasta_filename)); dev.off()
```
