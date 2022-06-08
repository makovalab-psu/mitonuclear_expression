## July 1, 2020
## Modified by Edmundo TG from script by Arslan Zaidi & Jinguo Huang
#####################################################################
# Generate Global Ancestry bar plots: Provide file locations and K
#####################################################################

args = commandArgs(trailingOnly=TRUE)
## Arguments needed.
if (length(args)!=4) {
	stop("#### Three arguments must be supplied: \n (1. K used in ADMIXTURE) (2. File_in.Q) (3. File_in.fam) (4. File_in_IDS.txt)  ####", call.=FALSE)
} else 
if (length(args)==4) {
args = commandArgs(trailingOnly=TRUE)
	K = args[1]
  file_in_Q = args[2]
	file_in_FAM = args[3]
	file_in_IDS = args[4]
}
##

# Parameters to test locally.
#setwd("~/Documents/GitHub/mitonuclear_gtex/ancestry/test_admix")
#K = 2; file_in_Q="21/1kg_phase1_chr21_pruned.2.Q"; file_in_FAM="21/1kg_phase1_chr21_pruned.fam"; file_in_IDS="igsr_1kg-IDS.txt"
#K = 7; file_in_Q="21/1kg_phase1_chr21_pruned.7.Q"; file_in_FAM="21/1kg_phase1_chr21_pruned.fam"; file_in_IDS="igsr_1kg-IDS.txt"

if (K>=2) {
  headers_Anc = c("Anc1")
    for (N in seq(2,K)) {
      headers_Anc = append(  headers_Anc,  paste("Anc", N , sep='')  )
  }; print(headers_Anc) 
}

################
#code snippet 1
require(reshape2)

#load the .Q file
  qfile=read.table(  file_in_Q  ,header=F,stringsAsFactors = F)
#colnames(qfile)=c("Anc1","Anc2","Anc3")
  colnames(qfile) = headers_Anc

#add individual ID labels from .fam file
  fam<-read.table(  file_in_FAM  ,header=F,stringsAsFactors = F)
    colnames(fam)=c("FID","IID","Mot_ID","Fat_ID","Sex","Pheno")
  qfile_id = merge(fam$IID,qfile, by='row.names')
    colnames(qfile_id)=c("Index","IID", headers_Anc )
    qfile_id$Index = NULL

#melt the data.frame - i.e. convert to long format
  mqfile=melt(qfile_id,id.vars=c("IID"))
    colnames(mqfile)=c("IID","Ancestry_component","Ancestry")

# See the distribution of fractions.
  boxplot(qfile)


################
#code snippet 2
require(ggplot2)

#stat="identity" tells it that the proportions are already calculated
#width=1 removes lines between bars 
  plt=ggplot(mqfile,aes(IID,Ancestry,fill=Ancestry_component))+
    geom_bar(stat="identity",width=1)

#remove individual IDs from x axis as it can get crowded if you have a lot of samples
  plt<-plt+
    theme(axis.text.x=element_blank())

#label axes and legends
  plt<-plt+
    labs(x="Individuals",y="Global ancestry fraction",fill="Ancestral\ngroup")

#plt



################
### snippet 3

#load pop file - file with population label for each ID
#You may have this information only for reference samples (e.g. from the 1000 genomes)
#Alternatively, you could use geographic location label or any other category
  pop=read.table(  file_in_IDS  ,header=F,sep="\t",stringsAsFactors = F)
  colnames(pop)<-c("IID","pop")
  qfile_id_pop = merge(pop,qfile_id, by="IID")

#melt the data.frame - i.e. convert to long format
  mqfile<-melt(qfile_id_pop,id.vars=c("IID","pop"))
  colnames(mqfile)<-c("IID","pop","Ancestry_component","Ancestry")

#make barplot
  plt<-ggplot(mqfile,aes(IID,Ancestry,fill=Ancestry_component))+
    geom_bar(stat="identity",width=1) 

#remove individual IDs from x axis as it can get crowded if you have a lot of samples
  plt<-plt+
    theme_classic()+
    theme(axis.text.x=element_blank(),axis.title.x=element_blank())+
    labs(y="Ancestry",fill="Ancestral group") #label axes and legends

#split individuals by population
  plt<-plt+facet_wrap(~pop,scales="free")

#plt



################
#snippet 4 

#one final tweak - change the colors as they are horrendous
plt<-plt+
  #scale_fill_manual(values=c("#1b9e77","#d95f02","#7570b3"))
  scale_fill_brewer(palette="Set3")
plt


# Save the last created plot to a pdf
ggsave( paste("plot_admixture_K", K ,".pdf", sep="") , plot=plt )
       
       
