# require(devtools)
# install_github("SGP", "SchoolView", args="--byte-compile") 

require("SGP") 
library("data.table")
library("plyr") ##needed for rbind.fill
#install.packages("reshape")
library("reshape")

options(error=recover)


###  2005-06 - 2012-13
###  Read in and clean the 2012-13 Base data file 


setwd("R:/Individual Folders/Krissy.Johnson/SGP/SGP Data/2012-13")

Washington_Data_LONG_2013 <- read.delim("GrowthModelAssessmentData2013.txt", comment.char="\"")

setwd("D:/SGP_From VM/2012-13")

save(Washington_Data_LONG_2013, file="R_Data/GrowthModelAssessmentData2013.Rdata", compress=TRUE)

load("R_Data/GrowthModelAssessmentData2013.Rdata")



################################################

###  Step 6. Clean data

################################################


###  Year variable contains minus sign ('2012 - 2013')

levels(Washington_Data_LONG_2013$SchoolYear) <- gsub("-", "_", levels(Washington_Data_LONG_2013$SchoolYear))

###  Fix the CONTENT_AREA Variable

# levels(Washington_Data_LONG_2013$Subject)

levels(Washington_Data_LONG_2013$Subject) <- c("EOC_BIOLOGY", "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "MATHEMATICS", "READING", "SCIENCE", "WRITING")


###  Clean up the DEMOGRAPHIC factor levels:

levels(Washington_Data_LONG_2013$Gender) <- c(NA, 'Gender: Female', 'Gender: Male')                               
levels(Washington_Data_LONG_2013$MetStandard) <- c(NA, 'MetStandard: No','MetStandard: Yes')                               
Washington_Data_LONG_2013$EthRace <- factor(Washington_Data_LONG_2013$EthRace, levels=1:8, labels=c("American Indian or Alaskan Native", "Asian", 
                                                                                                    "Black or African American", "Hispanic or Latino", "White", "Hawaiian or Pacific Islander", "Multi-Racial", "Not Provided"), ordered=TRUE)
levels(Washington_Data_LONG_2013$Migrant) <- c('Migrant: No', 'Migrant: No', 'Migrant: Yes')
levels(Washington_Data_LONG_2013$Homeless) <- c('Homeless: No', 'Homeless: No', 'Homeless: Yes')
levels(Washington_Data_LONG_2013$Gifted) <- c('Gifted and Talented Program: No', 'Gifted and Talented Program: No', 'Gifted and Talented Program: Yes')
levels(Washington_Data_LONG_2013$Bilingual)<- c('Bilingual: No', 'Bilingual: No', 'Bilingual: Yes')
levels(Washington_Data_LONG_2013$FRL) <- c('Free Reduced Lunch: No', 'Free Reduced Lunch: No', 'Free Reduced Lunch: Yes')
levels(Washington_Data_LONG_2013$SpecEd) <- c('SpecEd: No', 'SpecEd: No', 'SpecEd: Yes')
levels(Washington_Data_LONG_2013$HomeBased) <- c('Home Based: No', 'Home Based: No','Home Based: Yes')
levels(Washington_Data_LONG_2013$Private) <- c('Private: No', 'Private: No','Private: Yes')

### Add new program variables here and rename variables that start with #'s (504Plan & 21stCenturyLearning)

Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(X504Plan="Plan_504"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(X21stCenturyLearning="TwentyFirstCentury"))

levels(Washington_Data_LONG_2013$F1Visa) <- c('F1Visa: No', 'F1Visa: No', 'F1Visa: Yes')
levels(Washington_Data_LONG_2013$FosterCare) <- c('Foster Care: No', 'Foster Care: No', 'Foster Care: Yes')
levels(Washington_Data_LONG_2013$Plan_504) <- c('504Plan: No', '504Plan: No', '504Plan: Yes')
levels(Washington_Data_LONG_2013$LAPReading) <- c('LAPReading: No', 'LAPReading: No', 'LAPReading: Yes') 
levels(Washington_Data_LONG_2013$LAPLanguageArts) <- c('LAPLanguageArts: No', 'LAPLanguageArts: No', 'LAPLanguageArts: Yes')  
levels(Washington_Data_LONG_2013$LAPMath) <- c('LAPMath: No', 'LAPMath: No', 'LAPMath: Yes')
levels(Washington_Data_LONG_2013$Title1TASReading) <- c('Title1TASReading: No', 'Title1TASReading: No', 'Title1TASReading: Yes') 
levels(Washington_Data_LONG_2013$Title1TASLanguageArts) <- c('Title1TASLanguageArts: No', 'Title1TASLanguageArts: No', 'Title1TASLanguageArts: Yes') 
levels(Washington_Data_LONG_2013$Title1TASMath) <- c('Title1TASMath: No', 'Title1TASMath: No', 'Title1TASMath: Yes') 
levels(Washington_Data_LONG_2013$NCLBSupplementalServices) <- c('NCLBSupplementalServices: No', 'NCLBSupplementalServices: No', 'NCLBSupplementalServices: Yes') 
levels(Washington_Data_LONG_2013$TwentyFirstCentury) <- c('TwentyFirstCentury: No', 'TwentyFirstCentury: No', 'TwentyFirstCentury: Yes') 


### Clean up Achievement Level variable

levels(Washington_Data_LONG_2013$LevelScore) <- c(NA, "L2", "L1", "L2", "L3", "L4")  # BA = "L2: Basic"
Washington_Data_LONG_2013$LevelScore <- as.numeric(Washington_Data_LONG_2013$LevelScore)
Washington_Data_LONG_2013$LevelScore <- factor(Washington_Data_LONG_2013$LevelScore, levels = c(2,1,3,4),  
                                               labels =c("L1: Below Basic", "L2: Basic", "L3: Proficient", "L4: Advanced"), ordered=TRUE)


###  Clean up the provided ENROLLMENT STATUS Variables and create a single one from them for SCHOOL and DISTRICT:

levels(Washington_Data_LONG_2013$AMOReadCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')
levels(Washington_Data_LONG_2013$AMOMathCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')

levels(Washington_Data_LONG_2013$AMOReadCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')
levels(Washington_Data_LONG_2013$AMOMathCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')

levels(Washington_Data_LONG_2013$AMOEOCMathCESchool) <- c(NA, 'Enrolled School: No', 'Enrolled School: Yes')
levels(Washington_Data_LONG_2013$AMOEOCMathCEDistrict) <- c(NA, 'Enrolled District: No', 'Enrolled District: Yes')

## SCHOOL

Washington_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS <- Washington_Data_LONG_2013$AMOMathCESchool

Washington_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG_2013$Subject %in% 'READING' & !is.na(Washington_Data_LONG_2013$AMOReadCESchool)] <-    
  as.character(Washington_Data_LONG_2013$AMOReadCESchool[Washington_Data_LONG_2013$Subject %in% 'READING' & !is.na(Washington_Data_LONG_2013$AMOReadCESchool)])


eoc.subj <- c("EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2")
Washington_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG_2013$Subject %in% eoc.subj & !is.na(Washington_Data_LONG_2013$AMOEOCMathCESchool)] <-    
  as.character(Washington_Data_LONG_2013$AMOEOCMathCESchool[Washington_Data_LONG_2013$Subject %in% eoc.subj & !is.na(Washington_Data_LONG_2013$AMOEOCMathCESchool)])

# DISTRICT
Washington_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS <- Washington_Data_LONG_2013$AMOMathCEDistrict

Washington_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG_2013$Subject %in% 'READING' & !is.na(Washington_Data_LONG_2013$AMOReadCEDistrict)] <-    
  as.character(Washington_Data_LONG_2013$AMOReadCEDistrict[Washington_Data_LONG_2013$Subject %in% 'READING' & !is.na(Washington_Data_LONG_2013$AMOReadCEDistrict)])

# EOC indicator added for Math 1 & 2
Washington_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG_2013$Subject %in% eoc.subj & !is.na(Washington_Data_LONG_2013$AMOEOCMathCEDistrict)] <-    
  as.character(Washington_Data_LONG_2013$AMOEOCMathCEDistrict[Washington_Data_LONG_2013$Subject %in% eoc.subj & !is.na(Washington_Data_LONG_2013$AMOEOCMathCEDistrict)])

####
# Students attending school types to be excluded from district roll-ups should have an 'N' in their Enrollment Variable - this
# is to ensure the visualizations created in R by the sgp package do not include these students

Washington_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG_2013$SchoolType %in% c('I', 'J', 'T', 'X', 'Y', '5', 'V', 'N')] <- 'Enrolled District: No'

