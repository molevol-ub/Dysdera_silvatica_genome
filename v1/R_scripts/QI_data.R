## Quality Index metric
QI_unique_Dsil <- read.csv(file="AED/QI_split_unique_proteins-Dsil.txt",header = FALSE, sep=",") 
QI_all_Dsil <- read.csv(file="AED/QI_split_annotation.all.maker.proteins.txt",header = FALSE, sep=",") 
QI_annotation_Dsil <- read.csv(file="QI_split_annotation_Dsilvatica-proteins_InterPro.txt",header = FALSE, sep=",") 

column_names <- c("gene", "5_UTR", "splice_mRNA", "exon_match_mRNA", "exon_overlap_mRNA", "splice_abinitio", "exons_abinitio", "num_exons", "3_UTR", "length_prot")

## add column names
colnames(QI_all_Dsil) <- column_names
colnames(QI_annotation_Dsil) <- column_names
colnames(QI_unique_Dsil) <- column_names

mean(QI_all_Dsil$length_prot)
mean(QI_annotation_Dsil$length_prot)
mean(QI_unique_Dsil$length_prot)

mean(QI_all_Dsil$num_exons)
mean(QI_annotation_Dsil$num_exons)
mean(QI_unique_Dsil$num_exons)

mean(QI_all_Dsil$`5_UTR`)
mean(QI_annotation_Dsil$`5_UTR`)
mean(QI_unique_Dsil$`5_UTR`)

mean(QI_all_Dsil$`3_UTR`)
mean(QI_annotation_Dsil$`3_UTR`)
mean(QI_unique_Dsil$`3_UTR`)


get_Freq <- function(table2check) {
  
  breaks = seq(0, 1, by=0.02) 
  QI.cut = cut(table2check, breaks, right=FALSE) 
  QI.freq = table(QI.cut)
  cumfreq = c(0, cumsum(QI.freq)/sum(QI.freq)) 
  
  return(cumfreq)  
}

mean(QI_all_Dsil$exon_match_mRNA)
mean(QI_annotation_Dsil$exon_match_mRNA)
mean(QI_unique_Dsil$exon_match_mRNA)


exon_match_QI_all_Dsil_freq <- get_Freq(QI_all_Dsil$exon_match_mRNA)
exon_match_QI_annot_Dsil_freq <- get_Freq(QI_annotation_Dsil$exon_match_mRNA)
exon_match_QI_uniq_Dsil_freq <- get_Freq(QI_unique_Dsil$exon_match_mRNA)

exon_overlap_QI_all_Dsil_freq <- get_Freq(QI_all_Dsil$exon_overlap_mRNA)
exon_overlap_QI_annot_Dsil_freq <- get_Freq(QI_annotation_Dsil$exon_overlap_mRNA)
exon_overlap_QI_uniq_Dsil_freq <- get_Freq(QI_unique_Dsil$exon_overlap_mRNA)

exon_abinitio_QI_all_Dsil_freq <- get_Freq(QI_all_Dsil$exons_abinitio)
exon_abinitio_QI_annot_Dsil_freq <- get_Freq(QI_annotation_Dsil$exons_abinitio)
exon_abinitio_QI_uniq_Dsil_freq <- get_Freq(QI_unique_Dsil$exons_abinitio)

