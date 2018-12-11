## plot coverage repeats
## necessary files are under Pacbio_repeats folder

## plot example pacbio
## coverage information generated using SAMtools
coverage <- read.table(file="example_coverage_read_m160616_014904_42244_c101006422550000001823230309161656_s1_p0_9997.txt",header = FALSE)
plot(coverage$V1,coverage$V2,type="l", xlab="Length (bp)", ylab="Coverage", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
abline(h=36.7,col="red",lty=3,lwd=2.5)
abline(h=36.7*2.5,col="blue",lty=3,lwd=2.5)

## file generated using 
#id length_seq total_repeats keys INTER_start INTER_end INTER_gap intra_start intra_end intra_gap
repeat_table <- read.table("Pacbio_CSS_PE.filtered.plot")
id <- repeat_table$V1
estimate_mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

INTER_start <- repeat_table$V5
INTER_end <- repeat_table$V6
INTER_gap <- repeat_table$V7
intra_start <- repeat_table$V8
intra_end <- repeat_table$V9
intra_gap <- repeat_table$V10
mean_intraGap = mean(intra_gap)
mean_interGap = mean(INTER_gap) 

## INTRA
hist(intra_gap,breaks = 100,freq = TRUE,col="red",
     main="",
     xlab="Length (bp)",
     cex.lab=1.5, cex.axis=1.5, cex.main=1.5,
     ylab="Frequency"
)
abline(v=mean_intraGap,lty=3,lwd=1.5)
intra_gap
max(intra_gap)
min(intra_gap)
mean_intraGap
range(intra_gap)
quantile(intra_gap)
quantile(intra_gap, prob = seq(0, 1, length = 11), type = 5)
median(intra_gap)
sd(intra_gap) #standard deviation
var(intra_gap) #variance
estimate_mode(intra_gap)
sum(intra_gap)

## Inter
max(INTER_gap)
mean_interGap
hist(INTER_gap,breaks = 100,freq = TRUE,col="blue",
     main="",
     xlab="Length (bp)",
     cex.lab=1.5, cex.axis=1.5, cex.main=1.5,
     ylab="Frequency"
)
abline(v=mean_interGap,lty=3,lwd=1.5)
max(INTER_gap)
min(INTER_gap)
mean_interGap
range(INTER_gap)
quantile(INTER_gap)
quantile(INTER_gap, prob = seq(0, 1, length = 11), type = 5)
median(INTER_gap)
sd(INTER_gap) #standard deviation
var(INTER_gap) #variance
estimate_mode(INTER_gap)
