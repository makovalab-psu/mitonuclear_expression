#!/bin/bash
#SBATCH --job-name=conv2rfmix
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60000
#SBATCH --time=0-80:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=ejt89@psu.edu
#SBATCH --chdir=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8
#SBATCH --output=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8/log/ejt89-conv2rfmix-%j.out
#SBATCH --error=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8/log/ejt89-conv2rfmix-%j.err

echo "Job started"; date "+%Y-%m-%d.%H:%M:%S"
export CONDA_ENVS_PATH=/home/ejt89/.conda/envs
source /opt/anaconda/etc/profile.d/conda.sh
conda activate /home/ejt89/.conda/envs/ancestry
#source activate /home/ejt89/.conda/envs/ancestry
#conda activate ancestry
conda info --envs
conda list
# Arslan's conda environment for running SHAPEIT.
ls /nfs/brubeck.bx.psu.edu/scratch4/arslan/anaconda2/envs/xtools/bin

# Stop on any errors and print all commands.
set -uex

if [ -z "$1" ]; then echo "###   ARGUMENT NEEDED: Provide chromosome   ###"; fi

####source /nfs/brubeck.bx.psu.edu/scratch4/arslan/.bash_profile
####source activate xtools

chrom=${1}
cd chr${chrom}

#convert merged vcf file to hap file which is similiar in format required for RFMIX
bcftools convert --hapsample rfmixready.${chrom} rfmixready_merged.${chrom}.vcf
gunzip -f rfmixready.${chrom}.hap.gz

#remove first 5 columns containing SNPs information and delete spaces between genotypes
cat rfmixready.${chrom}.hap  | cut -d ' ' -f6- | tr -d ' ' > rfmixready.${chrom}.alleles
cat rfmixready.${chrom}.hap  | cut -d ' ' -f1-5  > rfmixready.${chrom}.map

#generate genetic map file
#genetic_map=/nfs/brubeck.bx.psu.edu/scratch3/arslan/mtnuc_project/analysis/lanc/genetic_map_b37/genetic_map_chr${chrom}_combined_b37.txt
genetic_map=../genetic_map_b37/genetic_map_chr${chrom}_combined_b37.txt
Rscript ../calc_cM.R ${genetic_map} rfmixready.${chrom}.map rfmixready.${chrom}.snplocations

# Assign RFMix class to GTEx (0), YRI (2), and CEU (1)
#join <(sort chr${chrom}/rfmixready.${chrom}.sample) <(grep 'GTEX' Merged_GTEx-1KG_v8.ids | cat - <(grep 'YRI' Merged_GTEx-1KG_v8.ids) | cat - <(grep 'CEU' Merged_GTEx-1KG_v8.ids ) | sort) | cut -d' ' -f1,2,4 | sed 's/G-AfAm/0/g' | sed 's/G-EuAm/0/g' | sed 's/YRI/2/g' | sed 's/CEU/1/g' > classes_reffile.txt

#generate classes file
Rscript ../gen_classes.R ../classes_reffile.txt rfmixready.${chrom}.sample rfmixready.${chrom}.classes

# Create a "Genetic Map" (-g) file for RFMix version 2.03. 
# It should be 3 columns: Chr, Pos, cM
paste <(cut -f1,3 -d' ' rfmixready.${chrom}.map) rfmixready.${chrom}.snplocations | sed 's/\s/\t/g' > rfmixready.${chrom}.geneticmap

#### Add a 0 (admix, non-ref) to other 1000G pops that are still there.
####cat chr${chrom}/rfmixready.${chrom}.classes | sed 's/NA/0/g' > chr${chrom}/rfmixready.${chrom}.classes


