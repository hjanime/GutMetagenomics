## this script will generate visuale to cohort for intelligent
## selection of test subjects.
install.packages("ggplot2")

library( ggplot2 )

CohortStats <- read.table("~/bioinf/GutMetagenomics/CohortStats.txt", header=T, quote="\"")
cohort_Contig_Stats <- read.table("~/bioinf/GutMetagenomics/cohort_Contig_Stats.txt", header=T, quote="\"")
cohort_read_stats <- read.table("~/bioinf/GutMetagenomics/cohort_read_stats.txt", header=T, quote="\"")
Cohort_ORF_stats <- read.table("~/bioinf/GutMetagenomics/Cohort_ORF_stats.txt", header=T, quote="\"")
CohortStats <- merge(CohortStats, cohort_Contig_Stats)
CohortStats <- merge(CohortStats, cohort_read_stats)
CohortStats <- merge(CohortStats, Cohort_ORF_stats)

plot <- qplot(BMI, data = CohortStats, geom = "histogram", binwidth = 1, main= "BMI histogram", xlab="BMI\nbinwidth = 1")
ggsave(filename = "BMI_hist_binwidth_1.pdf", plot = plot, width = 7 , height = 7)

qplot(BMI, data = CohortStats, geom = "density", main= "BMI density plot", xlab="BMI" )


qplot( Age, BMI, data = CohortStats , colour = Gender, main = "Age Vs BMI plot\ncolored by gender")
ggsave(filename = "Age_vs_BMI_coloredBy_Sex.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = CohortStats , colour = Country ,shape= Gender, main = "Age Vs BMI plot\ncolored by country")
ggsave(filename = "Age_vs_BMI_coloredBy_Country.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = CohortStats , colour = IBD ,shape= Gender, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Age_vs_BMI_coloredBy_IBD_shape_Gender.pdf", width = 7 , height = 7)

qplot( Age, BMI, data = CohortStats , colour = IBD ,shape= Country, main = "Age Vs BMI plot\ncolored by IBD status")
ggsave(filename = "Age_vs_BMI_coloredBy_IBD_shape_Country.pdf", width = 7 , height = 7)
