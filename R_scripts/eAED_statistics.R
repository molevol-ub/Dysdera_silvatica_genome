## plot eAED
## grep '>' *maker.proteins.fasta | awk '{print $1":"$4}' | perl -ne '@array=split(":", $_); @name=split("-",$array[0]);print $name[1]."\t".$array[2];' > eAED_statistics*
setwd("/Users/jfsh/GIT_REPOS/Dysdera_silvatica_genome/")

## training Rounds
breaks = seq(0, 1, by=0.02) 
eAED_R1 <- read.table("R_scripts/eAED_files/eAED_statistics_contigs_R1_values.txt")
eAED_R1_table <- table(eAED_R1)
eAED_R1_frame <- as.data.frame(eAED_R1_table)
eAED_R1.cut = cut(eAED_R1$V1, breaks, right=FALSE) 
eAED_R1.freq = table(eAED_R1.cut)
cumfreq0_R1 = c(0, cumsum(eAED_R1.freq)/sum(eAED_R1.freq)) 

eAED_R2 <- read.table("R_scripts/eAED_files/eAED_statistics_contigs_R2_values.txt")
eAED_R2_table <- table(eAED_R2)
eAED_R2_frame <- as.data.frame(eAED_R2_table)
eAED_R2.cut = cut(eAED_R2$V1, breaks, right=FALSE) 
eAED_R2.freq = table(eAED_R2.cut)
cumfreq0_R2 = c(0, cumsum(eAED_R2.freq)/sum(eAED_R2.freq)) 

eAED_R3 <- read.table("R_scripts/eAED_files/eAED_statistics_contigs_R3_values.txt")
eAED_R3_table <- table(eAED_R3)
eAED_R3_frame <- as.data.frame(eAED_R3_table)
eAED_R3.cut = cut(eAED_R3$V1, breaks, right=FALSE) 
eAED_R3.freq = table(eAED_R3.cut)
cumfreq0_R3 = c(0, cumsum(eAED_R3.freq)/sum(eAED_R3.freq)) 


## Final annotation
eAED_first <- read.table("R_scripts/eAED_files/first_eAED_value.txt")
eAED_first_table <- table(eAED_first)
eAED_final_frame <- as.data.frame(eAED_first_table)
eAED_first.cut = cut(eAED_first$V1, breaks, right=FALSE) 
eAED_first.freq = table(eAED_first.cut)
cumfreq0_first = c(0, cumsum(eAED_first.freq)/sum(eAED_first.freq)) 

eAED_second <- read.table("R_scripts/eAED_files/second_eAED_value.txt")
eAED_second_table <- table(eAED_second)
eAED_second_frame <- as.data.frame(eAED_second_table)
eAED_second.cut = cut(eAED_second$V1, breaks, right=FALSE) 
eAED_second.freq = table(eAED_second.cut)
cumfreq0_second = c(0, cumsum(eAED_second.freq)/sum(eAED_second.freq)) 

eAED_third <- read.table("R_scripts/eAED_files/third_eAED_value.txt")
eAED_third_table <- table(eAED_third)
eAED_third_frame <- as.data.frame(eAED_third_table)
eAED_third.cut = cut(eAED_third$V1, breaks, right=FALSE) 
eAED_third.freq = table(eAED_third.cut)
cumfreq0_third = c(0, cumsum(eAED_third.freq)/sum(eAED_third.freq))

## TR1
mean_eAED_TR1 = mean(eAED_R1$V1)
median_eAED_TR1 = median(eAED_R1$V1)
## TR2
mean_eAED_TR2 = mean(eAED_R2$V1)
median_eAED_TR2 = median(eAED_R2$V1)
## TR3
mean_eAED_TR3 = mean(eAED_R3$V1)
median_eAED_TR3 = median(eAED_R3$V1)

## FT1
mean_eAED_FT1 = mean(eAED_first$V1)
median_eAED_FT1 = median(eAED_first$V1)
## FT2
mean_eAED_FT2 = mean(eAED_second$V1)
median_eAED_FT2 = median(eAED_second$V1)
## FT3
mean_eAED_FT3 = mean(eAED_third$V1)
median_eAED_FT3 = median(eAED_third$V1)

#################
## set plot
breaks = seq(0, 1, by=0.02) 
plot(breaks,cumfreq0_R1,ylab="Cummulative Fraction of Annotation", xlab="eAED value", lty=2, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(h=0.5, lty=4, col="grey")
legend(
  "bottomright", ## POSITION 
  c("50%", "","TR1", "TR2", "TR3","","FT1","FT2","FT3"), # puts text in the legend 
  lty=c(4,0,2,2,2,0,1,1,1),               # gives the legend appropriate symbols (lines)
  lwd=c(2), ## width
  cex = 1.3,
  col=c("grey","","deepskyblue","dodgerblue","darkslateblue","",
        "chartreuse","chartreuse3","darkolivegreen"
  ) # gives the legend lines the correct color
)
lines(breaks,cumfreq0_R2,type="l",lty=2,col="dodgerblue")
lines(breaks,cumfreq0_R3,type="l",lty=2,col="darkslateblue")
lines(breaks,cumfreq0_first,type="l",lty=1,col="chartreuse")
lines(breaks,cumfreq0_second,type="l",lty=1,col="chartreuse3")
lines(breaks,cumfreq0_third,type="l",lty=1,col="darkolivegreen")


## Non annotated proteins
eAED_non_annotated <- read.table("R_scripts/eAED_files/eAED_statistics_Non-Annotated.txt")
breaks = seq(0, 1, by=0.02) 
eAED_non_annotated_table <- table(eAED_non_annotated)
eAED_non_annotated_frame <- as.data.frame(eAED_non_annotated_table)
eAED_non_annotated.cut = cut(eAED_non_annotated$V1, breaks, right=FALSE) 
eAED_non_annotated.freq = table(eAED_non_annotated.cut)
cumfreq0_non_annotated = c(0, cumsum(eAED_non_annotated.freq)/sum(eAED_non_annotated.freq)) 

plot(breaks,cumfreq0_non_annotated,ylab="Cummulative Fraction of Annotation",xlab="eAED value")
lines(breaks,cumfreq0_non_annotated)

## fiable
# median
median_eAED_non_annotated = median(eAED_non_annotated$V1)
#abline(v=median_eAED_non_annotated, lty=2,col="blue")
median_eAED_non_annotated

# mean
mean_eAED_non_annotated = mean(eAED_non_annotated$V1)
abline(v=mean_eAED_non_annotated,lty=2,col="orange")
abline(h=0.5, lty=4, col="grey")
mean_eAED_non_annotated

legend(
  "bottomright", ## POSITION 
  c("eAED", "mean"), # puts text in the legend 
  lty=c(1,2),               # gives the legend appropriate symbols (lines)
  lwd=c(3,3), ## width
  col=c("black","orange") # gives the legend lines the correct color
)