Washington_Data_LONG_2013$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c('Enrolled State: No', 'Enrolled State: Yes'))
Washington_Data_LONG_2013$STATE_ENROLLMENT_STATUS[Washington_Data_LONG_2013$SchoolType %in% c('J', 'V')]


###  Clean up names variables: 

capwords <- function(x) {    special.words <- c("ELA", "EMH", "II", "III", "IV", "SES", "IEP", "ELL", "HS", "MS", "EL", "ES", "LA", "MAD", "PS", "SD", "US")  	
                             .capwords_internal <- function(x) {			
                               if (x %in% special.words) return(x)			
                               s <- gsub("_", " ", x)			
                               s <- gsub("[.]", " ", s)			
                               s <- strsplit(s, split=" ")[[1]]			
                               s <- paste(toupper(substring(s, 1,1)), tolower(substring(s, 2)), sep="", collapse=" ")			
                               s <- strsplit(s, split="-")[[1]]			
                               paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse="-")		
                             }		
                             
                             if (length(strsplit(x, split="_")[[1]]) > 1) {			
                               x <- gsub("_", " ", x)		}		
                             
                             if (length(strsplit(x, split="[.]")[[1]]) > 1) {			
                               x <- gsub("[.]", " ", x)		
                             }		
                             
                             return(sapply(x, function(x) paste(sapply(strsplit(x, split=" ")[[1]], .capwords_internal), collapse=" "), USE.NAMES=FALSE))	
}

