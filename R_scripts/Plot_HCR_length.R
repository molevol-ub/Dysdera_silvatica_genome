##
hist_plot = function(X, COLOR, TITLE, MIN ) {
  ## intra 2.5
  hist(log10(X$V1), breaks = 100,freq = TRUE, col=COLOR,
       main=TITLE,
       xlab="Length (bp)",
       ylab="Counts",
       axes=FALSE,
       cex.lab=1.5, 
       cex.axis=1.5, 
       cex.main=1.5,
       xlim=c(MIN,5)
       #,ylim=c(0,4000)
  )
  mean_= mean(X$V1)
  abline(v=log10(mean_),lty=4,lwd=3)
  
  xbase=10
  xlim=c(MIN,5)
  xbreaks=xlim[1]:xlim[2]
  for(x in xbase^xbreaks) {
    subx <- log(seq(from=x, to=x*xbase, length=xbase) , base=xbase )
    abline(v=subx, col="grey", lwd=0.8,  lty=3)
  }
  axis(side=1, at=xbreaks, labels=format(xbase^xbreaks, scientific=FALSE), tck=0.02, lwd=1)
  axis(side=2)
  
  mean_
  summary(X)
  
}

## load results
intra_25 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_2.5x_coverage.HCI_150.txt")
inter_25 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_2.5x_coverage.HCI_150.txt")
intra_5 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_5x_coverage.HCI_150.txt")
inter_5 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_5x_coverage.HCI_150.txt")

# Set graphical parameter `mfrow`
par(mfrow = c(2, 2)) 
hist_plot(intra_25, "blue", "INTRA 2.5x 150", 0)
hist_plot(inter_25, "red", "INTER 2.5x 150", 0)
hist_plot(intra_5, "blue", "INTRA 5x 150", 0)
hist_plot(inter_5, "red", "INTER 5x 150", 0)

###### intra vs inter 2.5x mean splitted
intra_25_150 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_2.5x_coverage.HCI_150.txt")
intra_25_500 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_2.5x_coverage.HCI_500.txt")
intra_25_1000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_2.5x_coverage.HCI_1000.txt")
intra_25_5000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_2.5x_coverage.HCI_5000.txt")

inter_25_150 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_2.5x_coverage.HCI_150.txt")
inter_25_500 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_2.5x_coverage.HCI_500.txt")
inter_25_1000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_2.5x_coverage.HCI_1000.txt")
inter_25_5000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_2.5x_coverage.HCI_5000.txt")

# Set graphical parameter `mfrow`
dev.off()
par(mfrow = c(4, 2)) 
hist_plot(intra_25_150, "blue", "INTRA 2.5x 150", 2)
hist_plot(inter_25_150, "red", "INTER 2.5x 150", 0)

hist_plot(intra_25_500, "blue", "INTRA 2.5x 500", 2)
hist_plot(inter_25_500, "red", "INTER 2.5x 500", 0)

hist_plot(intra_25_1000, "blue", "INTRA 2.5x 1000", 2)
hist_plot(inter_25_1000, "red", "INTER 2.5x 1000", 0)

hist_plot(intra_25_5000, "blue", "INTRA 2.5x 5000", 2)
hist_plot(inter_25_5000, "red", "INTER 2.5x 5000", 0)


###### intra vs inter 5x mean splitted
intra_5_150 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_5x_coverage.HCI_150.txt")
intra_5_500 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_5x_coverage.HCI_500.txt")
intra_5_1000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_5x_coverage.HCI_1000.txt")
intra_5_5000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/intra_5x_coverage.HCI_5000.txt")

inter_5_150 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_5x_coverage.HCI_150.txt")
inter_5_500 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_5x_coverage.HCI_500.txt")
inter_5_1000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_5x_coverage.HCI_1000.txt")
inter_5_5000 <- read.table(file="/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/R_scripts/HCR/HCR_data/inter_5x_coverage.HCI_5000.txt")

dev.off()
par(mfrow = c(4, 2)) 
hist_plot(intra_5_150, "blue", "INTRA 5x 150", 2)
hist_plot(inter_5_150, "red", "INTER 5x 150", 0)

hist_plot(intra_5_500, "blue", "INTRA 5x 500", 2)
hist_plot(inter_5_500, "red", "INTER 5x 500", 0)

hist_plot(intra_5_1000, "blue", "INTRA 5x 1000", 2)
hist_plot(inter_5_1000, "red", "INTER 5x 1000", 0)

hist_plot(intra_5_5000, "blue", "INTRA 5x 5000", 2)
hist_plot(inter_5_5000, "red", "INTER 5x 5000", 0)
