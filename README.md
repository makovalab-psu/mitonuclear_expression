# Exploring the effects of mitonuclear interactions on mitochondrial DNA gene expression in humans
#### This repository contains all the code generated for the manuscript.
doi: 10.3389/fgene.2022.797129

Edmundo Torres-González and Kateryna D. Makova*

*Correspondence to Kateryna D. Makova (kdm16@psu.edu)

## Directory Structure

This repository contains the following directories:

1. **`mitonuclear_discordance`**: Includes all Python, R, and Bash scripts necessary for generating global ancestry estimates, mitochiondrial DNA haplogroup, and computing mitonuclear DNA discordance for each individual.

2. **`local_ancestry`**: Contains Bash and R scripts to generate local ancestry estimates using RFMix.

3. **`compare_local_and_global_ancestry`**: Contains Jupyter notebook that compares global genetic ancestry estimates to its equivalent when compiling local genetic ancestry estimates, as a sanity check.

4. **`Analysis`**: Contains the adjustment of gene expression for GTEx samples, local ancestry enrichment analysis, and the code utilized to generate plots for the manuscript.


**Some key dependencies required for the analyses in this manuscript are:**

- **`RFMix`**: estimates local genetic ancestry estimates.

- **`ADMIXTURE`**: estimates global genetic ancestry estimates.

- **`HaploGrep`**: profiles mitochondrial DNA haplogroup.
