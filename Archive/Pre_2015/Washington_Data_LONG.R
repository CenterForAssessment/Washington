##########################################################
####
#### Code for preparation of Washington LONG data
####
##########################################################

library(SGP)

# Set SGP file as working directory
setwd("/media/Data/SGP/Washington")

###	Read in and clean the Base data file
Washington_Data_LONG <- rbind.fill(
	read.delim("Data/Base_Files/GrowthModelAssessmentData2005_2011_Final_1.3.12.txt", comment.char="\""),
	read.delim("Data/Base_Files/GrowthModelAssessmentData2012_Final_1.3.12.txt", comment.char="\""))

save(Washington_Data_LONG, file="Data/Base_Files/Washington_Data_LONG-2012_BASE.Rdata", compress=TRUE)

###
###  Clean up data
###

###  Remove extraneous variables:

# Washington_Data_LONG$RecordID <- NULL #  Seems like something that might be useful to keep (?)
Washington_Data_LONG$StudentMI <- NULL
Washington_Data_LONG$GradReqYear <- NULL
Washington_Data_LONG$ExpectedGradYear <- NULL
Washington_Data_LONG$EMH_level <- NULL

#  "PORT" records not included, so remove
Washington_Data_LONG$AYPPortCESchool <- NULL
Washington_Data_LONG$AYPPortCEDistrict <- NULL


###  Year variable contains minus sign ('2005 - 2006')
levels(Washington_Data_LONG$SchoolYear) <- gsub("-", "_", levels(Washington_Data_LONG$SchoolYear))

###  Fix the CONTENT_AREA Variable
#  Note: EOC courses include Algebra, Integrated Math, Make Up Math with both Levels 1 & 2
levels(Washington_Data_LONG$Subject) <- c(NA, "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "MATHEMATICS", "READING", "SCIENCE", "WRITING", "EOC_BIOLOGY")


###  Clean up the DEMOGRAPHIC factor levels:

levels(Washington_Data_LONG$Gender) <- c(NA, 'Gender: Female', 'Gender: Male')
levels(Washington_Data_LONG$HomeBased) <- c('Home Based: No', 'Home Based: No', 'Home Based: Yes')
levels(Washington_Data_LONG$Private) <- c('Private: No', 'Private: No', 'Private: Yes')
levels(Washington_Data_LONG$MetStandard) <- c(NA, 'Met Standard: No', 'Met Standard: No', 'Met Standard: Yes', 'Met Standard: Yes')
Washington_Data_LONG$EthRace <- factor(Washington_Data_LONG$EthRace, levels=1:8, labels=c("American Indian or Alaskan Native", "Asian", 
	"Black or African American", "Hispanic or Latino", "White", "Hawaiian of Pacific Islander", "Two or More Races", "Not Provided"), ordered=TRUE)
levels(Washington_Data_LONG$Migrant) <- c('Migrant: No', 'Migrant: No', 'Migrant: Yes')
levels(Washington_Data_LONG$Homeless) <- c('Homeless: No', 'Homeless: No', 'Homeless: Yes')
levels(Washington_Data_LONG$Gifted) <- c('Gifted and Talented Program: No', 'Gifted and Talented Program: No', 'Gifted and Talented Program: Yes')
levels(Washington_Data_LONG$Bilingual) <- c('Bilingual: No', 'Bilingual: No', 'Bilingual: Yes')
levels(Washington_Data_LONG$FRL) <- c('Free Reduced Lunch: No', 'Free Reduced Lunch: No', 'Free Reduced Lunch: Yes')
levels(Washington_Data_LONG$SpecEd) <- c('IEP: No', 'IEP: No', 'IEP: Yes')
 
         
###  Clean up the Achievement Level variable

levels(Washington_Data_LONG$LevelScore) <- c(NA, "L2", "L1", "L2", "L3", "L4")  # BA = "L2: Basic"
Washington_Data_LONG$LevelScore <- as.numeric(Washington_Data_LONG$LevelScore)
Washington_Data_LONG$LevelScore <- factor(Washington_Data_LONG$LevelScore, levels = c(2,1,3,4),
	labels =c("L1: Below Basic", "L2: Basic", "L3: Proficient", "L4: Advanced"), ordered=TRUE)


###  Clean up the provided ENROLLMENT STATUS Variables and create a single one from them for SCHOOL and DISTRICT:

levels(Washington_Data_LONG$AYPReadCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')
levels(Washington_Data_LONG$AYPMathCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')

levels(Washington_Data_LONG$AYPReadCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')
levels(Washington_Data_LONG$AYPMathCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')

levels(Washington_Data_LONG$AYPEOCMathCEDistrict) <- c(NA, 'Enrolled District: No', 'Enrolled District: Yes')
levels(Washington_Data_LONG$AYPEOCMathCESchool) <- c(NA, 'Enrolled School: No', 'Enrolled School: Yes')


## SCHOOL
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS <- Washington_Data_LONG$AYPMathCESchool
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCESchool)] <- 
   as.character(Washington_Data_LONG$AYPReadCESchool[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCESchool)])

#  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)] <- 
   as.character(Washington_Data_LONG$AYPReadCESchool[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)])

#  Per Krissy's email 1/3/13, EOC indicator added for Math 1 & 2.  Use for Bio as well:
eoc.subj <- c("EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "EOC_BIOLOGY")
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% eoc.subj & !is.na(Washington_Data_LONG$AYPEOCMathCESchool)] <- 
   as.character(Washington_Data_LONG$AYPEOCMathCESchool[Washington_Data_LONG$Subject %in% eoc.subj & !is.na(Washington_Data_LONG$AYPEOCMathCESchool)])

## DISTRICT
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- Washington_Data_LONG$AYPMathCEDistrict
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)])

