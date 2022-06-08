## June 24, 2020
## Edmundo Torres-Gonzalez
###############################################################
# Plot the MDS components to determine clustering of samples.
###############################################################

args = commandArgs(trailingOnly=TRUE)
# Test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("# Two arguments may be supplied: (1)File_mds.mds (2) Path to file ", call.=FALSE)
} else if (args[2]=="1KG"){
  FILE_IN=args[1]
  data_labels = read.table( "../../igsr_1kg-IDs.txt", sep="\t" )
  colnames(data_labels) <- c( "FID" , "sex" , "LABEL" )
  FILE_OUT="plot_mds.pdf"
} else if (args[2]=="GTEX"){
  FILE_IN=args[1]
  data_labels = read.table( "../SPLIT_GTEx_EuAm-AfAm.txt", sep="\t" )
  colnames(data_labels) <- c( "FID" , "LABEL" )
  FILE_OUT="plot_mds.pdf"
} else if (args[2]=="MERGED"){
  FILE_IN=args[1]
  data_labels = read.table( "../../Merged_GTEx-1KG.ids", sep="\t" )
  colnames(data_labels) <- c( "FID" , "LABEL" )
  FILE_OUT="plot_mds.pdf"
} else if (args[2]=="MERGED_FILT2"){
  FILE_IN=args[1]
  data_labels = read.table( "../../Merged_GTEx-1KG.ids", sep="\t" )
  colnames(data_labels) <- c( "FID" , "LABEL" )
  FILE_OUT="plot_mds_filt2.pdf"
} else if (args[2]=="MERGED_FILT2_NOPALIN"){
  FILE_IN=args[1]
  data_labels = read.table( "../../Merged_GTEx-1KG.ids", sep="\t" )
  colnames(data_labels) <- c( "FID" , "LABEL" )
  FILE_OUT="plot_mds_filt2_nopalin.pdf"
} else if (args[2]=="NATAM_MAO"){
  FILE_IN=args[1]
  data_labels = read.table( "../Merged_GTEx-1KG-NATAM.ids", sep="\t" )
  colnames(data_labels) <- c( "FID" , "LABEL" )
  FILE_OUT="plot_mds.pdf"
}


# Step 1: Read data, and plot the first two components.
	data <- read.table( FILE_IN , header=T )
	# Add the 'LABELS' column.
	data <- merge( data , data_labels ,by="FID")
	## Sort by 'LABELS' column.
	##data <- data[order('LABELS'),]


# Step 2: Open/create PDF file.
	pdf( file=FILE_OUT , # The output directory
		width=10, height=10 ) # The width and height of the plot in inches


# Step 3: Plot components colored by IDs.
	# Color point according to known ancestry.
	pop <- character(nrow(data))
	
if ( args[2]=="MERGED" ) {  #GTEx and 1000G IDs.
	# Uses the first letter in the Sample ID to assign colors:
	pop[which(substr(data[,1],1,1) =="N")] <- "green"  	#NA in 1000G.
	pop[which(substr(data[,1],1,1) =="H")] <- "blue"   	#HG in 1000G.
	pop[which((data$LABEL) =="CEU")] <- "#000000"  		#CEU in 1000G.
	pop[which((data$LABEL) =="YRI")] <- "#FF0033"  	#YRI in 1000G.
	pop[which(substr(data[,1],1,1) =="G")] <- "azure4"   #G in GTEX.
	pop[which((data$LABEL) =="G-AfAm")] <- "#FFCC33"   		#AfAm in GTEX.
	pop[which((data$LABEL) =="G-EuAm")] <- "darkgreen"   	#EuAm in GTEX.
	plot(data$C1, data$C2, col=pop)
	legend( "topright", legend=c("NA (green)","HG (blue)", "CEU (black)", "YRI (bright red)","GTEX-AfAm (gold)","GTEX-EuAm (darkgreen)") )
	print("# Plotted components 1 and 2: colored by IDs (NA, HG).")	
} 
if ( args[2]=="1KG" ) {  #1000G IDs.
	# Uses the first letter in the Sample ID to assign colors:
	pop[which(substr(data[,1],1,1) =="N")] <- "#666666"  #NA in 1000G.
	pop[which(substr(data[,1],1,1) =="H")] <- "#333333"   #HG in 1000G.
	pop[which((data$LABEL) =="MXL")] <- "#FF0033"  		#AMR in 1000G.
	pop[which((data$LABEL) =="PUR")] <- "#FF0033"  		#AMR in 1000G.
	pop[which((data$LABEL) =="CLM")] <- "#FF0033"  		#AMR in 1000G.
	pop[which((data$LABEL) =="PEL")] <- "#FF0033"  		#AMR in 1000G.
	pop[which((data$LABEL) =="GIH")] <- "#FFCC33"  		#SAS in 1000G.
	pop[which((data$LABEL) =="PJL")] <- "#FFCC33"  		#SAS in 1000G.
	pop[which((data$LABEL) =="BEB")] <- "#FFCC33"  		#SAS in 1000G.
	pop[which((data$LABEL) =="STU")] <- "#FFCC33"  		#SAS in 1000G.
	pop[which((data$LABEL) =="ITU")] <- "#FFCC33"  		#SAS in 1000G.
	pop[which((data$LABEL) =="ACB")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="ASW")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="ESN")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="MSL")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="GWD")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="LWK")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="YRI")] <- "green"  		#AFR in 1000G.
	pop[which((data$LABEL) =="IBS")] <- "blue"  		#EUR in 1000G.
	pop[which((data$LABEL) =="GBR")] <- "blue"  		#EUR in 1000G.
	pop[which((data$LABEL) =="FIN")] <- "blue"  		#EUR in 1000G.
	pop[which((data$LABEL) =="TSI")] <- "blue"  		#EUR in 1000G.
	pop[which((data$LABEL) =="CEU")] <- "blue"  		#EUR in 1000G.
	pop[which((data$LABEL) =="CHB")] <- "#FF00FF"  		#EAS in 1000G.
	pop[which((data$LABEL) =="JPT")] <- "#FF00FF"  		#EAS in 1000G.
	pop[which((data$LABEL) =="CHS")] <- "#FF00FF"  		#EAS in 1000G.
	pop[which((data$LABEL) =="CDX")] <- "#FF00FF"  		#EAS in 1000G.
	pop[which((data$LABEL) =="KHV")] <- "#FF00FF"  		#EAS in 1000G.

	plot(data$C1, data$C2, col=pop)
	legend( "topright", legend=c("NA (gray)","HG (darkergray)", "AMR (bright red)", "SAS (gold)", "AFR (green)", "EUR (blue)", "EAS (pink)" ) )
	print("# Plotted components 1 and 2: colored by IDs (NA, HG).")	
}


