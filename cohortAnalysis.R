## this script will generate visuale to cohort for intelligent
## selection of test subjects.
install.packages("ggplot2")
install.packages("plyr")

library( ggplot2 )

CohortStats <- read.table("~/bioinf/GutMetagenomics/CohortStats.txt", header=T, quote="\"")
cohort_Contig_Stats <- read.table("~/bioinf/GutMetagenomics/cohort_Contig_Stats.txt", header=T, quote="\"")
cohort_read_stats <- read.table("~/bioinf/GutMetagenomics/cohort_read_stats.txt", header=T, quote="\"")
Cohort_ORF_stats <- read.table("~/bioinf/GutMetagenomics/Cohort_ORF_stats.txt", header=T, quote="\"")
CohortStats <- merge(CohortStats, cohort_Contig_Stats)
CohortStats <- merge(CohortStats, cohort_read_stats)
CohortStats <- merge(CohortStats, Cohort_ORF_stats)

qplot(BMI, data = CohortStats, geom = "histogram", binwidth = 1, main= "BMI histogram", xlab="BMI\nbinwidth = 1")
ggsave(filename = "BMI_hist_binwidth_1.pdf",  width = 7 , height = 7)


qplot(BMI, data = CohortStats, geom = "density", main= "BMI density plot", xlab="BMI" )
ggsave(filename = "BMI_dens.pdf",  width = 7 , height = 7)

qplot(BMI, data = CohortStats, geom = "density", main= "BMI density plot", xlab="BMI", colour=Country )
ggsave(filename = "BMI_dens_coloredBy_Country.pdf",  width = 7 , height = 7)

qplot(BMI, data = CohortStats, geom = "density", main= "BMI density plot", xlab="BMI", colour=IBD )
ggsave(filename = "BMI_dens_coloredBy_IBD.pdf",  width = 7 , height = 7)

qplot(BMI, data = CohortStats, geom = "density", main= "BMI density plot", xlab="BMI", colour=Gender )
ggsave(filename = "BMI_dens_coloredBy_Gender.pdf",  width = 7 , height = 7)


hp <- ggplot(CohortStats, aes(x=BMI)) +geom_histogram(binwidth=2)

hp + facet_grid(Gender ~ Country)
ggsave(filename = "BMI_facet_Gender_Country.pdf",  width = 7 , height = 7)

hp + facet_grid(Gender ~ IBD)
ggsave(filename = "BMI_facet_Gender_IBD.pdf",  width = 7 , height = 7)

hp + facet_grid(Gender ~ IBD ~ Country)
ggsave(filename = "BMI_facet_Gender_IBD_Country.pdf",  width = 7 , height = 7)

hp + facet_grid(Country ~ IBD)
ggsave(filename = "BMI_facet_IBD_Country.pdf",  width = 7 , height = 7)


qplot( Age, BMI, data = CohortStats , colour = Gender, main = "Age Vs BMI plot\ncolored by gender")
ggsave(filename = "Age_vs_BMI_coloredBy_Sex.pdf", width = 7 , height = 7)

BMIgroups <- cut ( CohortStats$BMI , 5)

qplot( Age, BMI, data = CohortStats , colour = Country ,shape= Gender, main = "Age Vs BMI plot\ncolored by country")
ggsave(filename = "Age_vs_BMI_coloredBy_Country.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = CohortStats , colour = IBD ,shape= Gender, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Age_vs_BMI_coloredBy_IBD_shape_Gender.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = CohortStats , colour = IBD ,shape= Country, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Age_vs_BMI_coloredBy_IBD_shape_Country.pdf", width = 7 , height = 7)

bmiRange <- range(CohortStats$BMI)

BMIgroups <- cut ( CohortStats$BMI , 5)
CohortGroups <- split(CohortStats, BMIgroups)

BMI1Group<-do.call(rbind.data.frame, CohortGroups[1])
BMI2Group<- do.call(rbind.data.frame, CohortGroups[2])
BMI3Group<- do.call(rbind.data.frame, CohortGroups[3])
BMI4Group<- do.call(rbind.data.frame, CohortGroups[4])
BMI5Group<- do.call(rbind.data.frame, CohortGroups[5])

