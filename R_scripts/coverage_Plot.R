

setwd("/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome")
genomeSize = 1700000000
## PE_freq
PE_freq <-read.csv(file="R_scripts/coverage_Stats/PE_Reads_sorted.coverage.freq", sep="\t", header=TRUE)

## MP_ALL_Reads
MP_ALL_Reads <-read.csv(file="R_scripts/coverage_Stats/MP_Reads_sorted_coverage.freq", sep="\t", header=TRUE)
##################################

## Pacbio_ALL_Reads
Pacbio_ALL_Reads <-read.csv(file="R_scripts/coverage_Stats/Pacbio_reads_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## Nanopore_ALL_Reads
Nanopore_ALL_Reads <-read.csv(file="R_scripts/coverage_Stats/Nanopore_reads_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## ALL READS
ALL_reads <-read.csv(file="R_scripts/coverage_Stats/merge_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## Plot
layout(respect = TRUE, matrix(c(1,1), 1, 1, byrow = TRUE), widths=c(1,1), heights=c(1,1))

plot(Pacbio_ALL_Reads$X..Coverage[2:100],Pacbio_ALL_Reads$Count[2:100], type="l", col="blue", lty=1, xlab="Coverage", ylab="Frequency")
lines(MP_ALL_Reads$X..Coverage[2:100],MP_ALL_Reads$Count[2:100], type="l", col="red")
lines(ALL_reads$X..Coverage[2:100],ALL_reads$Count[2:100], type="l", col="black")
lines(PE_freq$X..Coverage[2:100],PE_freq$Count[2:100], type="l", col="orange")
lines(Nanopore_ALL_Reads$X..Coverage[2:100],Nanopore_ALL_Reads$Count[2:100], type="l", col="green")

#lines(Pacbio_ALL_Reads$X..Coverage[2:100],Pacbio_ALL_Reads$Count[2:100], type="l", col="green")

# ALL
sumCoverage_all <- sum(as.numeric( ALL_reads[0:8079,1] * ALL_reads[0:8079,2]))
abline(v=sumCoverage_all/genomeSize,lty=2,col="black")
sumCoverage_all/genomeSize

# PE
sumCoverage_PE <- sum(as.numeric( PE_freq[0:8079,1] * PE_freq[0:8079,2]))
abline(v=sumCoverage_PE/genomeSize,lty=2,col="orange")
sumCoverage_PE/genomeSize

# MP
sumCoverage_MP <- sum(as.numeric( MP_ALL_Reads[0:8059,1] * MP_ALL_Reads[0:8059,2]))
abline(v=sumCoverage_MP/genomeSize,lty=2,col="red")
sumCoverage_MP/genomeSize

# MP
sumCoverage_PB <- sum(as.numeric( Pacbio_ALL_Reads[0:289,1] * Pacbio_ALL_Reads[0:289,2]))
abline(v=sumCoverage_PB/genomeSize,lty=2,col="blue")
sumCoverage_PB/genomeSize

# MP
sumCoverage_Nano <- sum(as.numeric( Nanopore_ALL_Reads[0:8047,1] * Nanopore_ALL_Reads[0:8047,2]))
abline(v=sumCoverage_Nano/genomeSize,lty=2,col="green")
sumCoverage_Nano/genomeSize


legend(
  "topright", ## POSITION 
  c("All reads coverage","Mean coverage", "PE coverage", "Mean Coverage PE", "MP coverage", "Mean Coverage MP"), # puts text in the legend 
  lty=c(1,2,1,2,1,2),               # gives the legend appropriate symbols (lines)
  lwd=c(3,3,3,3,3,3), ## width
  col=c("black","black","blue","blue","red","red") # gives the legend lines the correct color
)

