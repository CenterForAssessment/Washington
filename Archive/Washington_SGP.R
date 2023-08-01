##########################################################
####
####	Code for analysis of Washington data
####
##########################################################

setwd("/media/Data/SGP/Washington")
library(SGP)
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
                             content_areas=c("READING", "MATHEMATICS"),
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=24, PROJECTIONS=20, 
                                     LAGGED_PROJECTIONS=20)))

###
###  Science and Writing with single- and two-year gaps.
###  No projections produced given few grades (only 7th grade Writing and 8th grade Science 'could' get them) and two-year gaps
###

Washington_SGP <- analyzeSGP(Washington_SGP,
                             content_areas=c("SCIENCE", "WRITING"),
                             sgp.projections = FALSE,
                             sgp.projections.lagged = FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=24)))

save(Washington_SGP, file="Data/Washington_SGP.Rdata")

####
####  EOC Math and Biology Course Sequences
####

#  We will use EOC Math 1 for prior for Math 2 now that it is available for 2012.  
#  Add in the knots and boundaries until available in SGPstateData.

SGPstateData[["WA"]][["Achievement"]][["Knots_Boundaries"]][['EOC_MATHEMATICS_1']] <- list(
		knots_EOCT=c(375, 400, 424, 456),
		boundaries_EOCT=c(152.5, 722.5),
		loss.hoss_EOCT=c(200, 675))
		
###  First progressions with gaps.

#  We need to be explicit about the working directory in order to get the goodness of fit plots to all print out.

	dir.create('Goodness_of_Fit/EOCT_SkipYear')
	setwd('Goodness_of_Fit/EOCT_SkipYear')

	Goodness_of_Fit <- list(Non_EOCT=Washington_SGP@SGP[["Goodness_of_Fit"]])
	Washington_SGP@SGP[["Goodness_of_Fit"]] <- NULL

WA.config <- list(
	#  Skip year (no 9th grade Math in 2009-2010)
	EOC_MATHEMATICS_1.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(5:8, 'EOCT'))),
	EOC_MATHEMATICS_1.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2011_2012"),
		sgp.grade.sequences=list(c(4:8, 'EOCT'))),

	EOC_MATHEMATICS_2.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(4:7, 'EOCT'), c(5:8, 'EOCT'))),
	EOC_MATHEMATICS_2.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2011_2012"),
		sgp.grade.sequences=list(c(3:7, 'EOCT'), c(4:8, 'EOCT'))),

	EOC_BIOLOGY.2011_2012 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE", "EOC_BIOLOGY"),
		sgp.panel.years=c("2006_2007", "2009_2010", "2011_2012"),
		sgp.grade.sequences=list(c(5, 8, 'EOCT'))))


Washington_SGP <- analyzeSGP(Washington_SGP, 
                             sgp.config=WA.config,
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=18)))

	setwd("..")

###  Create an additional variable PREFERRED_SGP to identify which SGP to keep for kids who will have duplicates:
###  2 Will be the LEAST prefered - e.g. could have a skip year here, but be a repeater later on.

	SGPercentiles <- Washington_SGP@SGP[['SGPercentiles']]
	
	for (ca in c('EOC_MATHEMATICS_1', 'EOC_MATHEMATICS_2')) {
		SGPercentiles[[paste(ca, '2010_2011', sep='.')]][['PREFERRED_SGP']] <- 2
		SGPercentiles[[paste(ca, '2011_2012', sep='.')]][['PREFERRED_SGP']] <- 2
	}

	Washington_SGP@SGP[['SGPercentiles']] <- SGPercentiles

	Goodness_of_Fit[['EOCT_SkipYear']] <- Washington_SGP@SGP[["Goodness_of_Fit"]]
	Washington_SGP@SGP[["Goodness_of_Fit"]] <- NULL


###  Next Consecutive year progressions.

	dir.create('EOCT_Consecutive')
	setwd('EOCT_Consecutive')