s.names <- capwords(as.character(levels(Washington_Data_LONG_2013$SchoolName)))
levels(Washington_Data_LONG_2013$SchoolName) <- s.names
levels(Washington_Data_LONG_2013$SchoolName)[1] <- NA # 5,302 == "UNKNOWN SCHOOL" - c(1, 5302) or c(1, 3583) after capwords. Just leave for now...

d.names <- capwords(as.character(levels(Washington_Data_LONG_2013$DistrictName)))
levels(Washington_Data_LONG_2013$DistrictName) <- d.names
levels(Washington_Data_LONG_2013$DistrictName)[grep("clark)sd", levels(Washington_Data_LONG_2013$DistrictName))] <- "Evergreen (Clark) SD"
levels(Washington_Data_LONG_2013$DistrictName)[grep("walla)sd", levels(Washington_Data_LONG_2013$DistrictName))] <- "Columbia (Walla) SD"
levels(Washington_Data_LONG_2013$DistrictName)[grep("spk)sd", levels(Washington_Data_LONG_2013$DistrictName))] <- c("East Valley (Spk) SD", "West Vly (Spk) SD")
levels(Washington_Data_LONG_2013$DistrictName)[grep("yak)sd", levels(Washington_Data_LONG_2013$DistrictName))] <- c("East Valley (Yak) SD", "West Vly (Yak) SD")
levels(Washington_Data_LONG_2013$DistrictName)[grep("stev)sd", levels(Washington_Data_LONG_2013$DistrictName))] <- c("Columbia (Stev) SD", "Evergreen (Stev) SD")

levels(Washington_Data_LONG_2013$StudentFirstName)[1:5] <- NA                                                                                                           
f.names <- capwords(as.character(levels(Washington_Data_LONG_2013$StudentFirstName)))
levels(Washington_Data_LONG_2013$StudentFirstName) <- f.names

