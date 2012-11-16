##########################################################
####
#### Code for preparation of Washington LONG data
####
##########################################################

library(SGP)

# Set SGP file as working directory
setwd("/media/Data/SGP/Washington")

###	Read in and clean the Base data file
Washington_Data_LONG <- read.delim("Data/Base_Files/2012WAGrowthModelAssessmentData.txt")
Washington_Data_LONG$SSID <- as.character(Washington_Data_LONG$SSID)

save(Washington_Data_LONG, file="Data/Base_Files/Washington_Data_LONG-2012_BASE.Rdata", compress=TRUE)

###
###  Clean up data
###

###  Remove extraneous variables:

Washington_Data_LONG$RecordID <- NULL
Washington_Data_LONG$StudentMI <- NULL
Washington_Data_LONG$GradReqYear <- NULL
Washington_Data_LONG$ExpectedGradYear <- NULL
Washington_Data_LONG$EMH_level <- NULL

#  "PORT" records not included, so remove
Washington_Data_LONG$AYPPortCESchool <- NULL
Washington_Data_LONG$AYPPortCEDistrict <- NULL


###  Year variable contains minus sign ('2005 - 2006')
levels(Washington_Data_LONG$SchoolYear) <- "2011_2012"

###  Fix the CONTENT_AREA Variable

#  This may not be adequate.  EOC courses include Algebra, Integrated Math, Make Up Math with both Levels 1 & 2
levels(Washington_Data_LONG$Subject) <- c("EOC_BIOLOGY", "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "MATHEMATICS", "READING", "SCIENCE", "WRITING")


###  Clean up the DEMOGRAPHIC factor levels:

levels(Washington_Data_LONG$Gender) <- c(NA, 'Gender: Female', 'Gender: Male')
levels(Washington_Data_LONG$HomeBased) <- c('Home Based: No', 'Home Based: No', 'Home Based: Yes')
levels(Washington_Data_LONG$Private) <- c('Private: No', 'Private: No', 'Private: Yes')
levels(Washington_Data_LONG$MetStandard) <- c('Met Standard: No', 'Met Standard: Yes')
Washington_Data_LONG$EthRace <- factor(Washington_Data_LONG$EthRace, levels=1:8, labels=c("American Indian or Alaskan Native", "Asian", 
	"Black or African American", "Hispanic or Latino", "White", "Hawaiian of Pacific Islander", "Two or More Races", "Not Provided"), ordered=TRUE)
levels(Washington_Data_LONG$Migrant) <- c('Migrant: No', 'Migrant: No', 'Private: Yes')
levels(Washington_Data_LONG$Homeless) <- c('Homeless: No', 'Homeless: No', 'Homeless: Yes')
levels(Washington_Data_LONG$Gifted) <- c('Gifted and Talented Program: No', 'Gifted and Talented Program: No', 'Gifted and Talented Program: Yes')
levels(Washington_Data_LONG$Bilingual) <- c('Bilingual: No', 'Bilingual: No', 'Bilingual: Yes')
levels(Washington_Data_LONG$FRL) <- c('Free Reduced Lunch: No', 'Free Reduced Lunch: No', 'Free Reduced Lunch: Yes')
levels(Washington_Data_LONG$SpecEd) <- c('IEP: No', 'IEP: No', 'IEP: Yes')
 
         
###  Clean up the Achievement Level variable

levels(Washington_Data_LONG$LevelScore) <- c("L2", "L1", "L2", "L3", "L4")  # BA = "L2: Basic"
Washington_Data_LONG$LevelScore <- as.numeric(Washington_Data_LONG$LevelScore)
Washington_Data_LONG$LevelScore <- factor(Washington_Data_LONG$LevelScore, levels = 1:4,
	labels =c("L1: Below Basic", "L2: Basic", "L3: Proficient", "L4: Advanced"), ordered=TRUE)


###  Clean up the provided ENROLLMENT STATUS Variables and create a single one from them for SCHOOL and DISTRICT:

levels(Washington_Data_LONG$AYPReadCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')
levels(Washington_Data_LONG$AYPMathCESchool) <- c('Enrolled School: No', 'Enrolled School: No', 'Enrolled School: Yes')

levels(Washington_Data_LONG$AYPReadCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')
levels(Washington_Data_LONG$AYPMathCEDistrict) <- c('Enrolled District: No', 'Enrolled District: No', 'Enrolled District: Yes')

# SCHOOL
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS <- Washington_Data_LONG$AYPMathCESchool
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCESchool)] <- 
   as.character(Washington_Data_LONG$AYPReadCESchool[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCESchool)])
###  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)] <- 
   as.character(Washington_Data_LONG$AYPReadCESchool[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)])

# DISTRICT
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- Washington_Data_LONG$AYPMathCEDistrict
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)])
###  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)])

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
levels(Washington_Data_LONG$SchoolName)[1837] <- NA # 1837 == "UNKNOWN SCHOOL"