WA.config <- list(
	#  Consecutive Years:
	EOC_MATHEMATICS_1.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(c(3:6, 'EOCT'), c(3:7, 'EOCT'), c(4:8, 'EOCT'))),
	EOC_MATHEMATICS_1.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(c(3:6, 'EOCT'), c(3:7, 'EOCT'), c(3:8, 'EOCT'))),

	EOC_MATHEMATICS_2.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(c(7, 'EOCT'), c(4:8, 'EOCT'))), # 3:7, EOCT produces singular design matrix.  Only works with 7th grade prior ...
	EOC_MATHEMATICS_2.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(c(7, 'EOCT'), c(3:8, 'EOCT'))), # 3:7, EOCT produces singular design matrix.  Only works with 7th grade prior ...
	EOC_MATHEMATICS_2.2011_2012 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(c(3:7, 'EOCT', 'EOCT'), c(4:8, 'EOCT', 'EOCT'))), # Possible that kids with only EOC Math 1 and Math 2 will have duplicates, but should be the same and get sorted out later.

	EOC_BIOLOGY.2011_2012 = list(
		sgp.content.areas=c("SCIENCE", "SCIENCE", "EOC_BIOLOGY"),
		sgp.panel.years=c("2007_2008", "2010_2011", "2011_2012"),
		sgp.grade.sequences=list(c(5, 8, 'EOCT'))))


Washington_SGP <- analyzeSGP(Washington_SGP, 
                             sgp.config=WA.config,
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline= FALSE,
                             sgp.projections.baseline= FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(
                                 BACKEND="PARALLEL",
                                 WORKERS=list(PERCENTILES=18)))

	setwd("/media/Data/SGP/Washington")
	
	Goodness_of_Fit[['EOCT_Consecutive']] <- Washington_SGP@SGP[["Goodness_of_Fit"]]
	Washington_SGP@SGP[["Goodness_of_Fit"]] <- Goodness_of_Fit

	SGPercentiles <- Washington_SGP@SGP[['SGPercentiles']]
	
	for (ca in c('EOC_MATHEMATICS_1', 'EOC_MATHEMATICS_2')) {
		SGPercentiles[[paste(ca, '2010_2011', sep='.')]][['PREFERRED_SGP']][is.na(SGPercentiles[[paste(ca, '2010_2011', sep='.')]][['PREFERRED_SGP']])] <- 1
		SGPercentiles[[paste(ca, '2011_2012', sep='.')]][['PREFERRED_SGP']][is.na(SGPercentiles[[paste(ca, '2011_2012', sep='.')]][['PREFERRED_SGP']])] <- 1
	}

	###
	###  Sort and choose the proper SGP for the duplicated cases
	###
	
	#  Check to see the N on each Content Area analysis as well as the Median SGP
	tot<-0
	for(i in names(Washington_SGP@SGP[['SGPercentiles']])) {
		print(paste(i, "N =", dim(Washington_SGP@SGP[['SGPercentiles']][[i]])[1], " :  Median SGP,", median(Washington_SGP@SGP[['SGPercentiles']][[i]][["SGP"]])))
		tot <- tot+(dim(Washington_SGP@SGP[['SGPercentiles']][[i]])[1])
	}
	tot # 5,266,944

	for (ca in c('EOC_MATHEMATICS_1', 'EOC_MATHEMATICS_2')) {
		tmp.sgp <- data.table(SGPercentiles[[paste(ca, '2010_2011', sep='.')]], key=c('ID', 'PREFERRED_SGP'))
		setkeyv(tmp.sgp, "ID")
		SGPercentiles[[paste(ca, '2010_2011', sep='.')]] <- data.frame(tmp.sgp[which(!duplicated(tmp.sgp)),][, -dim(tmp.sgp)[2], with=FALSE])

		tmp.sgp <- data.table(SGPercentiles[[paste(ca, '2011_2012', sep='.')]], key=c('ID', 'PREFERRED_SGP'))
		setkeyv(tmp.sgp, "ID")
		SGPercentiles[[paste(ca, '2011_2012', sep='.')]] <- data.frame(tmp.sgp[which(!duplicated(tmp.sgp)),][, -dim(tmp.sgp)[2], with=FALSE])
	}

	Washington_SGP@SGP[['SGPercentiles']] <- SGPercentiles
	
	#  Check to see the N on each Content Area analysis (should be fewer than before) as well as the Median SGP (should still be ~50)
	tot<-0
	for(i in names(Washington_SGP@SGP[['SGPercentiles']])) {
		print(paste(i, "N =", dim(Washington_SGP@SGP[['SGPercentiles']][[i]])[1], " :  Median SGP,", median(Washington_SGP@SGP[['SGPercentiles']][[i]][["SGP"]])))
		tot <- tot+(dim(Washington_SGP@SGP[['SGPercentiles']][[i]])[1])
	}
	tot # 5,136,454 (130490 duplicates removed)

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

save(Washington_SGP, file="Data/Washington_SGP.Rdata")


#########################################################
####
####	summarizeSGP
####
#########################################################

Washington_SGP <- summarizeSGP(Washington_SGP,
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
