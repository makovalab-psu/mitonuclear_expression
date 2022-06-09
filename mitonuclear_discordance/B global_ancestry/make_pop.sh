## Sept 10 2020
## A 'pop' file is needed in order to perform supervised ADMIXTURE.

set -eux

	##prefix=NATMERG-WGS-ALL_biall_nopal_filt_common_pruned_keep
	prefix=$1
	DATADIR=/nfs/secure/scratch6/nekrut_gtex/ejt89/mito_gtex/bin/B_globalAnc/GlobalAnc_v8

# Get individual IDs.
cat $DATADIR/merged_gtex1kg/ALL/${prefix}.fam | cut -d' ' -f2 > ${prefix}.ids

# Use ID to grep the population code.
rm -f ${prefix}.test
for ID in `cat ${prefix}.ids`; do grep $ID $DATADIR/Merged_GTEx-1KG-NATAM_v8.ids >> ${prefix}.test ; done

# Eliminate the unneeded IDs column for ADMIXTURE, and the GTEx population codes.
##cat ${prefix}.test | cut -f2 | sed 's/G-EuAm/-/g' | sed 's/G-AfAm/-/g' | \
##	sed 's/MAYAN/NATAM/g' | sed 's/NAHUAN/NATAM/g' | sed 's/AYMARAN/NATAM/g' | sed 's/QUECHUAN/NATAM/g' > ${prefix}.pop
# Alternate solution.
cat ${prefix}.test | cut -f2 | sed 's/G-EuAm/-/g' | sed 's/G-AfAm/-/g' | \
	sed 's/BF.../NATAM/g' | sed 's/P.../NATAM/g' | sed 's/MYN.../NATAM/g' | sed 's/MX.../NATAM/g' | sed 's/BM.../NATAM/g' > ${prefix}.pop

# Put copy of POP file with rest of plink files.
cp -f ${prefix}.pop $DATADIR/merged_gtex1kg/ALL

#echo "# Remember to eliminate the IDs from the pop file before use."