BMI1Samp <- BMI1Group[sample(nrow(BMI1Group),10),]
BMI2Samp <- BMI2Group[sample(nrow(BMI2Group),10),]
BMI3Samp <- BMI3Group[sample(nrow(BMI3Group),10),]
BMI4Samp <- BMI4Group[sample(nrow(BMI4Group),11),]
BMI5Samp <- BMI5Group[sample(nrow(BMI5Group),9),]
StudySample = BMI1Samp
StudySample <- rbind(StudySample, BMI2Samp)
StudySample <- rbind(StudySample, BMI3Samp)
StudySample <- rbind(StudySample, BMI4Samp)
StudySample <- rbind(StudySample, BMI5Samp)


 qplot(BMI, data = StudySample, geom = "histogram", binwidth = 1, main= "BMI histogram", xlab="BMI\nbinwidth = 1")
ggsave(filename = "Sample_BMI_hist_binwidth_1.pdf", width = 7 , height = 7)

qplot(BMI, data = StudySample, geom = "density", main= "BMI density plot", xlab="BMI" )


qplot( Age, BMI, data = StudySample , colour = Gender, main = "Age Vs BMI plot\ncolored by gender")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_Sex.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = Country ,shape= Gender, main = "Age Vs BMI plot\ncolored by country")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_Country.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = IBD ,shape= Gender, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_IBD_shape_Gender.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = IBD ,shape= Country, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_IBD_shape_Country.pdf", width = 7 , height = 7)

DenmarkSample <- CohortStats[ CohortStats$Country=="Denmark", ]
DMCut <- cut( DenmarkSample$BMI,5 )
df<- data.frame(DenmarkSample, DMCut)

DMGroups <- split(df, df$DMCut)

BMI1Group<-do.call(rbind.data.frame, DMGroups[1])
BMI2Group<- do.call(rbind.data.frame, DMGroups[2])
BMI3Group<- do.call(rbind.data.frame, DMGroups[3])
BMI4Group<- do.call(rbind.data.frame, DMGroups[4])
BMI5Group<- do.call(rbind.data.frame, DMGroups[5])

BMI1Samp <- BMI1Group[sample(nrow(BMI1Group),10),]
BMI2Samp <- BMI2Group[sample(nrow(BMI2Group),10),]
BMI3Samp <- BMI3Group[sample(nrow(BMI3Group),10),]
BMI4Samp <- BMI4Group[sample(nrow(BMI4Group),11),]
BMI5Samp <- BMI5Group[sample(nrow(BMI5Group),9),]

StudySample = BMI1Samp
StudySample <- rbind(StudySample, BMI2Samp)
StudySample <- rbind(StudySample, BMI3Samp)
StudySample <- rbind(StudySample, BMI4Samp)
StudySample <- rbind(StudySample, BMI5Samp)

qplot(BMI, data = StudySample, geom = "histogram", binwidth = 1, main= "BMI histogram", xlab="BMI\nbinwidth = 1")
ggsave(filename = "Sample_BMI_hist_binwidth_1.pdf", width = 7 , height = 7)

ggplot(StudySample, aes(x=BMI, fill=Gender)) + geom_histogram(binwidth= 1, alpha=.5, position = "identity")
ggsave(filename= "Sample_BMI_hist_gender.pdf", width = 7 , height = 7)

qplot(BMI, data = StudySample, geom = "density", main= "BMI density plot", xlab="BMI" )
ggsave(filename = "Sample_BMI_dens.pdf", width = 7 , height = 7)

qplot(BMI, data = StudySample, geom = "density", main= "BMI density plot", xlab="BMI" , colour = Gender)
ggsave(filename = "Sample_BMI_dens_coloredBy_Gender", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = Gender, main = "Age Vs BMI plot\ncolored by gender")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_Sex.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = Country ,shape= Gender, main = "Age Vs BMI plot\ncolored by country")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_Country.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = IBD ,shape= Gender, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_IBD_shape_Gender.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = StudySample , colour = IBD ,shape= Country, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Sample_Age_vs_BMI_coloredBy_IBD_shape_Country.pdf", width = 7 , height = 7)