###########################################################
###
### Washington 2023-2024 SGP Analysis
###
###########################################################

### Load Packages
require(SGP)
require(SGPmatrices)

### Load SGP object created from 2022-2023 analyses and data (contains 2023-2024 data sets in mathematics and reading in LONG format)
load("Data/Washington_SGP.Rdata")
load("Data/Washington_Data_LONG_2023_2024.Rdata") 

### Add matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("WA", "2023_2024") 

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2023_2024/MATHEMATICS.R")
source("SGP_CONFIG/2023_2024/READING.R")

WA_Config <- c(
	MATHEMATICS_2023_2024.config,
	READING_2023_2024.config	
)

### Calculate SGPs
Washington_SGP <- updateSGP(
		what_sgp_object=Washington_SGP,
		with_sgp_data_LONG=Washington_Data_LONG_2023_2024,
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
