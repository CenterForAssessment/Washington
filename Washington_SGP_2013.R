#######################
#
###  analyzeSGP
#
#######################

Washington_SGP <- analyzeSGP(Washington_SGP,
                             years=c("2012_2013"),    
                             content_areas=c("READING"), # "MATHEMATICS"  
                             grades=c('4','5','6'), # '4','5','6','7','8'
                             sgp.percentiles.baseline=FALSE,
                             sgp.projections.baseline=FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             parallel.config=list(                                 
                               BACKEND="PARALLEL",
                               TYPE="SOCK",
                               WORKERS=7))


# with 40 GB of RAM, running both subjects at once, erred out ("serialize error: could not write to connection") 
# running just reading, got an error (Error in checkForRemoteErrors(val) : 3 nodes produced errors; first error: subscript out of bounds)
# Took 1.5 hours to err out (during projection calculation) - subscript error
# try with just one grade - set options(error=recover)
# running just grade 4 worked (22 minutes)  

save(Washington_SGP, file="Washington_SGP_2013.Rdata", compress=TRUE)


EOC_MATHEMATICS_1.2012_2013.config = list(  
  EOC_MATHEMATICS_1.2012_2013 =list(    # Consecutive Year 
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1"),		
    sgp.panel.years=c("2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012","2012_2013"),		
    sgp.grade.sequences=list(c(3:6, 7), c(3:7, 8), c(3:8, 9)),		
    sgp.norm.group.preference=1),	
  EOC_MATHEMATICS_1.2012_2013 =list(  # Skip Year		
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1"),		
    sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2012_2013"),		
    sgp.grade.sequences=list(c(3:8, 10)),		
    sgp.norm.group.preference=2)
) ### END EOC_MATHEMATICS_1.2012_2013.config



Washington_SGP <- analyzeSGP(Washington_SGP,
                             years=c("2012_2013"),
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline=FALSE,
                             sgp.projections.baseline=FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             sgp.config=EOC_MATHEMATICS_1.2012_2013.config,  
                             parallel.config=list(                                 
                               BACKEND="PARALLEL",
                               TYPE="SOCK",
                               WORKERS=7))



options(error=utils::recover)

# first change to grade progressions after error: sgp.ngpref 3 skip year - changed 3:8 to 4:8, still got error after 4:10 finished and 3:9 finished. 
# next change removing all priors from 3:7, 8 - now 7,8
EOC_MATHEMATICS_2.2012_2013.config = list(  
  EOC_MATHEMATICS_2.2012_2013 = list(		# Consecutive Year with EOC 1 as prior
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2"),	
    sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012", "2012_2013"),		
    sgp.grade.sequences=list(c(3:7, 8, 9), c(4:8, 9, 10)),	# remove c(3:6, 7, 8) too few students (~5400)
    sgp.norm.group.preference=1),	
  EOC_MATHEMATICS_2.2012_2013 = list(		# Consecutive Year
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),		
    sgp.panel.years=c("2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012", "2012_2013"),		
    sgp.grade.sequences=list(c(3:8, 9)),  # remove(c(7, 8) too few students (~5000)
    sgp.norm.group.preference=2),	
  EOC_MATHEMATICS_2.2012_2013 =list(  # Skip Year		
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),		
    sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2012_2013"),		
    sgp.grade.sequences=list(c(3:8, 10)),		
    sgp.norm.group.preference=3)
) ### END EOC_MATHEMATICS_2.2012_2013.config


Washington_SGP <- analyzeSGP(Washington_SGP,
                             years=c("2012_2013"),
                             sgp.projections=FALSE,
                             sgp.projections.lagged=FALSE,
                             sgp.percentiles.baseline=FALSE,
                             sgp.projections.baseline=FALSE,
                             sgp.projections.lagged.baseline=FALSE,
                             simulate.sgps=FALSE,
                             sgp.config=EOC_MATHEMATICS_2.2012_2013.config,  
                             parallel.config=list(                                 
                               BACKEND="PARALLEL",
                               TYPE="SOCK",
                               WORKERS=7))



##############################################################

###  combineSGP

#############################################################  

setwd("D:/SGP_From VM/2012-13/R_Data")
load("Washington_SGP_2013.Rdata")

Washington_SGP <- combineSGP(Washington_SGP,     
                             sgp.percentiles.baseline = FALSE,   	
                             sgp.projections.lagged.baseline=FALSE,
                             max.sgp.target.years.forward=2)

save(Washington_SGP, file="Washington_SGP_2013.Rdata", compress=TRUE)


##########################################

###  outputSGP

##########################################

outputSGP(Washington_SGP, output.type=c("LONG_Data"))


##########################################################

## Change Cases that are Invalid but included in the denominator of MetStandard before summarizeSGP and sending Adam file
## for bubble plot production

##########################################################

setwd("D:/SGP_From VM/2012-13")
load("R_Data/Washington_SGP_2013.Rdata")
names(Washington_SGP@Data)
table(Washington_SGP@Data$VALID_CASE, Washington_SGP@Data$YEAR)
## 2012_2013  Invalid: 1207318  Valid: 1135362

## Work on this Friday
# Basically, all non-exempt test attempts should be valid
# In addition, the records with non-exempt test attempts that have a blank in their met standard field, should have a no - if that's included in the % met calculation
# change valid case and met standard values for all no score TestAttempts except 'TS'

Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$TestAttempt %in% c('AU', 'BL', 'IC', 'IV', 'NB', 'OG', 'RF', 'IS','TS') & Washington_SGP@Data$YEAR == '2012_2013'] <- "VALID_CASE"
Washington_SGP@Data$MetStandard[Washington_SGP@Data$TestAttempt %in% c('AU', 'BL', 'IC', 'IV', 'NB', 'OG', 'RF', 'IS','TS') 
                                & Washington_SGP@Data$YEAR == '2012_2013' & 
                                  Washington_SGP@Data$MetStandard == NA] <- "MetStandard: No"