d.names <- capwords(as.character(levels(Washington_Data_LONG$DistrictName)))
levels(Washington_Data_LONG$DistrictName) <- d.names
levels(Washington_Data_LONG$DistrictName)[grep("clark)sd", levels(Washington_Data_LONG$DistrictName))] <- "Evergreen (Clark) SD"
levels(Washington_Data_LONG$DistrictName)[grep("walla)sd", levels(Washington_Data_LONG$DistrictName))] <- "Columbia (Walla) SD"
levels(Washington_Data_LONG$DistrictName)[grep("spk)sd", levels(Washington_Data_LONG$DistrictName))] <- c("East Valley (Spk) SD", "West Vly (Spk) SD")
levels(Washington_Data_LONG$DistrictName)[grep("yak)sd", levels(Washington_Data_LONG$DistrictName))] <- c("East Valley (Yak) SD", "West Vly (Yak) SD")
levels(Washington_Data_LONG$DistrictName)[grep("stev)sd", levels(Washington_Data_LONG$DistrictName))] <- c("Columbia (Stev) SD", "Evergreen (Stev) SD")

f.names <- capwords(as.character(levels(Washington_Data_LONG$StudentFirstName)))
levels(Washington_Data_LONG$StudentFirstName) <- f.names

l.names <- capwords(as.character(levels(Washington_Data_LONG$StudentLastName)))
levels(Washington_Data_LONG$StudentLastName) <- l.names


###  Create Data table and (temporarily) rename:
Washington_Data_LONG <- data.table(Washington_Data_LONG)

##
##  Identify VALID_CASEs
##

#  Fix VALID_CASE variable
Washington_Data_LONG$ValidCase <- "VALID_CASE"

#  INVALIDate WASL and MSP Subjects "out of grade"
#  Remove grade 10 from Math and Science in 2012 - now all EOC tests (?)
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "MATHEMATICS" & !Washington_Data_LONG$ReportingGrade %in% c(3:8)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "READING" & !Washington_Data_LONG$ReportingGrade %in% c(3:8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "SCIENCE" & !Washington_Data_LONG$ReportingGrade %in% c(5,8)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "WRITING" & !Washington_Data_LONG$ReportingGrade %in% c(4,7,10)] <- 'INVALID_CASE'

#  "Out-of-grade" (or atypical grade) students taking EOC Subjects don't necessisarily need to be invalidated like above 
#   because the 'valid' grade/subject progressions are established explicitely in the sgp.config argument in analyzeSGP later.
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_MATHEMATICS_1" & !Washington_Data_LONG$ReportingGrade %in% c(7:10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_MATHEMATICS_2" & !Washington_Data_LONG$ReportingGrade %in% c(8:10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_BIOLOGY" & !Washington_Data_LONG$ReportingGrade %in% c(9:10)] <- 'INVALID_CASE'

#  Invalidate cases based on Krissy's email 10/12/2012

Washington_Data_LONG$ValidCase[Washington_Data_LONG$TestType %in% "DAPE"] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$HomeBased == 'Home Based: Yes'] <- "INVALID_CASE"
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Private == 'Private: Yes'] <- "INVALID_CASE"

  Washington_Data_LONG$ValidCase[Washington_Data_LONG$LevelScore== 'L1: Below Basic' &
      Washington_Data_LONG$TestType %in% c('ALGB', 'BIOB', 'GEOB', 'HSPB', 'IN1B', 'IN2B', 'MSPB', 'RE1B', 'RE2B')] <- "INVALID_CASE"
      
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

	#  Only spring administration in 2012 data:
	# Washington_Data_LONG$ValidCase[Washington_Data_LONG$Administration=="August"] <- "INVALID_CASE"
		

###
###   Save Results
###

save(Washington_Data_LONG, file="Data/Washington_Data_LONG.Rdata", compress="bzip2")

###
###   prepareSGP
###

##  First prepare the 2012 data that we just created to get the variables into the correct class:
Washington_SGP_2012 <- prepareSGP(Washington_Data_LONG)

##  Load the SGP object from the analyses done this summer:
load("/media/Data/SGP/Washington/Data/Washington_SGP.Rdata")

##  Subset the two data sets - remove extraneous variables from 2012 and the added 
##  "SGP" variables from the original object (we will re-create those later in the combineSGP step)
tmp1 <- Washington_SGP@Data[,1:36, with=F]
tmp2 <- Washington_SGP_2012@Data[,1:36, with=F]

##  Replace the @Data slot in the original object with the new data set:
Washington_SGP@Data <- data.table(rbind.fill(tmp1, tmp2), key = key(Washington_SGP@Data))

##  Remove the @Summary slot to save space.  This will be re-constructed in the summarizeSGP step later:
Washington_SGP_2012@Summary <- NULL

##  final prepareSGP to create "high needs status" variable and make sure everything is formatted correctly:
Washington_SGP <- prepareSGP(Washington_SGP)

save(Washington_SGP, file="Data/Washington_SGP.Rdata")