l.names <- capwords(as.character(levels(Washington_Data_LONG_2013$StudentLastName)))
levels(Washington_Data_LONG_2013$StudentLastName) <- l.names


###  Create Data table 

Washington_Data_LONG_2013 <- data.table(Washington_Data_LONG_2013)


################################

##  Step 7. Identify VALID_CASEs

################################

# 2013 Addition: add reason for becoming an invalid case in the NO_SGP_REASON field

#  Set variable classes to work with data.table keys

Washington_Data_LONG_2013$SSID <- as.character(Washington_Data_LONG_2013$SSID)
Washington_Data_LONG_2013$Subject <- as.character(Washington_Data_LONG_2013$Subject)

#  Fix VALID_CASE variable.  Need to NULL it first for some reason, maybe only if it's all empty.  Bringing in some valid values from SQL

Washington_Data_LONG_2013$ValidCase <- NULL
Washington_Data_LONG_2013$ValidCase <- "VALID_CASE"

#  Invalidate records that do not have a test attempt of 'Tested' (TS)

Washington_Data_LONG_2013$ValidCase[!Washington_Data_LONG_2013$TestAttempt %in% 'TS'] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[!Washington_Data_LONG_2013$TestAttempt %in% 'TS'] <- 'Test Attempt was not TS'

#  INVALIDate WASL and MSP Subjects "out of grade" - make sure to invalidate necessary grades in EOC 1 & 2.  

Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "MATHEMATICS" & !Washington_Data_LONG_2013$ReportingGrade %in% c(3:8)] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "MATHEMATICS" & !Washington_Data_LONG_2013$ReportingGrade %in% c(3:8)] <- 'Out of Grade Math Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "READING" & !Washington_Data_LONG_2013$ReportingGrade %in% c(3:8,10)] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "READING" & !Washington_Data_LONG_2013$ReportingGrade %in% c(3:8,10)] <- 'Out of Grade Reading Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "EOC_MATHEMATICS_1" & !Washington_Data_LONG_2013$ReportingGrade %in% c(7:10)] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "EOC_MATHEMATICS_1" & !Washington_Data_LONG_2013$ReportingGrade %in% c(7:10)] <- 'Out of Grade EOCMath1 Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "EOC_MATHEMATICS_2" & !Washington_Data_LONG_2013$ReportingGrade %in% c(8:10)] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "EOC_MATHEMATICS_2" & !Washington_Data_LONG_2013$ReportingGrade %in% c(8:10)] <- 'Out of Grade EOCMath2 Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "SCIENCE"] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "SCIENCE"] <- 'Science Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "EOC_BIOLOGY"] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "EOC_BIOLOGY"] <- 'EOCBio Score'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Subject == "WRITING"] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Subject == "WRITING"] <- 'Writing Score'

# establish # of invalid cases before next cleaning

table(Washington_Data_LONG_2013$NO_SGP_REASON)

## need to invalidate PORT, DAPE, HomeBased, Private

Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$HomeBased == 'Home Based: Yes'] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$HomeBased == 'Home Based: Yes'] <- 'Home Based'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$Private == 'Private: Yes'] <- "INVALID_CASE"
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$Private == 'Private: Yes'] <- 'Private'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$F1Visa == 'F1Visa: Yes'] <- "INVALID_CASE"
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$F1Visa == 'F1Visa: Yes'] <- 'F1Visa'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$TestType %in% c('DAPE')] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$TestType %in% c('DAPE')] <- 'DAPE'
Washington_Data_LONG_2013$ValidCase[Washington_Data_LONG_2013$TestType %in% c('PORT')] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[Washington_Data_LONG_2013$TestType %in% c('PORT')] <- 'PORT'
                               
table(Washington_Data_LONG_2013$ValidCase, Washington_Data_LONG_2013$NO_SGP_REASON, exclude=NA)

#  Invalidate the NA scores and IDs

