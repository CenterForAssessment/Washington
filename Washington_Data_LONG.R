##########################################################
####
#### Code for preparation of Washington LONG data
####
##########################################################

library(SGP)

# Set SGP file as working directory
setwd("~/CENTER/SGP/Washington")

###	Read in and clean the Base data file
Washington_Data_LONG <- read.delim("Data/Base_Files/3LDB_finalRankedGM.txt", comment.char='\"')
Washington_Data_LONG$SSID <- factor(Washington_Data_LONG$SSID)

save(Washington_Data_LONG, file="Data/Base_Files/Washington_Data_LONG-BASE.Rdata", compress=TRUE)

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


###  Fix VALID_CASE variable
Washington_Data_LONG$ValidCase <- factor(2, levels=1:2, labels= c("INVALID_CASE", "VALID_CASE"))

###  Year variable contains minus sign ('2005 - 2006')
levels(Washington_Data_LONG$SchoolYear) <- c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011")

###  Fix the CONTENT_AREA Variable

#  This may not be adequate.  EOC courses include Algebra, Integrated Math, Make Up Math with both Levels 1 & 2
levels(Washington_Data_LONG$Subject) <- c(NA, "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2", "MATHEMATICS", "READING", "SCIENCE", "WRITING", "EOC_MATH_MAKEUP_1")
Washington_Data_LONG$ValidCase[is.na(Washington_Data_LONG$Subject)] <- 'INVALID_CASE'

Washington_Data_LONG$Subject[Washington_Data_LONG$TestType %in% c("MU1", "MU1B")] <- 'EOC_MATH_MAKEUP_1'

#  INVALIDate WASL and MSP Subjects "out of grade"

Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "MATHEMATICS" & !Washington_Data_LONG$ReportingGrade %in% c(3:8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "READING" & !Washington_Data_LONG$ReportingGrade %in% c(3:8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "SCIENCE" & !Washington_Data_LONG$ReportingGrade %in% c(5,8,10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "WRITING" & !Washington_Data_LONG$ReportingGrade %in% c(4,7,10)] <- 'INVALID_CASE'

Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_MATHEMATICS_1" & !Washington_Data_LONG$ReportingGrade %in% c(7:10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_MATHEMATICS_2" & !Washington_Data_LONG$ReportingGrade %in% c(8:10)] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$Subject == "EOC_MATH_MAKEUP_1" & !Washington_Data_LONG$ReportingGrade == 10] <- 'INVALID_CASE'


#  http://www.k12.wa.us/assessment/pubdocs/WCAP2011SpringAdministrationTechnicalReport.pdf 
#  Pg. 6:  The Developmentally Appropriate Proficiency Exam (DAPE) and WCAP Basic are alternatives to regular WCAP administration for eligible students.
#  The WCAP Basic, previously called the WASL-Basic or WASL-MO (or WASL-Modified), is intended for students who take the WCAP test at the grade level
#  but the passing score is adjusted by the student’s IEP teams from Proficient (Level 3) to Basic (Level 2).

#Washington_Data_LONG$ValidCase[Washington_Data_LONG$TestType %in% c("WABA", "DAPE")] <- 'INVALID_CASE'
Washington_Data_LONG$ValidCase[Washington_Data_LONG$TestType %in% "DAPE"] <- 'INVALID_CASE'


###  Clean up the DEMOGRAPHIC factor levels:

levels(Washington_Data_LONG$Gender) <- c(NA, 'Gender: Female', 'Gender: Male')
levels(Washington_Data_LONG$HomeBased) <- c('Home Based: No', 'Home Based: No', 'Home Based: Yes')
levels(Washington_Data_LONG$Private) <- c('Private: No', 'Private: No', 'Private: Yes')
levels(Washington_Data_LONG$MetStandard) <- c(NA, 'Met Standard: No', 'Met Standard: No', 'Met Standard: Yes', 'Met Standard: Yes')
Washington_Data_LONG$EthRace <- factor(Washington_Data_LONG$EthRace, levels=1:8, labels=c("American Indian or Alaskan Native", "Asian", 
	"Black or African American", "Hispanic or Latino", "White", "Hawaiian of Pacific Islander", "Two or More Races", "Not Provided"), ordered=TRUE)
levels(Washington_Data_LONG$Migrant) <- c('Migrant: No', 'Migrant: No', 'Private: Yes')
levels(Washington_Data_LONG$Homeless) <- c('Homeless: No', 'Homeless: No', 'Homeless: Yes')
levels(Washington_Data_LONG$Gifted) <- c('Gifted and Talented Program: No', 'Gifted and Talented Program: No', 'Gifted and Talented Program: Yes')
levels(Washington_Data_LONG$Bilingual) <- c('Bilingual: No', 'Bilingual: No', 'Bilingual: Yes')
levels(Washington_Data_LONG$FRL) <- c('Free Reduced Lunch: No', 'Free Reduced Lunch: No', 'Free Reduced Lunch: Yes')
levels(Washington_Data_LONG$SpecEd) <- c('IEP: No', 'IEP: No', 'IEP: Yes')
 
         
###  Clean up the Achievement Level variable