#  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)])

#  Per Krissy's email 1/3/13, EOC indicator added for Math 1 & 2.  Use for Bio as well:
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% eoc.subj & !is.na(Washington_Data_LONG$AYPEOCMathCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPEOCMathCEDistrict[Washington_Data_LONG$Subject %in% eoc.subj & !is.na(Washington_Data_LONG$AYPEOCMathCEDistrict)])

#  Per Krissy's email 1/3/13.  Note there is no 'N' included in data.
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$SchoolType %in% c('I', 'J', 'T', 'X', 'Y', '5', 'V', 'N')] <- 'Enrolled District: No'

##  STATE - all enrolled ...
Washington_Data_LONG$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c('Enrolled State: No', 'Enrolled State: Yes'))


###  Clean up names variables:

#  'capwords' function is available in the SGP package, but there are some "special words" that we want to add, so use this version here:

	capwords <- function(x) {
		special.words <- c("ELA", "EMH", "II", "III", "IV", "SES", "IEP", "ELL", "HS", "MS", "EL", "ES", "LA", "MAD", "PS", "SD", "US")
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
			x <- gsub("_", " ", x)
		}
		if (length(strsplit(x, split="[.]")[[1]]) > 1) {
			x <- gsub("[.]", " ", x)
		}
		return(sapply(x, function(x) paste(sapply(strsplit(x, split=" ")[[1]], .capwords_internal), collapse=" "), USE.NAMES=FALSE))
	}

s.names <- capwords(as.character(levels(Washington_Data_LONG$SchoolName)))
levels(Washington_Data_LONG$SchoolName) <- s.names
levels(Washington_Data_LONG$SchoolName)[c(1, 3611)] <- NA # 3,611 = "UNKNOWN SCHOOL"

