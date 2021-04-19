
## plot example HIC (High coverage islands)
## coverage information generated using SAMtools
coverage <- read.table(file="example_plot_HCR.txt",header = FALSE) 
plot(coverage$V2,coverage$V3,type="l", xlab="Length (bp)", ylab="Coverage", cex.lab=1.5, cex.axis=1.5, cex.main=1.5, ylim=c(0, 300))
abline(h=30,col="red",lty=3,lwd=2.5)
abline(h=30*5,col="blue",lty=3,lwd=2.5)
abline(h=30*2.5,col="green",lty=3,lwd=2.5)