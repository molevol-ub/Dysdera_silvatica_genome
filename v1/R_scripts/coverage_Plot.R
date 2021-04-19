genomeSize = 1360000000
## PE_freq
PE_freq <-read.csv(file="coverage/PE_Reads_sorted.coverage.freq", sep="\t", header=TRUE)

## MP_ALL_Reads
MP_ALL_Reads <-read.csv(file="coverage/MP_Reads_sorted_coverage.freq", sep="\t", header=TRUE)
##################################

## Pacbio_ALL_Reads
Pacbio_ALL_Reads <-read.csv(file="coverage/Pacbio_reads_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## Nanopore_ALL_Reads
Nanopore_ALL_Reads <-read.csv(file="coverage/Nanopore_reads_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## ALL READS
ALL_reads <-read.csv(file="coverage/merge_sorted.coverage.freq", sep="\t", header=TRUE)
##################################

## Plot
layout(respect = TRUE, matrix(c(1,1), 1, 1, byrow = TRUE), widths=c(1,1), heights=c(1,1))

plot(Pacbio_ALL_Reads$X..Coverage[2:100],Pacbio_ALL_Reads$Count[2:100], type="l", lwd=2, col="orange", lty=1, xlab="Coverage", ylab="Frequency")
lines(MP_ALL_Reads$X..Coverage[2:100],MP_ALL_Reads$Count[2:100], type="l", lwd=2, col="red")
lines(ALL_reads$X..Coverage[2:100],ALL_reads$Count[2:100], type="l", lwd=2, col="black")
lines(PE_freq$X..Coverage[2:100],PE_freq$Count[2:100], type="l", lwd=2, col="blue")
lines(Nanopore_ALL_Reads$X..Coverage[2:100],Nanopore_ALL_Reads$Count[2:100], type="l", lwd=2, col="dark green")

#lines(Pacbio_ALL_Reads$X..Coverage[2:100],Pacbio_ALL_Reads$Count[2:100], type="l", col="green")

# ALL
sumCoverage_all <- sum(as.numeric( ALL_reads[0:8079,1] * ALL_reads[0:8079,2]))
mean_all <- sumCoverage_all/genomeSize
abline(v=mean_all,lty=2, col="black")

# PE
sumCoverage_PE <- sum(as.numeric( PE_freq[0:8079,1] * PE_freq[0:8079,2]))
mean_PE <- sumCoverage_PE/genomeSize
abline(v=mean_PE,lty=2, col="blue")

# MP
sumCoverage_MP <- sum(as.numeric( MP_ALL_Reads[0:8059,1] * MP_ALL_Reads[0:8059,2]))
mean_MP <- sumCoverage_MP/genomeSize
abline(v=mean_MP,lty=2, col="red")

# Pacbio
sumCoverage_PB <- sum(as.numeric( Pacbio_ALL_Reads[0:289,1] * Pacbio_ALL_Reads[0:289,2]))
mean_PB <- sumCoverage_PB/genomeSize
abline(v=mean_PB,lty=2, col="orange")

# Nanopore
sumCoverage_Nano <- sum(as.numeric( Nanopore_ALL_Reads[0:8047,1] * Nanopore_ALL_Reads[0:8047,2]))
mean_Nano <- sumCoverage_Nano/genomeSize
abline(v=mean_Nano,lty=2, col="dark green")

legend(
  "topright", ## POSITION 
  c("All reads coverage","Mean coverage", "PE coverage", "Mean Coverage PE", "MP coverage", "Mean Coverage MP", "Pacbio Coverage", "Mean Pacbio Coverage", "Nanopore Coverage", "Mean Nanopore Coverage" ), # puts text in the legend 
  lty=c(1,2,1,2,1,2,1,2,1,2),               # gives the legend appropriate symbols (lines)
  lwd=c(3,1,3,1,3,1,3,1,3,1), ## width
  col=c("black","black","blue","blue","red","red", "orange", "orange", "dark green", "dark green") # gives the legend lines the correct color
)

