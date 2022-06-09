#!/bin/bash

############################################
# Classify mtDNA haplogroup with HaploGrep #
############################################

# HaploGrep GitHub: https://github.com/seppinho/haplogrep-cmd
# Haplogrep requires java 8.

INPUT='All_GTEx_MT.phg001219.v1.GTEx_v8_WES.SNPs.qc.info.recode.vcf' # path to input vcf or fasta file
FORMAT='vcf' # input can also be 'fasta'
OUTPUT='All_GTEx_MT.phg001219.v1.GTEx_v8_WES.SNPs.qc.info.recode.haplo' # name of output

./haplogrep classify --extend-report --in ${INPUT} --format ${FORMAT} --out ${OUTPUT}