levels(Washington_Data_LONG$LevelScore) <- c(NA, "L1", "L2", "L3", "L4") # Make "" level NA First before converting it.
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
   [Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCESchool)]
###  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)] <- 
   as.character(Washington_Data_LONG$AYPReadCESchool[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCESchool)])

# DISTRICT
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- Washington_Data_LONG$AYPMathCEDistrict
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'READING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)]
###  Per phone conversation 7/2/12, Science CE determined by Math and Writing CE determined by Read:
Washington_Data_LONG$DISTRICT_ENROLLMENT_STATUS[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)] <- 
   as.character(Washington_Data_LONG$AYPReadCEDistrict[Washington_Data_LONG$Subject %in% 'WRITING' & !is.na(Washington_Data_LONG$AYPReadCEDistrict)])

Washington_Data_LONG$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c('Enrolled State: No', 'Enrolled State: Yes'))

###  Clean up names variables:

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
levels(Washington_Data_LONG$SchoolName)[1] <- NA # 5,302 == "UNKNOWN SCHOOL" - c(1, 5302) or c(1, 3583) after capwords.  Just leave for now...

d.names <- capwords(as.character(levels(Washington_Data_LONG$DistrictName)))
levels(Washington_Data_LONG$DistrictName) <- d.names


f.names <- capwords(as.character(levels(Washington_Data_LONG$StudentFirstName)))
levels(Washington_Data_LONG$StudentFirstName) <- f.names
levels(Washington_Data_LONG$StudentFirstName)[1:4] <- NA

l.names <- capwords(as.character(levels(Washington_Data_LONG$StudentLastName)))
levels(Washington_Data_LONG$StudentLastName) <- l.names


###  Create Data table and (temporarily) rename:
Washington_Data_LONG <- data.table(Washington_Data_LONG)

SGPstateData[["WA"]][["Variable_Name_Lookup"]] <- read.csv("/home/avi/Dropbox/stateData/Variable_Name_Lookup/WA_Variable_Name_Lookup.csv", colClasses=c(rep("character",4), "logical"))

