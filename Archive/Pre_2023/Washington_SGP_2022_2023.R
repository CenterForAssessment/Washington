######################################################################################
###                                                                                ###
###                Washington SGP analyses for 2023                                ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Washington_Data_LONG.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("WA", "2022_2023")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022_2023/READING.R")
source("SGP_CONFIG/2022_2023/MATHEMATICS.R")

WA_CONFIG <- c(READING_2022_2023.config, MATHEMATICS_2022_2023.config)

### Parameters
parallel.config <- NULL
#parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run abcSGP analysis
#####

Washington_SGP <- abcSGP(
        sgp_object = Washington_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = WA_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
save(Washington_SGP, file="Data/Washington_SGP.Rdata")
