DATA <- read.table(file="HCR/HCR_annotation_summary_2.5x.txt", sep="\t", header = TRUE)

colnames(DATA)
rownames(DATA)

DATAcol <- DATA$Type
rownames(DATA) <- DATAcol

DATA
DATA$Type <- NULL
DATA$Average <- NULL 
DATA

library(RColorBrewer)
coul = brewer.pal(8, "Spectral") 

#Transform this data in %
data_percentage=apply(DATA, 2, function(x){x*100/sum(x,na.rm=T)})

data_percentage

# Make a stacked barplot--> it will be in %!
barplot(data_percentage, col=coul , border="white", xlab="%", horiz = TRUE)
## legend
legend("topright", legend = DATAcol, fill = coul)



DATA_5x <- read.table(file="HCR/HCR_annotation_summary_5x.txt", sep="\t", header = TRUE)
colnames(DATA_5x)
rownames(DATA_5x)

DATA_5xcol <- DATA_5x$Type
rownames(DATA_5x) <- DATA_5xcol

DATA_5x
DATA_5x$Type <- NULL
DATA_5x$Average <- NULL 
DATA_5x

#Transform this data in %
data_percentage_5x=apply(DATA_5x, 2, function(x){x*100/sum(x,na.rm=T)})

data_percentage_5x

# Make a stacked barplot--> it will be in %!
barplot(data_percentage_5x, col=coul , border="white", xlab="%", horiz = TRUE)
## legend
legend("topright", legend = DATA_5xcol, fill = coul)
