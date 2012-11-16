##########################################################
####
####	Code for analysis of Washington data
####
##########################################################

library(SGP)
setwd("/media/Data/SGP/Washington")
load("Data/Washington_SGP.Rdata")

############################################################
####
####		analyzeSGP
####
############################################################

###
###  3rd - 10th grade Math and Reading (the only "Traditional" analyses)
###

Washington_SGP <- analyzeSGP(Washington_SGP,
                             state="WA",
                             years='2011_2012',
                             content_areas=c("READING", "MATHEMATICS"),
                             # sgp.percentiles= FALSE,
                             # sgp.projections= FALSE,
                             # sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=24, PROJECTIONS=24, 
                                     LAGGED_PROJECTIONS=24)))

save(Washington_SGP, file="Data/Washington_SGP.Rdata")

####
####  'Typical' EOC Math Course Sequences
####  10th grade Science now EOC Biology  -  still a single year gap...
####

WA.config <- list(
	EOC_MATHEMATICS_1.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(3:7, 3:8, 3:9, c(4:8,10))),
	EOC_MATHEMATICS_2.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(3:9, c(4:8,10))), # 3:8 (still) produces singular design matrix.  All 8th grade grade progs do ...
	EOC_BIOLOGY.2011_2012 = list(
		sgp.content.areas=c("SCIENCE", "EOC_BIOLOGY"),
		sgp.panel.years=c("2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(8:9, c(8,10))))

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
                                 WORKERS=list(PERCENTILES=10)))

save(Washington_SGP, file="Data/Washington_SGP.Rdata")


#########################################################
####
####	combineSGP
####
#########################################################

	Washington_SGP <- combineSGP(Washington_SGP)

#########################################################
####
####	summarizeSGP
####
#########################################################

	Washington_SGP <- summarizeSGP(Washington_SGP,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=24))
	
	save(Washington_SGP, file="Data/Washington_SGP.Rdata", compress="bzip2")

#########################################################
####
####	visualizeSGP  
####
#########################################################

	#  Need to change the reported grades for Math in the SGPstateData (for growthAchievementPlot)
	SGPstateData[["WA"]][["Student_Report_Information"]]$Grades_Reported$MATHEMATICS <- c(3,4,5,6,7,8)

	visualizeSGP(Washington_SGP, state="WA",
				plot.types=c("bubblePlot", "growthAchievementPlot", "studentGrowthPlot"),
				bPlot.content_areas=c("READING", "MATHEMATICS"),
				bPlot.years=c('2011_2012'),
				bPlot.styles=c(1,10,11),
				bPlot.levels=c("FRL", "SpecEd"),
				bPlot.level.cuts=list(seq(0,100,by=20),c(0,5,10,20,80,100)),
				sgPlot.content_areas=c("READING", "MATHEMATICS"),
				sgPlot.demo.report= TRUE,
				gaPlot.content_areas=c("READING", "MATHEMATICS"),
				gaPlot.years=c('2011_2012'),
				gaPlot.format="presentation",
				parallel.config=list(BACKEND="PARALLEL", WORKERS=list(GA_PLOTS=24, SG_PLOTS=24)))

#########################################################
####
####	outputSGP  
####
#########################################################

	#  Not run yet as of 11/08/12

	outputSGP(Washington_SGP)
	
	
