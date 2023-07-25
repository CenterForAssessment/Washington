################################################################################
###                                                                          ###
###       Washington Code to Create Baseline Matrices                        ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)

###   Load the LONG data for 2017, 2018 and 2019
load("Data/VID/Washington_Data_LONG.Rdata") ### Contains ID, CONTENT_AREA, YEAR, GRADE, SCALE_SCORE, VALID_CASE

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/READING.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

WA_BASELINE_CONFIG <- c(
	READING_BASELINE.config,
	MATHEMATICS_BASELINE.config
)

###   Create Baseline Matrices

Washington_SGP <- prepareSGP(Washington_Baseline_Data, create.additional.variables=FALSE)

WA_Baseline_Matrices <- baselineSGP(
				Washington_SGP,
				sgp.baseline.config=WA_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=4))
)

###   Save results

save(WA_Baseline_Matrices, file="Data/WA_Baseline_Matrices.Rdata")
