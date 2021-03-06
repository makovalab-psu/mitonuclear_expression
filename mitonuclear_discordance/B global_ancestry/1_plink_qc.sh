#!/bin/bash
#########################################
# Quality control steps (within-dataset).
#########################################

# Stop on any errors and print all commands.
set -uex

# Change variants file (VCF) into PLINK format (and exclude MT).
plink --vcf <INPUT.vcf> --allow-extra-chr --chr 1-22 XY --out <INPUT.plink>

# Filter by Minor Allele Freq, Genotype missingness across samples, and keep biallelic sites.
# Keep only AfAm and EuAm individuals.
plink --bfile <INPUT> --maf 0.01 --geno 0.2 --keep <Select_Individuals.txt> --biallelic-only strict --out <INPUT_filtered>

# Identify the palindromic SNPs, then filter them out.
Rscript rm_palindromic.R <INPUT_filtered.bim>
plink --bfile <INPUT_filtered> --extract list.nonpalindromic.snps --out <INPUT_filtered_nopal>

## Test for signs of population stratification (pruning sites by LD, generating IBS values, MDS clustering).
# Prune sites.
plink --bfile <INPUT_filtered_nopal> --indep 50 5 2 --allow-no-sex --out <INPUT_filtered_nopal_prune>
plink --bfile <INPUT_filtered_nopal> --maf 0.01 --geno 0.1 --mind 0.1 --extract <INPUT_filtered_nopal_prune.prune.in> --out <INPUT_filtered_nopal_pruned>
# Generate IBS (Identity-by-descent) values.
plink --bfile ${prefix}_filtered_pruned --genome --out ${prefix}_genome
# Generate MDS clustering.
plink --bfile ${prefix}_filtered_pruned --read-genome ${prefix}_genome.genome --cluster --K 2 --mds-plot 4 --out ${prefix}_mds
# Create MDS plots.
Rscript makeplot_mds.R ${prefix}_mds.mds <GTEX/1000G>