Washington_Data_LONG_2013$ValidCase[is.na(Washington_Data_LONG_2013$SSID)] <- 'INVALID_CASE' 
Washington_Data_LONG_2013$NO_SGP_REASON[is.na(Washington_Data_LONG_2013$SSID)] <- 'No SSID' 
Washington_Data_LONG_2013$ValidCase[is.na(Washington_Data_LONG_2013$ScaleScore)] <- 'INVALID_CASE'
Washington_Data_LONG_2013$NO_SGP_REASON[is.na(Washington_Data_LONG_2013$ScaleScore)] <- 'No Scale Score'

table(Washington_Data_LONG_2013$ValidCase, Washington_Data_LONG_2013$NO_SGP_REASON, exclude=NA)


save(Washington_Data_LONG_2013, file = "R_Data/GrowthModelAssessmentData2013_b4dupremoval.Rdata", compress=TRUE)

# setwd("D:/SGP_From VM/2012-13")            
# load("R_Data/GrowthModelAssessmentData2013_b4dupremoval.Rdata")


#####################################################
# Step 8. Load Old Object & Merge 2012 file with 2013 before exporting to finish duplicate removal in SQL
# Could easily avoid exporting from R and cleaning out duplicate cases next time by doing all of the cleaning in sql 1st
#####################################################

setwd("D:/SGP_From VM/2010-11_2011-12/Data")
load("Washington_SGP_AVI_RMEOC.Rdata")

# rbind.fill requires arguments to be data.frames
tmp.data <- Washington_SGP@Data
tmp.data <- data.frame(tmp.data)
Washington_Data_LONG_2013 <- data.frame(Washington_Data_LONG_2013)
# head(tmp.data)


# column names need to match (old SGP object has caps names, and new does not)
# score file CE variables have updated names this year


tmp.data <- rename(tmp.data, c(AYPReadCESchool="AMOReadCESchool"))
tmp.data <- rename(tmp.data, c(AYPMathCESchool="AMOMathCESchool"))
tmp.data <- rename(tmp.data, c(AYPEOCMathCESchool="AMOEOCMathCESchool"))
tmp.data <- rename(tmp.data, c(AYPReadCEDistrict="AMOReadCEDistrict"))
tmp.data <- rename(tmp.data, c(AYPMathCEDistrict="AMOMathCEDistrict"))
tmp.data <- rename(tmp.data, c(AYPEOCMathCEDistrict="AMOEOCMathCEDistrict"))
tmp.data$GRADE <- NULL
tmp.data$GRADE <- tmp.data$GRADE_REPORTED
tmp.data$GRADE_REPORTED <- NULL

# rm(Washington_SGP)

# check to see if column headings match
names(tmp.data)
names(Washington_Data_LONG_2013)