d.names <- capwords(as.character(levels(Washington_Data_LONG$DistrictName)))
levels(Washington_Data_LONG$DistrictName) <- d.names
levels(Washington_Data_LONG$DistrictName)[grep("clark)sd", levels(Washington_Data_LONG$DistrictName))] <- "Evergreen (Clark) SD"
levels(Washington_Data_LONG$DistrictName)[grep("walla)sd", levels(Washington_Data_LONG$DistrictName))] <- "Columbia (Walla) SD"
levels(Washington_Data_LONG$DistrictName)[grep("spk)sd", levels(Washington_Data_LONG$DistrictName))] <- c("East Valley (Spk) SD", "West Vly (Spk) SD")
levels(Washington_Data_LONG$DistrictName)[grep("yak)sd", levels(Washington_Data_LONG$DistrictName))] <- c("East Valley (Yak) SD", "West Vly (Yak) SD")
levels(Washington_Data_LONG$DistrictName)[grep("stev)sd", levels(Washington_Data_LONG$DistrictName))] <- c("Columbia (Stev) SD", "Evergreen (Stev) SD")

levels(Washington_Data_LONG$StudentFirstName)[1:5] <- NA
f.names <- capwords(as.character(levels(Washington_Data_LONG$StudentFirstName)))
levels(Washington_Data_LONG$StudentFirstName) <- f.names

l.names <- capwords(as.character(levels(Washington_Data_LONG$StudentLastName)))
levels(Washington_Data_LONG$StudentLastName) <- l.names


###  Create Data table:
Washington_Data_LONG <- data.table(Washington_Data_LONG)

##
##  Identify VALID_CASEs
##

#  Set variable classes to work with data.table keys
Washington_Data_LONG$SSID <- as.character(Washington_Data_LONG$SSID)
Washington_Data_LONG$Subject <- as.character(Washington_Data_LONG$Subject)

#  Fix VALID_CASE variable.  Need to NULL it first for some reason (?)
Washington_Data_LONG$ValidCase <- NULL
Washington_Data_LONG$ValidCase <- "VALID_CASE"

#  INVALIDate WASL and MSP Subjects "out of grade"
#  Invalidate grade 10(+) from Math.  Also 10th grade Science now Biology in 2012, but there are a handful of SCIENCE records with 10th grade indicated.
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "MATHEMATICS" & !Washington_Data_LONG$ReportingGrade %in% c(3:8)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "READING" & !Washington_Data_LONG$ReportingGrade %in% c(3:8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "WRITING" & !Washington_Data_LONG$ReportingGrade %in% c(4,7,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "SCIENCE" & !Washington_Data_LONG$ReportingGrade %in% c(5,8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "SCIENCE" & Washington_Data_LONG$ReportingGrade > 8 & Washington_Data_LONG$SchoolYear== '2011_2012'] <- 'INVALID_CASE'

#  Only use spring administrations:
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Administration=="August"] <- "INVALID_CASE"

#  Invalidate the NA scores and IDs
Washington_Data_LONG$ValidCase[is.na(Washington_Data_LONG$SSID)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[is.na(Washington_Data_LONG$ScaleScore)] <- 'INVALID_CASE'

#  Invalidate cases based on Krissy's email 10/12/2012 & 1/03/13.  Also invalidate PORT (portfolio - not a scale score)
Washington_Data_LONG$ValidCase[Washington_Data_LONG$TestType %in% c('DAPE', 'MU1', 'MU1B', 'MU2', 'MU2B', 'RE1', 'RE1B', 'RE2', 'RE2B', 'PORT')] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$HomeBased == 'Home Based: Yes'] <- "INVALID_CASE"
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Private == 'Private: Yes'] <- "INVALID_CASE"

