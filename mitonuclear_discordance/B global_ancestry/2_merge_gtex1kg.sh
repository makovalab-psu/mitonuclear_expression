#!/bin/bash
#######################
# Merge GTEx and 1000G:
#######################

# Stop on any errors and print all commands.
set -uex

	# Arguments.
	#prefix_G=
	#prefix_1=
	input_G=GTEX-WGS-ALL_hg19_filtered_nopal
	input_1=1KG-WGS-ALL_biall_nopal
	
	prefix_M=MERGED-WGS-ALL_hg19_biall_nopal

mkdir -p merged_gtex1kg; cd merged_gtex1kg
mkdir -p ALL; cd ALL

# Replace the original SNP IDs with a common CHR_POS.
#bash ../../modify_bim.sh ${input_1}.bim 'Overwrite'
#bash ../../modify_bim.sh ${input_G}.bim 'Overwrite'

# Create input files for bedtools from the new IDs.
#cat ${input_G}.bim | cut -f1,4 | paste - <(cat ${input_G}.bim | cut -f4) | paste - <(cat ${input_G}.bim | cut -f2) > TESTG
#cat ${input_1}.bim | cut -f1,4 | paste - <(cat ${input_1}.bim | cut -f4) | paste - <(cat ${input_1}.bim | cut -f2) > TEST1

# Intersect to get common SNPs across GTEx and 1000G.
#bedtools intersect -a TEST1 -b TESTG > list.common.snps

# Try (and fail) to merge GTEx and 1000G.
# Provides the list (.missnp) of problematic sites. 
#	echo ${input_1} > all_files.txt
#	echo ${input_G} >> all_files.txt
#plink --merge-list all_files.txt --make-bed --out ${prefix_M}

# Look for the .missnp sites in the GTEx and 1000G files.
#####for ID in `cat ${prefix_M}-merge.missnp`; do grep $ID ${input_G}.bim >> TEST.missnp ; grep $ID ${input_1}.bim >> TEST.missnp ; done

### Exclude the SNPs that seem to be multiallelic.
	cp ${prefix_M}-merge.missnp exclude.missnp
plink --bfile ${input_G} --exclude exclude.missnp --make-bed --out ${input_G}_excl
plink --bfile ${input_1} --exclude exclude.missnp --make-bed --out ${input_1}_excl


###### Flip (instead of exclude) the SNPs that seem to be multiallelic.
######	cp MERGED-WGS-ALL_biall_nopal-merge.missnp flip.missnp
######plink --bfile GTEX-WGS-ALL_biall_nopal --flip flip.missnp --make-bed --out GTEX-WGS-ALL_biall_nopal_flipd

######	prefix=MERGED-WGS-ALL_biall_nopal_flipd

# Merge GTEx and 1000G after excluding problematic sites.
	echo ${input_1}_excl > all_files.txt
	echo ${input_G}_excl >> all_files.txt
plink --merge-list all_files.txt --make-bed --out ${prefix_M}_excl