# fields that can be capitalized now:  

Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(ValidCase="VALID_CASE"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(Subject="CONTENT_AREA"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(SchoolYear="YEAR"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(SSID="ID"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(DistrictCode="DISTRICT_NUMBER"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(DistrictName="DISTRICT_NAME"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(SchoolCode="SCHOOL_NUMBER"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(SchoolName="SCHOOL_NAME"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(StudentLastName="LAST_NAME"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(StudentFirstName="FIRST_NAME"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(ScaleScore="SCALE_SCORE"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(LevelScore="ACHIEVEMENT_LEVEL"))
Washington_Data_LONG_2013 <- rename(Washington_Data_LONG_2013, c(ReportingGrade="GRADE_REPORTED"))
Washington_Data_LONG_2013$GRADE <- Washington_Data_LONG_2013$GRADE_REPORTED
Washington_Data_LONG_2013$GRADE_REPORTED <- NULL

setwd("D:/SGP_From VM/2012-13/R_Data")     
save(tmp.data, file="tmp.data.Rdata")
save(Washington_Data_LONG_2013, file = "GrowthModelAssessmentData2013_b4dupremoval.Rdata", compress=TRUE)
load("tmp.data.Rdata")

all.tmp.data <- rbind.fill(tmp.data, Washington_Data_LONG_2013)

names(tmp.data)
names(Washington_Data_LONG_2013)
names(all.tmp.data)

save(all.tmp.data, file="all.tmp.data.Rdata", compress=TRUE )

write.table(all.tmp.data, file= "Washington_SGP@Data_2006_2013.txt", append=FALSE, quote=FALSE, sep="|", na="NA", row.names=FALSE)

# how many invalid cases before duplicate case id
table(Washington_Data_LONG_2013$VALID_CASE, exclude=NA)
table(Washington_Data_LONG_2013$VALID_CASE, Washington_Data_LONG_2013$NO_SGP_REASON, exclude=NA) 
# Invalid: 1,188,380, Valid: 1,154,300


##################

## Step 9.  Duplicate Cases - DO THIS IN SQL

##################


#################

###
###  Step 10. Load Final Cleaned 2013 Results from SQL - Merge with 2012 @Data 
###

# load cleaned text file

setwd("D:/SGP_From VM/2012-13/R_Data")  
all.tmp.data <- read.delim("Washington_SGP@Data_2006_2013_final.txt", comment.char="\"")

setwd("D:/SGP_From VM/2012-13/R_Data")  
save(all.tmp.data, file="all.tmp.data.Rdata", compress=TRUE )

# load 2012 SGP object

setwd("D:/SGP_From VM/2010-11_2011-12/Data")
load("Washington_SGP_AVI_RMEOC.Rdata")


# rename variables to match SGP conventions (my call to prepareSGP using the var.names wasn't working)
# do this after all cleaning


all.tmp.data <- rename(all.tmp.data, c(Gender="GENDER"))
all.tmp.data <- rename(all.tmp.data, c(EthRace="ETHNICITY"))
all.tmp.data <- rename(all.tmp.data, c(FRL="FREE_REDUCED_LUNCH_STATUS"))
all.tmp.data <- rename(all.tmp.data, c(SpecEd="IEP_STATUS"))
all.tmp.data <- rename(all.tmp.data, c(Bilingual="ELL_STATUS"))
all.tmp.data <- rename(all.tmp.data, c(Gifted="GIFTED_AND_TALENTED_PROGRAM_STATUS"))
all.tmp.data <- rename(all.tmp.data, c(Migrant="MIGRANT"))
all.tmp.data <- rename(all.tmp.data, c(F1Visa="F1VISA"))
all.tmp.data <- rename(all.tmp.data, c(FosterCare="FOSTER_CARE"))
all.tmp.data <- rename(all.tmp.data, c(Plan_504="PLAN_504"))
all.tmp.data <- rename(all.tmp.data, c(LAPReading="LAP_READING"))
all.tmp.data <- rename(all.tmp.data, c(LAPLanguageArts="LAP_LANGARTS"))
all.tmp.data <- rename(all.tmp.data, c(LAPMath="LAP_MATH"))
all.tmp.data <- rename(all.tmp.data, c(Title1TASReading="T1_TAS_READING"))
all.tmp.data <- rename(all.tmp.data, c(Title1TASLanguangeArts="T1_TAS_LANGARTS"))
all.tmp.data <- rename(all.tmp.data, c(Title1TASMath="T1_TAS_MATH"))
all.tmp.data <- rename(all.tmp.data, c(NCLBSupplementalServices="NCLB_SUPPLEMENTAL_SERVICES"))
all.tmp.data <- rename(all.tmp.data, c(Homeless="HOMELESS"))
all.tmp.data <- rename(all.tmp.data, c(TwentyFirstCentury="TWENTY_FIRST_CENTURY"))

# replace @Data slot with all.tmp.data 
all.tmp.data <- data.table(all.tmp.data)
Washington_SGP@Data <- all.tmp.data

# head(Washington_SGP@Data)
rm(Washington_SGP)

####################################################################
##
####   prepareSGP 
##
####################################################################

# for some reason I had to change the names of the variables to match the SGP package conventions, var.names list did not work


Washington_SGP <- prepareSGP(Washington_SGP)


setwd("D:/SGP_From VM/2012-13/R_Data")
load("Washington_SGP_2013.Rdata") # ~ 13 GB
save(Washington_SGP, file="Washington_SGP_2013.Rdata", compress=TRUE)

