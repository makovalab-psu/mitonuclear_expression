#!/bin/bash
##########################################################
# Quality control steps (between GTEx and 1000G datasets).
##########################################################

# Stop on any errors and print all commands.
set -uex

# Filter by maf and missingness.
plink --bfile <merged_dataset> --maf 0.01 --geno 0.1 --out <merged_dataset_filt>

## Test for signs of population stratification (pruning sites by LD, generating IBS values, MDS clustering).
# List of sites to prune.
plink --bfile <merged_dataset_filt> --maf 0.01 --geno 0.1 --mind 0.1 --indep 50 5 2 --allow-no-sex --out <merged_dataset_filt_prune>
# Keep that list of pruned sites.
plink --bfile <merged_dataset_filt> --extract <merged_dataset_filt_prune.prune.in> --maf 0.01 --geno 0.1 --mind 0.1 --out <merged_dataset_filt_pruned>
# Generate IBS (Identity-by-descent) values.
plink --bfile <merged_dataset_filt_pruned> --genome --allow-no-sex --out <merged_dataset_filt_genome>
# Generate MDS clustering.
plink --bfile <merged_dataset_filt_pruned> --read-genome <merged_dataset_filt_genome.genome> --cluster --K 2 --mds-plot 4 --allow-no-sex --out <merged_dataset_filt_pruned_mds>
# Create MDS plot.
Rscript makeplot_mds.R <merged_dataset_filt_pruned_mds.mds> "MERGED"