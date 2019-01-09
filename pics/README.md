# `pics`

Pictures used by `mcbette` from the root folder.

Filename|Description
---|---
`alignment.png`|README.md (in root folder) alignment
`Codecov.png`|Codecov logo
`TravisCI.png`|Travis CI logo

## How to create `alignment.png`

```{r}
fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
png("alignment.png")
ape::image.DNAbin(ape::read.FASTA(fasta_filename))
dev.off()

fasta_filename <- system.file("extdata", "primates.fas", package = "mcbette")
png("alignment.png"); ape::image.DNAbin(ape::read.FASTA(fasta_filename)); dev.off()
```