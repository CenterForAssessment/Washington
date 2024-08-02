###########################################################
###
### Washington 2018-2019 SGP Analysis
###
###########################################################

### Load Packages
require(SGP)
require(SGPmatrices)

### Load data (contains 2016-2017, 2017-2018, 2018-2019 data sets in mathematics and reading in LONG format)
load("Data/Washington_Data_LONG.Rdata") 

### Add matrices to SGPstateData (using 2021-2022 year since matrices are labeled with that year in SGPmatrices package)
SGPstateData <- SGPmatrices::addBaselineMatrices("WA", "2021_2022") 

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2018_2019/MATHEMATICS.R")
source("SGP_CONFIG/2018_2019/READING.R")

WA_Config <- c(
	MATHEMATICS_2018_2019.config,
	READING_2018_2019.config	
)

### Calculate SGPs
Washington_SGP <- abcSGP(
		sgp_object=Washington_Data_LONG,
		state="WA",
		steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
		sgp.percentiles=TRUE,
		sgp.projections=FALSE,
		sgp.projections.lagged=FALSE,
		sgp.percentiles.baseline=TRUE,
		sgp.projections.baseline=FALSE,
		sgp.projections.lagged.baseline=FALSE,
		save.intermediate.results=FALSE,
		sgp.config=WA_Config,
		sgPlot.demo.report=TRUE)


### Save results
save(Washington_SGP, file="Data/Washington_SGP.Rdata")