eval(parse(text=paste("setnames(Washington_Data_LONG, c(", 
	paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.provided"]], collapse="','"), "'", sep=""), "),", "c(",
	paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.sgp"]], collapse="','"), "'", sep=""), "))")))


##
##  Identify VALID_CASE  ::  duplicate cases
##

	#  These are ALL NA's (ALL NA scores, content area, and other indicators), and already INVALID.
	# setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "Administration", "ID"))
	# dups <- Washington_Data_LONG[sort(unique(c(which(duplicated(Washington_Data_LONG))-1, which(duplicated(Washington_Data_LONG))))),]
	# Washington_Data_LONG[['VALID_CASE']][which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"
	
	#  This is strictly High School students (grade==9:12)  in MATH READING and WRITING (WASL or HSPE mainly)
	#  All the VALID_CASES are August and Spring repeat administrations.  Use the Spring for consistency 
	#  Also August may be a "Makeup" from last year (Per Call 7/2).  See if these students were missing in prior year.
	Washington_Data_LONG$YEAR_INT <- as.integer(Washington_Data_LONG$YEAR)+2005
	setkeyv(Washington_Data_LONG, c("ID", "CONTENT_AREA", "YEAR_INT", "VALID_CASE"))	
	Washington_Data_LONG[['YEAR_PRIOR']]<- Washington_Data_LONG[SJ(ID, CONTENT_AREA, YEAR_INT-1, "VALID_CASE"), mult="last"][,YEAR]
	Washington_Data_LONG[['YEAR_2YR_PRIOR']]<- Washington_Data_LONG[SJ(ID, CONTENT_AREA, YEAR_INT-2, "VALID_CASE"), mult="last"][,YEAR]
	#  The vast majority are missing a prior year score (not surprising for 10th graders) AND 2 year prior (more important overall).
	#  Hard to say what that August test was (out of grade?  8th grade or 10th grade makeup?). Probably should INVALIDate all Augusts...
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "TestType", "YEAR", "GRADE", "ID", "Administration")) 
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "TestType", "YEAR", "GRADE", "ID")) #"Administration", 
	dups <- Washington_Data_LONG[sort(unique(c(which(duplicated(Washington_Data_LONG))-1, which(duplicated(Washington_Data_LONG))))),]
	setkeyv(dups, c("VALID_CASE", "CONTENT_AREA", "TestType", "YEAR", "ID"))
	summary(dups[VALID_CASE=="VALID_CASE"])

	Washington_Data_LONG[['VALID_CASE']][which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"


	#  The VALID cases here are all students who took the BASIC test August admin period and another in Spring.  Take the Spring admin again.
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "Administration"))
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID"))
	dups <- Washington_Data_LONG[sort(unique(c(which(duplicated(Washington_Data_LONG))-1, which(duplicated(Washington_Data_LONG))))),]
	setkeyv(dups, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
	summary(dups[VALID_CASE=="VALID_CASE"])
	#  All the VALID_CASES are August and Spring repeat administrations.  Use the Spring for consistency
	Washington_Data_LONG[['VALID_CASE']][which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"


	#  These are students who again took test in both admin periods, but labeled as different GRADES in each one (eg 9 in August, 10 in Spring).
	#  Again go with Spring for consistency...
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "Administration"))
	setkeyv(Washington_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
	dups <- Washington_Data_LONG[sort(unique(c(which(duplicated(Washington_Data_LONG))-1, which(duplicated(Washington_Data_LONG))))),]
	setkeyv(dups, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
	summary(dups[VALID_CASE=="VALID_CASE"])
	Washington_Data_LONG[['VALID_CASE']][which(duplicated(Washington_Data_LONG))-1] <- "INVALID_CASE"

	#  There are still a good number of AUGUST administration cases that are VALID.  What should we do about these?
	#  Mainly HSPE and WASL tests for 10th graders (and a few others here and there - all in High School though).
	summary(Washington_Data_LONG[Washington_Data_LONG$Administration=="August" & Washington_Data_LONG$VALID_CASE=="VALID_CASE",])

	#  Only a few thousand have a prior year score (or 2 year prior), so best just to eliminate these and only use the spring administration:
	Washington_Data_LONG[['VALID_CASE']][Washington_Data_LONG$Administration=="August"] <- "INVALID_CASE"
		
	
###
###  Knots and Boundaries for Subjects that will be used as priors:
###

Washington_Data_LONG[['VALID_CASE']][is.na(Washington_Data_LONG[['SCALE_SCORE']])] <- 'INVALID_CASE'

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

for (ca in c("READING", "WRITING", "MATHEMATICS", "SCIENCE")) {
   tmp <- ks[CONTENT_AREA==ca,]
   tmp.b <- bs[CONTENT_AREA==ca,]
   tmp.c <- lhoss[CONTENT_AREA==ca,]
   for (g in tmp[,GRADE]) {
      Knots_Boundaries[[ca]][[paste("knots_", g, sep="")]] <- c(tmp[GRADE==g,V1], tmp[GRADE==g,V2], tmp[GRADE==g,V3], tmp[GRADE==g,V4])
      Knots_Boundaries[[ca]][[paste("boundaries_", g, sep="")]] <- c(tmp.b[GRADE==g,V1], tmp.b[GRADE==g,V2])
      Knots_Boundaries[[ca]][[paste("loss.hoss_", g, sep="")]] <- c(tmp.c[GRADE==g,V1], tmp.c[GRADE==g,V2])
   }
}

###
###   Save Results
###

###  Remove unnecessary variables

Washington_Data_LONG$YEAR_INT <- NULL
Washington_Data_LONG$YEAR_PRIOR <- NULL
Washington_Data_LONG$YEAR_2YR_PRIOR <- NULL

###  Return Names to original variable names first:
eval(parse(text=paste("setnames(Washington_Data_LONG, c(", 
                      paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.sgp"]], collapse="','"), "'", sep=""), "),", "c(", 
                      paste("'", paste(SGPstateData[["WA"]][["Variable_Name_Lookup"]][["names.provided"]], collapse="','"), "'", sep=""), "))")))

save(Washington_Data_LONG, file="Data/Washington_Data_LONG.Rdata", compress="bzip2")
save(Knots_Boundaries, file="Data/Washington_Knots_Boundaries.Rdata")


###
###   prepareSGP
###

#  Replace (TEMPORARILY) the SGPstateData knots and bounds before running analyzeSGP
SGPstateData[['WA']][['Achievement']][['Knots_Boundaries']]<- Knots_Boundaries

### Check to see if prepareSGP works (still need to figure out Knots and boundaries first)

SGPstateData[["WA"]][["Variable_Name_Lookup"]] <- read.csv("/home/avi/Dropbox/stateData/Variable_Name_Lookup/WA_Variable_Name_Lookup.csv", colClasses=c(rep("character",4), "logical"))

Washington_SGP <- prepareSGP(Washington_Data_LONG)
Washington_SGP@SGP <- list(Knots_Boundaries=Knots_Boundaries)

save(Washington_SGP, file="Data/Washington_SGP.Rdata")
