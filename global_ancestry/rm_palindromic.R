#!/usr/bin/env Rscript
###################################
# Identifies non-palindromic SNPs.
###################################
# These A>T, T>A, G>C, C>G changes cannot be 
# 	distinguished from which strand they were genotyped.

args = commandArgs(trailingOnly=TRUE)
# Test if there is at least one argument: if not, return an error
if (length(args)<1) {
  stop("# Two arguments may be supplied: (1) File_in.bim ", call.=FALSE)
} else if (length(args)==1){
  BIM_IN=args[1]
}

bim<-read.table( BIM_IN ,sep="\t",header=F)

colnames(bim)<-c("chr","rsid","cm","bp","a1","a2")

bim$alleles<-paste(bim$a1,bim$a2,sep="")

palindromes<-c("AT","TA","GC","CG")

bim2<-bim[-which(bim$alleles%in%palindromes),]

write.table(bim2$rsid,  "list.nonpalindromic.snps" ,col.names=F,row.names=F,quote=F)

