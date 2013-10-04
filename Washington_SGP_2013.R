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


Washington_SGP <- summarizeSGP(Washington_SGP,  
                               years=c("2012_2013"),
                               content_areas=c('EOC_MATHEMATICS_1', 'EOC_MATHEMATICS_2', 'READING','MATHEMATICS'),
                               projection.years.for.target=2)



##################

# visualizeSGP

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
