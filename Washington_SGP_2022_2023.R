###########################################################
###
### Washington 2022-2023 SGP Analysis
###
###########################################################

### Load Packages
require(SGP)
require(SGPmatrices)

### Load SGP object created from 2018-2019 analyses and data (contains 2021-2022, 2022-2023 data sets in mathematics and reading in LONG format)
load("Data/Washington_SGP.Rdata")
load("Data/Washington_Data_LONG_2021_2022_and_2022_2023.Rdata") 

### Add matrices to SGPstateData (using 2021-2022 year since matrices are labeled with that year in SGPmatrices package)
SGPstateData <- SGPmatrices::addBaselineMatrices("WA", "2022_2023") 

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022_2023/MATHEMATICS.R")
source("SGP_CONFIG/2022_2023/READING.R")

WA_Config <- c(
	MATHEMATICS_2022_2023.config,
	READING_2022_2023.config	
)

### Calculate SGPs
Washington_SGP <- updateSGP(
		what_sgp_object=Washington_SGP,
		with_sgp_data_LONG=Washington_Data_LONG_2021_2022_and_2022_2023,
		state="WA",
		years="2022_2023",
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