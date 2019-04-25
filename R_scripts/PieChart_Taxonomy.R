# 3D Exploded Pie Chart
library(plotrix)
## data
taxa <- read.table("all_ids-subset-Annotation_sort.txt")
label <- taxa$V1
slices_taxa <- taxa$V2
pct_taxa <- round(slices_taxa/sum(slices_taxa)*100,digits = 2)
label <- paste(label, pct_taxa) # add percents to labels 
label <- paste(label,"%",sep="") # ad % to labels 
pie3D(slices_taxa,labels=label, 
      explode=0.2, 
      radius=1, 
      labelcex = 1.5, 
      labelrad = 1.1,
      height = 0.05,
      theta = 1.1,
      shade = 0.5,
      start=1.5)
