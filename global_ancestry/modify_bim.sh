#!/bin/bash
## June 29 2020
## Edmundo TG
###############################################################
# Make a SNP ID column from just 'chr' and 'pos' (Modify .bim)
###############################################################

set -uex

if [ -z "$1" ]; then echo "###   ARGUMENT NEEDED: PROVIDE {input.bim} FILE   ###"; fi
test=`echo $1 | rev | cut -d. -f1 | rev`
if [ $test != "bim" ]; then echo "###   ARGUMENT NEEDED: Argument must end with {.bim}   ###"; fi
	# Arguments in:
	BIM_IN=${1}


# Exchanges the SNP ID column in a PLINK {.bim}, for a "CHR_POS" ID column.
cat ${BIM_IN} | awk '{OFS="\t"}{print $1, $1"_"$4 , $3,$4,$5,$6}' > TEMP.bim


# Compare the original and modified files {.bim}
	echo "# Lines in : "
	wc -l TEMP.bim
	wc -l $BIM_IN
# Test that the original and modified files are identical in all but the 2nd column.
	echo "## [Output is an issue] This test should return ZERO if they are identical except for the 2nd column:"
		test_diff=`diff <(cut -f1,3,4,5,6 TEMP.bim) <(cut -f1,3,4,5,6 ${BIM_IN}) | wc -l `
		echo $test_diff
	echo "## [Output is normal] This test should return NON-ZERO if they are NOT completely identical:"
	diff <(cat TEMP.bim) <(cat ${BIM_IN}) | wc -l


if [ -z "$2" ]; then echo "###   If you wish to OVERWRITE the original {.bim} file, provide "Overwrite" as a 2nd argument   ###"; fi
# Precautions before a file is overwritten.
if [ "$test_diff" != 0 ]; then \
	echo "#######					      		#######" ; \
	echo "######## Diff test suggests that the modified file is BAD. ########" ; \
	echo "#######					      		#######" ; fi
if [ "$test_diff" == 0 ]; then \
	echo "# Seems like the modified file works." ; \
	if [ "$2" == "Overwrite" ]; then \
	mv TEMP.bim $BIM_IN ; \
	echo "###							###" ; \
	echo "### The original file ${BIM_IN} was overwritten ###" ; \
	echo "###							###" \
; fi ; fi


