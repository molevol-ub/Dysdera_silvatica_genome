
## plot example HIC (High coverage islands)
## necessary files are under HCI_example folder
setwd("/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/")

## coverage information generated using SAMtools
coverage <- read.table(file="HCI_example/example_coverage_sequence2.txt",header = FALSE) ## v1: position; v2: coverage
plot(coverage$V1,coverage$V2,type="l", xlab="Length (bp)", ylab="Coverage", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(h=30,col="red",lty=3,lwd=2.5)
abline(h=30*5,col="blue",lty=3,lwd=2.5)

