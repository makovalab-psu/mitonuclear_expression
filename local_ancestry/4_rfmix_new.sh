#!/bin/bash
#SBATCH --job-name=rfmix
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60000
#SBATCH --time=0-80:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=ejt89@psu.edu
#SBATCH --chdir=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8
#SBATCH --output=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8/log/ejt89-rfmix-%j.out
#SBATCH --error=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/D_localAnc/LocalAnc_v8/log/ejt89-rfmix-%j.err

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

chrom=${1}
cd chr${chrom}

# Run RFMix (conda installation).
rfmix \
-f rfmixready_merged.${chrom}.query.vcf \
-r rfmixready_merged.${chrom}.ref.vcf \
-m ../SPLIT_1kg_CEU-YRI.txt \
-g rfmixready.${chrom}.geneticmap \
-o rfmixout.${chrom} \
--chromosome=${chrom}

## Manual (https://github.com/slowkoni/rfmix/blob/master/MANUAL.md)
#-f rfmixready_merged.22.query.vcf \ #<query VCF/BCF file>
#-r rfmixready_merged.22.ref.vcf \ #<reference VCF/BCF file>
#-m ../SPLIT_1kg_CEU-YRI.txt \ #<sample map file>
#-g rfmixready.${chrom}.geneticmap \ #<genetic map file>
#-o rfmixout.${chrom} \ #output
#--chromosome=${chrom}




#RunRFMix.py \
#PopPhased \
#rfmixready.${chrom}.alleles \
#rfmixready.${chrom}.classes \
#rfmixready.${chrom}.snplocations \
#-o rfmixout.${chrom} \
#-w 0.2 \
#-n 5 \
#--forward-backward \
#--num-threads 20 \
#-e 2

