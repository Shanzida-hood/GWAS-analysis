#Author :Shanzida Jahan Siddique
# Date :04/02/2021
# Goal :To create QQ plot and Manhaton plot for 1-22 chromosomes for Metal Data by  following https://www.r-graph-gallery.com/101_Manhattan_plot.html and 
# https://cran.r-project.org/web/packages/qqman/vignettes/qqman.html
# set working directory 
getwd()
# load the dataset 
metal_chr1.df<-read.table ("/users/sjahansi/metal_result/METAANALYSIS_inputfilechr1_1.tbl",header=TRUE,stringsAsFactors = FALSE)
# view the dataset
View (metal_chr1.df)
# View the structure of the dataset
str(metal_chr1.df)
# view the head of the dataset
head(metal_chr1.df)
# view the tail of the dataset 
tail(metal_chr1.df)

# Add CHR column in the dataset
metal_chr1.df$CHR <- 1
lapply(metal_chr1.df$CHR,as.numeric)
View (metal_chr1.df)
str (metal_chr1.df)
# Here to run manhattan plot I need to CHR,BP,SNP and P value column.o run Manhattan plot I need the columns for
#chr="CHR", bp="BP", snp="SNP", p="P" )
#but files from the metal don’t have separate column for CHR,SNP and BP. Therefore,I have added a separate column for CHR 1.   metal_chr1.df$CHR <- 1.Pls let me know what I can do for BP and SNP Column.
#Because all information are in the first column Markername.so according to Alison I need to duplicate MARKER name column.and make three column from that.One is for  CHR,one is for BP and another is for SNP name.SNPname would be marker 
## Duplicate Markername Column 
# https://www.tutorialspoint.com/how-to-create-a-duplicate-column-in-an-r-data-frame-with-different-name
metal_chr1.df$BP<-metal_chr1.df$MarkerName
View (metal_chr1.df)
# for this need to install tidyverse package 
install.packages("tidyverse")
library(tidyverse)
# # rename the Markername column into SNP https://www.datanovia.com/en/lessons/rename-data-frame-columns-in-r/#:~:text=144%20more%20rows-,Renaming%20columns%20with%20R%20base%20functions,column%20names%20where%20name%20%3D%20Sepal.
metal_chr1.df<-metal_chr1.df %>% 
  rename (SNP = MarkerName,P=P.value)
View(metal_chr1.df)

# split the BP column.Keep only position number.Not need to keep other information.For this I need to install install.packages("tidyr")
#https://statisticsglobe.com/split-data-frame-variable-into-multiple-columns-in-r
library("tidyr")
metal_chr1.df<-metal_chr1.df %>%
  separate(BP, c("C", "BP","col1","col2"), ":")
View(metal_chr1.df)
# delete col1 and clo2 columns from the datasets https://www.listendata.com/2015/06/r-keep-drop-columns-from-data-frame.html#:~:text=The%20most%20easiest%20way%20to,when%20using%20subset()%20function.
final_metal_chr1.df = subset(metal_chr1.df, select = -c(C,col1,col2) )
View (final_metal_chr1.df)
final_metal_chr1.df$BP <- as.numeric(as.character(final_metal_chr1.df$BP))
# https://www.tutorialspoint.com/how-to-convert-more-than-one-column-in-r-data-frame-to-from-integer-to-numeric-in-a-single-line-code
#
# View the structure of the dataset
str(final_metal_chr1.df)
# view the head of the dataset
head(final_metal_chr1.df)
# view the tail of the dataset 
tail(final_metal_chr1.df)
# install package 
install.packages("qqman")
# Load Library
library(qqman)
# Create basic Manhattan plot 
manhattan(final_metal_chr1.df, chr="CHR", bp="BP", snp="SNP", p="P" )
# Create Manhattan plot with parameters
manhattan(logistic_new.df, main = "Manhattan Plot", ylim = c(0, 10), cex = 0.6, 
          cex.axis = 0.9, col = c("blue4", "orange3"), suggestiveline = F, genomewideline = F, 
          chrlabs = c(1:20, "P", "Q"))
# look at a single chromosome:
manhattan(subset(final_metal_chr1.df, CHR == 1),ylim=c(0,12))
# The 100 SNPs we're highlighting here are in a character vector called snpsOfInterest. 
#You'll get a warning if you try to highlight SNPs that don't exist.

# A list of SNP of interest is provided with the library:
str(snpsOfInterest)
# Let's highlight them, with a bit of customization on the plot
manhattan(logistic_new.df, highlight = snpsOfInterest,ylim=c(0,12))
## Annotate the name of the SNP of interest: the ones with a high pvalue. You can automatically annotate them using the annotatePval argument:

manhattan(logistic_new.df, annotatePval = 0.01,ylim=c(0,12))

qq(final_metal_chr1.df$P)
manhattan(subset(final_metal_chr1.df, CHR == 1))
lapply(final_metal_chr1.df$CHR,as.numeric)
str(final_metal_chr1.df)
manhattan(final_metal_chr1.df, highlight = snpsOfInterest)
# ##annotate You probably want to know the name of the SNP of interest: the ones with a high pvalue. You can automatically annotate them using the annotatePval argument:
manhattan(final_metal_chr1.df, annotatePval = 0.01)
# 
manhattan(final_metal_chr1.df, p = "Zscore", logp = FALSE, ylab = "Z-score", genomewideline = FALSE, 
          suggestiveline = FALSE, main = "Manhattan plot of Z-scores")
str(snpsOfInterest)
manhattan(final_metal_chr1.df, highlight = snpsOfInterest)

