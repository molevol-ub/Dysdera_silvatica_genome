## plot eAED
## sh ./Functional_Genome_Annotation/scripts/get_mean_eAED.sh maker_proteins.fasta out
setwd("/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/")


## Frequency function
get_Freq <- function(table2check) {
  
  breaks = seq(0, 1, by=0.02) 
  AED_table <- table(table2check)
  AED_frame <- as.data.frame(AED_table)
  AED.cut = cut(table2check$V2, breaks, right=FALSE) 
  AED.freq = table(AED.cut)
  cumfreq = c(0, cumsum(AED.freq)/sum(AED.freq)) 
  
  return(cumfreq)  
}

## training Rounds
## file_train_R1
file2check_R1 <- "R_scripts/AED_statistics/AED_stats_R1_train.txt"
AED_R1 <- read.table(file2check_R1)
mean_AED_R1 = mean(AED_R1$V2)
median_AED_R1 = median(AED_R1$V2)
cumfreq_AED_R1 <- get_Freq(AED_R1)

## file_train_R2
file2check_R2 <- "R_scripts/AED_statistics/AED_stats_R2_train.txt"
AED_R2 <- read.table(file2check_R2)
mean_AED_R2 = mean(AED_R2$V2)
median_AED_R2 = median(AED_R2$V2)
cumfreq_AED_R2 <- get_Freq(AED_R2)

## Final annotation
## file_train_R1
file2check_F1 <- "R_scripts/AED_statistics/AED_stats_R1_final.txt"
AED_F1 <- read.table(file2check_F1)
mean_AED_F1 = mean(AED_F1$V2)
median_AED_F1 = median(AED_F1$V2)
cumfreq_AED_F1 <- get_Freq(AED_F1)

## file_train_R1
#file2check_F2 <- "R_scripts/AED_statistics/AED_stats_R2_final.txt"
#AED_F2 <- read.table(file2check_F2)
#mean_AED_F2 = mean(AED_F2$V2)
#median_AED_F2 = median(AED_F2$V2)
#cumfreq_AED_F2 <- get_Freq(AED_F2)

#################
## set plot
breaks = seq(0, 1, by=0.02) 
plot(breaks,cumfreq_AED_R1,ylab="Cummulative Fraction of Annotation", xlab="AED value", lty=2, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(h=0.5, lty=4, col="grey")
legend(
  "bottomright", ## POSITION 
  c("50%", "","R1", "R2", "","F1","F2"), # puts text in the legend 
  lty=c(4,0,2,2,0,1,1),               # gives the legend appropriate symbols (lines)
  lwd=c(2), ## width
  cex = 1.3,
  col=c("grey","","deepskyblue","dodgerblue","","chartreuse","darkolivegreen"
  ) # gives the legend lines the correct color
)
lines(breaks,cumfreq_AED_R2,type="l",lty=2,col="dodgerblue")
lines(breaks,cumfreq_AED_F1,type="l",lty=1,col="chartreuse")
#lines(breaks,cumfreq_AED_F2,type="l",lty=1,col="darkolivegreen")

###########
## EXTRA
###########
## Non annotated proteins
## file_NA
file2check_NA <- "R_scripts/AED_statistics/AED_stats_NA.txt"
AED_NA <- read.table(file2check_NA)
mean_AED_NA = mean(AED_NA$V2)
median_AED_NA = median(AED_NA$V2)
cumfreq_AED_NA <- get_Freq(AED_NA)

plot(breaks,cumfreq_AED_NA,ylab="Cummulative Fraction of Annotation",xlab="AED value")
lines(breaks,cumfreq0_non_annotated)

legend(
  "bottomright", ## POSITION 
  c("AED", "mean"), # puts text in the legend 
  lty=c(1,2),               # gives the legend appropriate symbols (lines)
  lwd=c(3,3), ## width
  col=c("black","orange") # gives the legend lines the correct color
)