#  Create the catch all "EOCT" grade for "Out-of-grade" (or atypical grade) students taking EOC Subjects.  Do this before duplicate invalidation
Washington_Data_LONG$GRADE_REPORTED <- Washington_Data_LONG$ReportingGrade
Washington_Data_LONG$ReportingGrade[Washington_Data_LONG$Subject %in% c("EOC_BIOLOGY", "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2")] <- "EOCT"
   
  ## duplicate cases

	#  Pure duplicates
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "TestType", "SchoolYear", "ReportingGrade", "SSID", "ScaleScore")) 
	Washington_Data_LONG$ValidCase[which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"

	#  Different scores, but same subject, test type, grade, etc. - take highest score
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "TestType", "SchoolYear", "ReportingGrade", "SSID", "ScaleScore")) 
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "TestType", "SchoolYear", "ReportingGrade", "SSID")) 
	Washington_Data_LONG$ValidCase[which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"

	#  Different scores, but same subject and grade, etc. - take highest score
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "SchoolYear", "ReportingGrade", "SSID", "ScaleScore"))
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "SchoolYear", "ReportingGrade", "SSID"))
	Washington_Data_LONG$ValidCase[which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"


	#  Final duplicate case removal without grade as a factor.  Again take the high score if duplicate case
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "SchoolYear", "SSID", "ScaleScore"))
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "SchoolYear", "SSID"))
	Washington_Data_LONG$ValidCase[which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"

	#  Remove EOC cases that are repeats and create the TEST_REPEAT variable to keep track of these cases.
	setkeyv(Washington_Data_LONG, c("ValidCase", "Subject", "SSID"))
  Washington_Data_LONG$TEST_REPEAT <- FALSE
  Washington_Data_LONG$TEST_REPEAT[which(duplicated(Washington_Data_LONG) & Washington_Data_LONG$Subject %in% eoc.subj)] <- TRUE
  Washington_Data_LONG$ValidCase[which(duplicated(Washington_Data_LONG) & Washington_Data_LONG$Subject %in% eoc.subj)] <- "INVALID_CASE"

###
###   Save Results
###

save(Washington_Data_LONG, file="Data/Washington_Data_LONG.Rdata", compress="bzip2")

###
###   prepareSGP
###

Washington_SGP <- prepareSGP(Washington_Data_LONG)

save(Washington_SGP, file="Data/Washington_SGP.Rdata")


###
###  Knots and Boundaries for EOCT Subjects (at least EOC Math 1 will be used as a prior):
###

#  Change names and set key:

eval(parse(text=paste("setnames(Washington_Data_LONG, c(", 
	paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.provided"]], collapse="','"), "'", sep=""), "),", "c(",
	paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.sgp"]], collapse="','"), "'", sep=""), "))")))

setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "GRADE"))

###  "Traditional" content area and grades knots and boundaries 
ks <- Washington_Data_LONG[, as.list(as.vector(unlist(round(quantile(SCALE_SCORE, probs=c(0.2,0.4,0.6,0.8), na.rm=TRUE),digits=3)))),
                           by=list(VALID_CASE, CONTENT_AREA, GRADE)][VALID_CASE=="VALID_CASE",][!is.na(GRADE)]

bs <- Washington_Data_LONG[, as.list(as.vector(round(extendrange(SCALE_SCORE, f=0.1), digits=3))),
                           by=list(VALID_CASE, CONTENT_AREA, GRADE)][VALID_CASE=="VALID_CASE",][!is.na(GRADE)]

lhoss <- Washington_Data_LONG[, as.list(as.vector(round(extendrange(SCALE_SCORE, f=0.0), digits=3))),
                              by=list(VALID_CASE, CONTENT_AREA, GRADE)][VALID_CASE=="VALID_CASE",][!is.na(GRADE)]

#  Put all the knots and boundaries in a list that will work with SGP functions:
Knots_Boundaries <- list()

for (ca in c("EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "EOC_BIOLOGY")) {
   tmp <- ks[CONTENT_AREA==ca,]
   tmp.b <- bs[CONTENT_AREA==ca,]
   tmp.c <- lhoss[CONTENT_AREA==ca,]
   for (g in tmp[,GRADE]) {
      Knots_Boundaries[[ca]][[paste("knots_", g, sep="")]] <- c(tmp[GRADE==g,V1], tmp[GRADE==g,V2], tmp[GRADE==g,V3], tmp[GRADE==g,V4])
      Knots_Boundaries[[ca]][[paste("boundaries_", g, sep="")]] <- c(tmp.b[GRADE==g,V1], tmp.b[GRADE==g,V2])
      Knots_Boundaries[[ca]][[paste("loss.hoss_", g, sep="")]] <- c(tmp.c[GRADE==g,V1], tmp.c[GRADE==g,V2])
   }
}
