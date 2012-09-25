##########################################################
####
####	Code for analysis of Washington data
####
##########################################################

setwd("~/CENTER/SGP/Washington")
library(SGP)
load("Data/Washington_SGP.Rdata")

############################################################
####
####		analyzeSGP
####
############################################################

###  Insert the Knots and Boundaries (TEMPORARILY) into the SGPstateData object manually until package has been updated.

SGPstateData[["WA"]][["Achievement"]][["Knots_Boundaries"]] <- Washington_SGP@SGP[["Knots_Boundaries"]] #created in Washington_Data_LONG.R after prepSGP

###
###  3rd - 10th grade Math and Reading (the only "Traditional" analyses)
###

Washington_SGP <- analyzeSGP(Washington_SGP,
                             content_areas=c("READING", "MATHEMATICS"),
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=6, 
                                     PROJECTIONS=3, LAGGED_PROJECTIONS=3, 
                                     BASELINE_MATRICES=4, BASELINE_PERCENTILES=6)))

###
###  10th grade Science - the only one with only a single year gap...
###

WA.config <- 
	list(
	SCIENCE.2007_2008 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE"), #"SCIENCE", NA, "SCIENCE"
		sgp.panel.years=c("2005_2006", "2007_2008"),
		sgp.grade.sequences=list(c(8,10))),
	SCIENCE.2008_2009 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE"),
		sgp.panel.years=c("2006_2007", "2008_2009"),
		sgp.grade.sequences=list(c(8,10))),
	SCIENCE.2009_2010 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE"),
		sgp.panel.years=c("2007_2008", "2009_2010"),
		sgp.grade.sequences=list(c(8,10))),
	SCIENCE.2010_2011 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE"),
		sgp.panel.years=c("2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(8,10))))

Washington_SGP <- analyzeSGP(Washington_SGP, 
                             state="WA",
                             sgp.config=WA.config,
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=4)))

####
####  'Typical' EOC Math Course Sequences
####

#  First progressions with NO NA's in 9th grade.
WA.config <- 
	list(
	EOC_MATHEMATICS_1.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(3:7, 3:8, 4:9)),
	EOC_MATHEMATICS_2.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(3:8, 4:9)),
#  10th Grade - Skip year (no 9th grade Math in 2009-2010)
	EOC_MATHEMATICS_1.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),  #  "2009_2010", 
		sgp.grade.sequences=list(c(5:8,10))),
	EOC_MATHEMATICS_2.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(5:8,10))),
	EOC_MATH_MAKEUP_1.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATH_MAKEUP_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(5:8,10))))

Washington_SGP <- analyzeSGP(Washington_SGP, 
                             state="WA",
                             sgp.config=WA.config,
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=4)))


#########################################################
####
####	combineSGP
####
#########################################################

	Washington_SGP <- combineSGP(Washington_SGP, 
		sgp.percentiles.baseline = FALSE, 
		sgp.projections.lagged.baseline=FALSE)

#  Check the LONG @Data file now:
tot<-0
for(i in names(Washington_SGP@SGP[["SGPercentiles"]])[order(names(Washington_SGP@SGP[["SGPercentiles"]]))]) {
	print(paste(dim(eval(parse(text=paste("Washington_SGP@SGP[['SGPercentiles']]$", i, sep=""))))[1], ": ", i))
	tot <- tot+(dim(eval(parse(text=paste("Washington_SGP@SGP[['SGPercentiles']]$", i, sep=""))))[1])
}
tot # 
sum(!is.na(Washington_SGP@Data$SGP)) # 

########################
###  Re-Do ACH LEVEL & ACH LEVEL PRIOR to match the MetStandard Variable???

save(Washington_SGP, file="Data/Washington_SGP.Rdata")

#########################################################
####
####	summarizeSGP
####
#########################################################

Washington_SGP <- summarizeSGP(Washington_SGP,
		# content_areas = subjects,
		# years=2010:2011,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=8))

save(Washington_SGP, file="Data/Washington_SGP.Rdata", compress="bzip2")



#########################################################
####
####	visualizeSGP  
####
#########################################################


	visualizeSGP(Washington_SGP,
			plot.types=c("studentGrowthPlot", "bubblePlot","growthAchievementPlot"),
			bPlot.content_areas=c("READING", "MATHEMATICS"),
			gaPlot.content_areas=c("READING", "MATHEMATICS"),
			gaPlot.years=c('2008_2009', '2009_2010', '2010_2011'),
			gaPlot.format="presentation",
			sgPlot.demo.report=TRUE)


#########################################################
####
####	outputSGP  
####
#########################################################
