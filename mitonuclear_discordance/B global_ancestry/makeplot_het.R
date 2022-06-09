## June 11, 2020
## Edmundo Torres-Gonzalez
##################################################
# Plot the heterozygosity values to determine 
# 	cutoff of "contaminated" samples (>3 sd).
##################################################

args = commandArgs(trailingOnly=TRUE)

# Test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("# Two arguments must be supplied: (1)File_het.het (2) Path to file ", call.=FALSE)
} else if (length(args)==1){
  FILE_IN=args[1]
  FILE_OUT="plot_Het.pdf"
} else if (length(args)>1){
  FILE_IN=paste(args[2],"/",args[1], sep="")
  FILE_OUT=paste(args[2],"/","plot_Het.pdf", sep="")
}

# Read heterozygosity file.
data = read.table( FILE_IN , header=TRUE)

# Calculate the 5x SD cutoff.
cutoff = sd(data$F)*5

# Step 1: Call the pdf command to start the plot.
pdf( file=FILE_OUT, # The directory you want to save the file in
	width=10, height=10 ) # The width and height of the plot in inches

# Step 2: Create the plot with R code.
#plot( data$IID , data$F )
hist( data$F,
	main="Heterozygosity", 
	xlab="Fst (estimate)", 
	border="green", 
	col="blue",
	las=1	# Rotation of units (0,1,2,3) 
)

abline(v = cutoff ) # Additional low-level plotting commands
title(sub=paste("Vertical lines represent (+)5*SD: ", cutoff ))

# Step 3: Run dev.off() to create the file!
invisible(dev.off())

# You'll notice that after you close the plot with dev.off(), you'll see a message in the prompt like "null device". That's just R telling you that you can now create plots in the main R plotting window again.

#print("The 5*+SD cutoff is:" )
#print( cutoff )
dput(cutoff, "")


