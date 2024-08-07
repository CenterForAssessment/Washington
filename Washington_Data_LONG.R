############################################################################
###
### Script to clean up data provided by Washington DOE
###
############################################################################

### Load packages
require(data.table)

### Load data
load("Data/Base_Files/Washington_Data_LONG.Rdata")

### Trim out variables that are needed
variables.to.keep <- c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", 
                        "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME", 
                        "GENDER", "HOMELESS", "ETHNICITY", "MIGRANT", "GIFTED_AND_TALENTED_PROGRAM_STATUS", "ELL_STATUS", "FREE_REDUCED_LUNCH_STATUS", "IEP_STATUS",
                        "FOSTER_CARE", "F1VISA", "PLAN_504", "LAP_LANGARTS", "LAP_READING", "LAP_MATH", "T1_TAS_LANGARTS", "T1_TAS_MATH", "T1_TAS_READING",
                        "ESSA150days", "CESchool", "CEDistrict")

Washington_Data_LONG <- Washington_Data_LONG[,variables.to.keep, with=FALSE]

### Save results
save(Washington_Data_LONG, file="Data/Washington_Data_LONG.Rdata")