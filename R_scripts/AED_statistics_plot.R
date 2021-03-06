## plot eAED
## sh ./Functional_Genome_Annotation/scripts/get_mean_eAED.sh maker_proteins.fasta out
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
file2check_R1 <- "AED/AED_stats_R1_train.txt"
AED_R1 <- read.table(file2check_R1)
mean_AED_R1 = mean(AED_R1$V2)
median_AED_R1 = median(AED_R1$V2)
cumfreq_AED_R1 <- get_Freq(AED_R1)

## file_train_R2
file2check_R2 <- "AED/AED_stats_R2_train.txt"
AED_R2 <- read.table(file2check_R2)
mean_AED_R2 = mean(AED_R2$V2)
median_AED_R2 = median(AED_R2$V2)
cumfreq_AED_R2 <- get_Freq(AED_R2)

## Final annotation
## file_train_R1
file2check_F1 <- "AED/AED_stats_R1_final.txt"
AED_F1 <- read.table(file2check_F1)
mean_AED_F1 = mean(AED_F1$V2)
median_AED_F1 = median(AED_F1$V2)
cumfreq_AED_F1 <- get_Freq(AED_F1)

## file_train_R1
file2check_F2 <- "AED/AED_stats_R2_final.txt"
AED_F2 <- read.table(file2check_F2)
mean_AED_F2 = mean(AED_F2$V2)
median_AED_F2 = median(AED_F2$V2)
cumfreq_AED_F2 <- get_Freq(AED_F2)

mean_AED_F1
mean_AED_F2
mean_AED_R1
mean_AED_R2

## subset proteins >100aa
#file2check_subset_Length <- "R_scripts/AED_statistics/AED_stats_Subset.txt"
#AED_subset_Length <- read.table(file2check_subset_Length)
#mean_AED_subset_Length = mean(AED_subset_Length$V2)
#median_AED_subset_Length = median(AED_subset_Length$V2)
#cumfreq_AED_subset_Length <- get_Freq(AED_subset_Length)

## subset proteins InterPro
file2check_subset_Annot <- "AED/AED_stats_FunctionalAnnotated.txt"
AED_subset_Annot <- read.table(file2check_subset_Annot)
mean_AED_subset_Annot = mean(AED_subset_Annot$V2)
median_AED_subset_Annot = median(AED_subset_Annot$V2)
cumfreq_AED_subset_Annot <- get_Freq(AED_subset_Annot)

## subset uniq Dsilvatica proteins
file2check_subset_uniq <- "AED/AED_unique_Dsil_proteins.txt"
AED_subset_uniq <- read.table(file2check_subset_uniq)
mean_AED_subset_uniq = mean(AED_subset_uniq$V2)
median_AED_subset_uniq = median(AED_subset_uniq$V2)
cumfreq_AED_subset_uniq <- get_Freq(AED_subset_uniq)

#################
## set plot
breaks = seq(0, 1, by=0.02) 
plot(breaks,cumfreq_AED_R1,ylab="Cummulative Fraction of Annotation", xlab="AED value", lwd = 3, lty=3, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(h=0.5, lty=4, col="grey")
legend(
  "bottomright", ## POSITION 
  #c("50%", "","R1", "R2", "","F1","F2","","Sub.Length", "Sub.InterPro", "Sub.Both", "v1"), # puts text in the legend 
  c("50%", "","R1", "R2", "","F1","F2","","Functional", "Unique"), # puts text in the legend 
  lty=c(4,0,3,3,0,1,1,0,4,4),               # gives the legend appropriate symbols (lines)
  lwd=c(3), ## width
  cex = 1.3,
  col=c("grey","","deepskyblue","dodgerblue","","chartreuse","darkolivegreen","", "red", "orange") # gives the legend lines the correct color
)
lines(breaks,cumfreq_AED_R2,type="l", lwd=3,lty=3,col="dodgerblue")
lines(breaks,cumfreq_AED_F1,type="l", lwd=3,lty=1,col="chartreuse")
lines(breaks,cumfreq_AED_F2,type="l", lwd=3,lty=1,col="darkolivegreen")
lines(breaks,cumfreq_AED_subset_InterPro,type="l", lwd=3,lty=4,col="red")
lines(breaks,cumfreq_AED_subset_uniq,type="l", lwd=3,lty=4,col="orange")