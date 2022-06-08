#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

gmap<-read.table(args[1],skip=1,header=F,stringsAsFactors=F)

colnames(gmap)<-c("position","rate","map")

map<-read.table(args[2],header=F,stringsAsFactors=F)

colnames(map)<-c("chrom","rsid","position","a1","a2")

map$cm<-approx(x=gmap$position,y=gmap$map,xout=map$position)$y

missing<-which(is.na(map$cm))

map$cm[missing[which(map$position[missing]<=min(gmap$position))]]<-0

map$cm[missing[which(map$position[missing]>=max(gmap$position))]]<-max(gmap$map)

write.table(map$cm,args[3],sep="\t",col.names=F,row.names=F,quote=F)