breaks = seq(0, 1, by=0.02) 
plot(breaks,exon_match_QI_all_Dsil_freq,ylab="Frequency", xlab="% exon match", lwd = 3, lty=3, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(breaks,exon_match_QI_annot_Dsil_freq,type="l", lwd=3,lty=3,col="dodgerblue")
lines(breaks,exon_match_QI_uniq_Dsil_freq,type="l", lwd=3,lty=3,col="red")

lines(breaks,exon_overlap_QI_all_Dsil_freq,type="l", lwd=3,lty=1,col="deepskyblue")
lines(breaks,exon_overlap_QI_annot_Dsil_freq,type="l", lwd=3,lty=1,col="dodgerblue")
lines(breaks,exon_overlap_QI_uniq_Dsil_freq,type="l", lwd=3,lty=1,col="red")


## splice sites
splice_mRNA_QI_all_Dsil_freq <- get_Freq(QI_all_Dsil$splice_mRNA)
splice_mRNA_QI_annot_Dsil_freq <- get_Freq(QI_annotation_Dsil$splice_mRNA)
splice_mRNA_QI_uniq_Dsil_freq <- get_Freq(QI_unique_Dsil$splice_mRNA)

## splice sites
splice_abinitio_QI_all_Dsil_freq <- get_Freq(QI_all_Dsil$splice_abinitio)
splice_abinitio_QI_annot_Dsil_freq <- get_Freq(QI_annotation_Dsil$splice_abinitio)
splice_abinitio_QI_uniq_Dsil_freq <- get_Freq(QI_unique_Dsil$splice_abinitio)

dev.off()
par(mfrow = c(1, 2)) 
### mRNA
breaks = seq(0, 1, by=0.02) 
plot(breaks,splice_mRNA_QI_all_Dsil_freq,ylab="Frequency", xlab="% match", lwd = 3, lty=3, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(breaks,splice_mRNA_QI_annot_Dsil_freq,type="l", lwd=3,lty=3,col="chartreuse4")
lines(breaks,splice_mRNA_QI_uniq_Dsil_freq,type="l", lwd=3,lty=3,col="red")
abline(h=0.5, lty=4, col="grey")
legend(
  "bottomright", ## POSITION 
  #c("50%", "","R1", "R2", "","F1","F2","","Sub.Length", "Sub.InterPro", "Sub.Both", "v1"), # puts text in the legend 
  c("50%", "","All", "Functional", "Unique","","Splice site","Exon"), # puts text in the legend 
  lty=c(4,0,1,1,1,0,3,1),               # gives the legend appropriate symbols (lines)
  lwd=c(4,0,4,4,4,0,3,3), ## width
  cex = 1.3,
  col=c("grey","","deepskyblue","chartreuse4","red","","black","black") # gives the legend lines the correct color
)
lines(breaks,exon_match_QI_all_Dsil_freq,type="l", lwd=3,lty=1,col="deepskyblue")
lines(breaks,exon_match_QI_annot_Dsil_freq,type="l", lwd=3,lty=1,col="chartreuse4")
lines(breaks,exon_match_QI_uniq_Dsil_freq,type="l", lwd=3,lty=1,col="red")

## abinitio
breaks = seq(0, 1, by=0.02) 
plot(breaks,splice_abinitio_QI_all_Dsil_freq,ylab="Frequency", xlab="% match", lwd = 3, lty=3, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(breaks,splice_abinitio_QI_annot_Dsil_freq,type="l", lwd=3,lty=3,col="chartreuse4")
lines(breaks,splice_abinitio_QI_uniq_Dsil_freq,type="l", lwd=3,lty=3,col="red")
abline(h=0.5, lty=4, col="grey")
lines(breaks,exon_abinitio_QI_all_Dsil_freq,type="l", lwd=3,lty=1,col="deepskyblue")
lines(breaks,exon_abinitio_QI_annot_Dsil_freq,type="l", lwd=3,lty=1,col="chartreuse4")
lines(breaks,exon_abinitio_QI_uniq_Dsil_freq,type="l", lwd=3,lty=1,col="red")



dev.off()
### mRNA
breaks = seq(0, 1, by=0.02) 
plot(breaks,splice_mRNA_QI_all_Dsil_freq,ylab="Frequency", xlab="% match", lwd = 3, lty=3, type="l",col="deepskyblue", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
lines(breaks,splice_mRNA_QI_annot_Dsil_freq,type="l", lwd=3,lty=3,col="chartreuse4")
lines(breaks,splice_mRNA_QI_uniq_Dsil_freq,type="l", lwd=3,lty=3,col="red")
lines(breaks,exon_match_QI_all_Dsil_freq,type="l", lwd=3,lty=1,col="deepskyblue")
lines(breaks,exon_match_QI_annot_Dsil_freq,type="l", lwd=3,lty=1,col="chartreuse4")
lines(breaks,exon_match_QI_uniq_Dsil_freq,type="l", lwd=3,lty=1,col="red")

## abinitio
lines(breaks,splice_abinitio_QI_all_Dsil_freq,type="l", lwd=3,lty=3,col="orange")
lines(breaks,splice_abinitio_QI_annot_Dsil_freq,type="l", lwd=3,lty=3,col="black")
lines(breaks,splice_abinitio_QI_uniq_Dsil_freq,type="l", lwd=3,lty=3,col="pink")

lines(breaks,exon_abinitio_QI_all_Dsil_freq,type="l", lwd=3,lty=1,col="orange")
lines(breaks,exon_abinitio_QI_annot_Dsil_freq,type="l", lwd=3,lty=1,col="black")
lines(breaks,exon_abinitio_QI_uniq_Dsil_freq,type="l", lwd=3,lty=1,col="pink")

abline(h=0.5, lty=4, col="grey")
legend(
  "bottomright", ## POSITION 
  #c("50%", "","R1", "R2", "","F1","F2","","Sub.Length", "Sub.InterPro", "Sub.Both", "v1"), # puts text in the legend 
  c("50%", "","All", "Functional", "Unique","","Splice site","Exon"), # puts text in the legend 
  lty=c(4,0,1,1,1,1,1,1,0,3,1),               # gives the legend appropriate symbols (lines)
  lwd=c(4,0,4,4,4,4,4,4,0,3,3), ## width
  cex = 1.3,
  col=c("grey","","deepskyblue","chartreuse4","red","orange","black","pink","","black","black") # gives the legend lines the correct color
)