#!/usr/bin/env/ Rscript

args=commandArgs(TRUE)
library(plyr)
classes=args[1]
samples=args[2]
output_name=args[3]

#class_file<-read.table(classes,header=T)
class_file <- read.table(classes,header=F)
colnames(class_file) <- c("FID","IID","Class")

sample_file<-read.table(samples,header=F,skip=2)
colnames(sample_file)<-c("FID","IID","MISS")

merged<-join(sample_file,class_file,by="IID")

hap1<-as.numeric(merged$Class)
hap2<-hap1

hap.classes<-t(c(rbind(hap1,hap2)))

write.table(hap.classes,output_name,sep=" ",col.names=F,row.names=F,quote=F)