# Step 4: Plot the 1st and 2nd components of MDS: colored by LABELs.
	# MDS colored by 'LABEL' (e.g. 1000G superpops).
	plot( data$C1, data$C2, col=data$LABEL )
	legend( "topright", fill=unique(data$LABEL), legend=levels(data$LABEL) )
	print("# Plotted components 1 and 2: colored by LABELs.")


# Step 5: Plot components colored by clustering.
	# Color points according to clustering.
	# SOL column in .mds file includes the result of clustering.
	plot( data$C1, data$C2, col=data$SOL+1 )
	print("# Plotted components 1 and 2: colored by (MDS) clustering.")


# Step 6: Plot components colored by Cohort (GTEX/1KG).
	# Color point according to known ancestry.
	pop <- character(nrow(data))
	
if ( args[2]=="MERGED" ) {  #GTEx and 1000G IDs.
	# Uses the first letter in the Sample ID to assign colors:
	pop[which((data$LABEL) =="G-AfAm")] <- "darkred"   	#AfAm in GTEX.
	pop[which((data$LABEL) =="G-EuAm")] <- "coral"   	#EuAm in GTEX.
	pop[which(substr(data[,1],1,1) =="N")] <- "gray"  	#NA in 1000G.
	pop[which(substr(data[,1],1,1) =="H")] <- "gray"   	#HG in 1000G.
	pop[which((data$LABEL) =="YRI")] <- "lightgreen"	#YRI in 1000G.
	pop[which((data$LABEL) =="CEU")] <- "darkgreen"		#CEU in 1000G.
	pop[which((data$LABEL) =="JPT")] <- "gold"		#JPT in 1000G.
	plot(data$C1, data$C2, col=pop)
	legend( "topright", legend=c( "GTEX-EuAm (Light red)", "GTEX-AfAm (Dark red)", "1KG-CEU (Dark green)", "1KG-YRI (Light green)", "1KG-JPT (Yellow)", "Other 1KG (Gray)") )
	print("# Plotted components 1 and 2: colored by Cohort (GTEX, 1KG).")	
}
if ( args[2]=="NATAM_MAO" ) {  #GTEx and 1000G IDs.
        # Uses the first letter in the Sample ID to assign colors:
	pop[which((data$LABEL) =="G-AfAm")] <- "darkred"        #AfAm in GTEX.
	pop[which((data$LABEL) =="G-EuAm")] <- "coral"          #EuAm in GTEX.
	pop[which(substr(data[,1],1,1) =="A")] <- "gold"        #AYMARAN? in NATAM_MAO.
	pop[which(substr(data[,1],1,1) =="Q")] <- "gold"        #QUECHUAN? in NATAM_MAO.
	pop[which(substr(data[,1],1,1) =="B")] <- "gold"        #AYMARAN in NATAM_MAO.
	pop[which(substr(data[,1],1,1) =="P")] <- "gold"       	#QUECHUAN in NATAM_MAO.
	pop[which(substr(data[,1],1,1) =="M")] <- "gold"        #MAYAN & NAHUAN in NATAM_MAO.
	pop[which(substr(data[,1],1,1) =="N")] <- "gray"        #NA in 1000G.
	pop[which(substr(data[,1],1,1) =="H")] <- "gray"        #HG in 1000G.
	pop[which((data$LABEL) =="YRI")] <- "lightgreen"        #YRI in 1000G.
	pop[which((data$LABEL) =="CEU")] <- "darkgreen"         #CEU in 1000G.
	plot(data$C1, data$C2, col=pop)
        legend( "topright", legend=c( "GTEX-EuAm (Light red)", "GTEX-AfAm (Dark red)", "1KG-CEU (Dark green)", "1KG-YRI (Light green)", "Other 1KG (Gray)", "4 NATAM pops (Yellow)") )
        print("# Plotted components 1 and 2: colored by Cohort (GTEX, 1KG).")
}

# Final Step: Export PDF.
	invisible(dev.off())
	print("# Closed/exported PDF.")


 