table(Washington_SGP@Data$VALID_CASE, Washington_SGP@Data$YEAR)
## after changing valid cases: 2012_2013  Invalid: 613030  Valid: 1729650 -- 594,288 changed
table(Washington_SGP@Data$YEAR, Washington_SGP@Data$MetStandard, Washington_SGP@Data$CONTENT_AREA)
# No: 527,646 Yes: 1,144,974 - All Subjects
# 148698           407963  - Reading
# 179492           290611  - Mathematics
# 16482            54036   - EOCMath2
# 48673            58341   - EOCMath1

# could also remove new program variables to speed up summarizeSGP?

  
save(Washington_SGP, file="R_Data/Washington_SGP_Valid_for_%Met.Rdata", compress=TRUE)
load("R_Data/Washington_SGP_Valid_for_%Met.Rdata")


###################
#
# summarizeSGP
#
###################

##  Clean up the MetStandard Levels so that they are all the same
##  Krissy edited F1Visa to F1VISA, and added another level to Met Standard (now there are no blank MetStandards)

levels(Washington_SGP@Data$MetStandard) <- c("Met Standard: No", "Met Standard: No", "Met Standard: Yes", "Met Standard: No", "Met Standard: Yes")

# Change ValidCase variable for bubbleplot production, to match metstandard on ReportCard

Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$TestAttempt %in% c('AU', 'BL', 'IC', 'IV', 'NB', 'OG', 'RF', 'IS','TS') & 
                                 Washington_SGP@Data$YEAR == '2012_2013'] <- "VALID_CASE"

# need to re-invalidate certain records -- check field names

Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$HomeBased == 'Home Based: Yes'] <- 'INVALID_CASE'
Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$Private == 'Private: Yes'] <- "INVALID_CASE"
Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$F1VISA == 'F1Visa: Yes'] <- "INVALID_CASE"
Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$TestType %in% c('DAPE')] <- 'INVALID_CASE'
Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$TestType %in% c('PORT')] <- 'INVALID_CASE'
Washington_SGP@Data$VALID_CASE[Washington_SGP@Data$EOC1PORT == 'Y'] <- 'INVALID_CASE'

Washington_SGP@Data$MetStandard[Washington_SGP@Data$TestAttempt %in% c('OG', 'IV')] <- "Met Standard: No"

##  summarizeSGP still expects the variable named "ACHIEVEMENT_LEVEL"  Temporarily rename the two vars 
##  and re-key the object (wasn't keyed before - not sure why?)

setnames(Washington_SGP@Data, c('MetStandard', 'ACHIEVEMENT_LEVEL'), c('ACHIEVEMENT_LEVEL', 'ACL'))
setkeyv(Washington_SGP@Data, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))

##
##  Run summarizeSGP with arguments customized & specified. 
##

Washington_SGP <- summarizeSGP(Washington_SGP,
		sgp.summaries=list(MEDIAN_SGP="median_na(SGP, WEIGHT)",
             MEDIAN_SGP_COUNT="num_non_missing(SGP)",
             #MEDIAN_SGP_TARGET="median_na(SGP_TARGET_2_YEAR, WEIGHT)",
             #MEDIAN_SGP_TARGET_COUNT="num_non_missing(SGP_TARGET_2_YEAR)",
             PERCENT_MET_STANDARD="percent_in_category(ACHIEVEMENT_LEVEL, list('Met Standard: Yes'), list(c('Met Standard: No', 'Met Standard: Yes')))",
             PERCENT_MET_STANDARD_COUNT="num_non_missing(ACHIEVEMENT_LEVEL)",
             PERCENT_ACHIEVEMENT_LEVEL_PRIOR="percent_in_category(ACHIEVEMENT_LEVEL_PRIOR, list(c('L3: Proficient', 'L4: Advanced')), list(c('L1: Below Basic', 'L2: Basic', 'L3: Proficient', 'L4: Advanced')))",
             PERCENT_ACHIEVEMENT_LEVEL_PRIOR_COUNT="num_non_missing(ACHIEVEMENT_LEVEL_PRIOR)"),
		
		summary.groups=list(institution=c("STATE", "DISTRICT_NUMBER", "SCHOOL_NUMBER"),
             institution_type=NULL,
             content="CONTENT_AREA",
             time="YEAR",
             institution_level="GRADE",
             demographic=NULL,
             institution_inclusion=list(
             	STATE="STATE_ENROLLMENT_STATUS", DISTRICT_NUMBER="DISTRICT_ENROLLMENT_STATUS", SCHOOL_NUMBER="SCHOOL_ENROLLMENT_STATUS")),

        parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=10)))


##  Fix renamed variables
setnames(Washington_SGP@Data, c('ACHIEVEMENT_LEVEL', 'ACL'), c('MetStandard', 'ACHIEVEMENT_LEVEL'))

##  Save Washington_SGP object

save(Washington_SGP, file='Washington_SGP.Rdata')


##################
##
##  visualizeSGP
##
#################

require(SGP)

options(error=utils::recover)

visualizeSGP(Washington_SGP,
             plot.types=c("studentGrowthPlot"), 
             sgPlot.content_areas=c("READING","MATHEMATICS"),
             sgPlot.years=c('2012_2013'),
             sgPlot.schools=c(3611))
#sgPlot.scale_score.targets=TRUE,
parallel.config=list(                                 
  BACKEND="PARALLEL",  
  TYPE="SOCK",
  WORKERS=7))
