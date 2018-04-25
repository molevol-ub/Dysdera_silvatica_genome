
genomeSize = 1182444736
## PE_freq
PE_freq <-read.csv(file="PE-reads.paired.clean.depth_cov.freq", sep="\t", header=TRUE)

## MP_ALL_Reads
MP_ALL_Reads <-read.csv(file="coverage_Stats/MP-ALL_reads.clean.depth_cov.freq", sep="\t", header=TRUE)
##################################

## ALL READS
ALL_reads <-read.csv(file="coverage_Stats/Dsil_ALL_reads.clean.depth_cov.freq", sep="\t", header=TRUE)
##################################

## Plot
layout(respect = TRUE, matrix(c(1,1), 1, 1, byrow = TRUE), widths=c(1,1), heights=c(1,1))
plot(PE_freq$X..Coverage[2:100],PE_freq$Count[2:100], type="l", col="blue", lty=1, xlab="Coverage", ylab="Frequency")
lines(ALL_reads$X..Coverage[2:100],ALL_reads$Count[2:100], type="l", col="black")
lines(MP_ALL_Reads$X..Coverage[2:100],MP_ALL_Reads$Count[2:100], type="l", col="red")
# ALL
sumCoverage_all <- sum(as.numeric( ALL_reads[0:8052,1] * ALL_reads[0:8052,2]))
abline(v=sumCoverage_all/genomeSize,lty=2,col="black")
sumCoverage_all/genomeSize
# PE
sumCoverage_PE <- sum(as.numeric( PE_freq[0:8052,1] * PE_freq[0:8052,2]))
abline(v=sumCoverage_PE/genomeSize,lty=2,col="blue")
sumCoverage_PE/genomeSize
# MP
sumCoverage_MP <- sum(as.numeric( MP_ALL_Reads[0:8022,1] * MP_ALL_Reads[0:8022,2]))
abline(v=sumCoverage_MP/genomeSize,lty=2,col="red")
sumCoverage_MP/genomeSize
legend(
  "topright", ## POSITION 
  c("All reads coverage","Mean coverage", "PE coverage", "Mean Coverage PE", "MP coverage", "Mean Coverage MP"), # puts text in the legend 
  lty=c(1,2,1,2,1,2),               # gives the legend appropriate symbols (lines)
  lwd=c(3,3,3,3,3,3), ## width
  col=c("black","black","blue","blue","red","red") # gives the legend lines the correct color
)

