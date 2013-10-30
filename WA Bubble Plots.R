################################################################################################################
################################################################################################################
###
###     Create custom bubblePlots for the 2013 Washington SGP analyses.  
###		Uses code adapted from the bubblePlot_Styles function from the SGP package.  
###
###     Adam VanIwaarden, Center for Assessment - March - October 2013
###
################################################################################################################
################################################################################################################

###  Required R packages
library(SGP)
library(data.table)

###  load @Summary data

load("Washington_SGP.Rdata")

### Copy @Data

slot.data <- copy(Washington_SGP@Data)
setkeyv(slot.data, c("VALID_CASE", "YEAR", "CONTENT_AREA", "DISTRICT_NUMBER"))


###  
###		This chunk of assigned variables are the arguments to visualizeSGP and bubblePlot_Styles that are used below and in the utility functions.
###

state='WA'
bPlot.years='2012_2013'
# bPlot.districts=34003 # Use this district for preliminary runs
# bPlot.schools=3653 # Use this school for preliminary runs
bPlot.districts = NULL
bPlot.schools = NULL
bPlot.instructors = NULL
bPlot.styles=c(10, 100)
bPlot.levels=NULL
bPlot.level.cuts=NULL
bPlot.full.academic.year=TRUE
bPlot.minimum.n=10
bPlot.anonymize=FALSE
bPlot.draft=FALSE
bPlot.demo=FALSE
bPlot.format="print"
bPlot.folder="Visualizations/bubblePlots"


# special.words for capwords function
wa.special.words <- c("ELA", "EMH", "II", "III", "IV", "SES", "IEP", "ELL", "HS", "MS", "EL", "ES", "LA", "MAD", "PS", "SD", "US", "EOC", "EOCT")

###  
###		This chunk of variables are from the (internal) bubblePlot_Styles source code.
###

state.name.label <- c(state.name, "DEMONSTRATION")[state==c(state.abb, "DEMO")]
test.abbreviation.label <- SGPstateData[[state]][["Assessment_Program_Information"]][["Assessment_Abbreviation"]]

SGPstateData[[state]][["Student_Report_Information"]][["Grades_Reported"]][["EOC_MATHEMATICS_1"]] <- c(7:10)
SGPstateData[[state]][["Student_Report_Information"]][["Grades_Reported"]][["EOC_MATHEMATICS_2"]] <- c(8:10)

bubblePlot_LEVEL <- "Summary"

bPlot.content_areas= c('MATHEMATICS', 'READING', 'EOC_MATHEMATICS_1', 'EOC_MATHEMATICS_2')
bPlot.prior.achievement=TRUE

##  Background plot messages
# bPlot.message <- c("grid.text(x=unit(50, 'native'), y=unit(50, 'native'), 'DRAFT - DO NOT DISTRIBUTE', rot=-30, gp=gpar(col='grey80', cex=2.9, alpha=0.8, fontface=2))")
bPlot.message <- NULL



###
###		Utility functions from bubblePlot_Styles
###		These are internal functions from bubblePlot_Styles that are needed to run the code below. 
###

	"%w/o%" <- function(x,y) x[!x %in% y]

	pretty_year <- function(x) sub("_", "-", x)

	create.bPlot.labels <- function(year.iter, y.variable.iter, bubblePlot_LEVEL) {
		pretty_year <- function(x) sub("_", "-", x)
		my.labels <- list()
		my.labels$x.year.label <- pretty_year(year.iter)
		if (length(grep("PRIOR", y.variable.iter)) > 0) {
			if (year.iter=="All Years") {
				my.labels$y.year <- "All Years"
			} else {
				my.labels$y.year <- paste(as.numeric(unlist(strsplit(as.character(year.iter), "_")))-1, collapse="_")
			}
			if (bubblePlot_LEVEL=="Summary") my.labels$y.year.label <- paste(pretty_year(my.labels$y.year), "Prior Percent at/above Proficient")
			if (bubblePlot_LEVEL=="Individual") my.labels$y.year.label <- list(PRIOR=paste(pretty_year(my.labels$y.year), "Achievement Level"), CURRENT=paste(pretty_year(year.iter), "Achievement Level"))
			if (bubblePlot_LEVEL=="Summary") my.labels$main.title <- paste(test.abbreviation.label, "Growth & Prior Achievement")
			if (bubblePlot_LEVEL=="Individual") my.labels$main.title <- paste(test.abbreviation.label, "Growth & Achievement")
			if (bubblePlot_LEVEL=="Summary") my.labels$pdf.title <- "Bubble_Plot_(Prior_Achievement)"
			if (bubblePlot_LEVEL=="Individual") my.labels$pdf.title <- "Student_Bubble_Plot"
		} else {
			my.labels$y.year <- year.iter
			if (bubblePlot_LEVEL=="Summary") my.labels$y.year.label <- paste(pretty_year(my.labels$y.year), "Percent at/above Proficient")
			if (bubblePlot_LEVEL=="Individual") my.labels$y.year.label <- paste(pretty_year(my.labels$y.year), "Achievement Level")
			if (bubblePlot_LEVEL=="Summary") my.labels$main.title <- paste(test.abbreviation.label, "Growth and Achievement")
			if (bubblePlot_LEVEL=="Individual") my.labels$main.title <- paste(test.abbreviation.label, "Growth and Achievement")
			if (bubblePlot_LEVEL=="Summary") my.labels$pdf.title <- "Bubble_Plot_(Current_Achievement)"
			if (bubblePlot_LEVEL=="Individual") my.labels$pdf.title <- "Student_Bubble_Plot_(Current_Achievement)"
		}
		return(my.labels)
	}

	names.merge <- function(tmp.data, bPlot.anonymize) {
		if (!"INSTRUCTOR_NUMBER" %in% names(tmp.data) & !"SCHOOL_NUMBER" %in% names(tmp.data) & "DISTRICT_NUMBER" %in% names(tmp.data)) {
			tmp.names <- unique(data.table(slot.data[!is.na(DISTRICT_NUMBER), 
				list(DISTRICT_NUMBER, DISTRICT_NAME, SCHOOL_NUMBER, SCHOOL_NAME)], key="DISTRICT_NUMBER")) # Keep other institution NUMBER to iterate over in some plots
			if (bPlot.anonymize) {
				tmp.names$DISTRICT_NAME <- paste("District", as.numeric(as.factor(tmp.names$DISTRICT_NUMBER)))
			}
			setkey(tmp.data, DISTRICT_NUMBER)
		}
		
		if (!"INSTRUCTOR_NUMBER" %in% names(tmp.data) & "SCHOOL_NUMBER" %in% names(tmp.data) & !"DISTRICT_NUMBER" %in% names(tmp.data)) {
			tmp.names <- unique(data.table(slot.data[!is.na(SCHOOL_NUMBER), 
				list(DISTRICT_NUMBER, DISTRICT_NAME, SCHOOL_NUMBER, SCHOOL_NAME)], key="SCHOOL_NUMBER")) # Keep other institution NUMBER to iterate over in some plots
			if (bPlot.anonymize) {
				tmp.names$SCHOOL_NAME <- paste("School", as.numeric(as.factor(tmp.names$SCHOOL_NUMBER)))
			}
			setkey(tmp.data, SCHOOL_NUMBER)
		}
		
		if ("INSTRUCTOR_NUMBER" %in% names(tmp.data)) { #Add both school and district number regardless of 
			if (!"INSTRUCTOR_NAME" %in% names(tmp.data)) {
				tmp.num <- seq(length(grep('INSTRUCTOR_NUMBER', names(slot.data))))
				eval(parse(text=paste("slot.data$INSTRUCTOR_NAME_", tmp.num,
					"<- paste('Instructor', as.factor(slot.data$INSTRUCTOR_NUMBER_", tmp.num, "))", sep="")))
			}
			tmp.names <- data.frame(slot.data[,c(grep('INSTRUCTOR_NUMBER', names(slot.data)), grep('INSTRUCTOR_NAME', names(slot.data)),
				grep('SCHOOL_NUMBER', names(slot.data)), grep('SCHOOL_NAME', names(slot.data)),
				grep('DISTRICT_NUMBER', names(slot.data)), grep('DISTRICT_NAME', names(slot.data))), with=FALSE])
			inst.id.index <- grep('INSTRUCTOR_NUMBER', names(tmp.names)); inst.name.index <- grep('INSTRUCTOR_NAME', names(tmp.names))
			sch.id.index <- grep('SCHOOL_NUMBER', names(tmp.names)); sch.name.index <- grep('SCHOOL_NAME', names(tmp.names))
			dst.id.index <- grep('DISTRICT_NUMBER', names(tmp.names)); dst.name.index <- grep('DISTRICT_NAME', names(tmp.names))
			tmp.names<- eval(parse(text=paste("unique(data.table(INSTRUCTOR_NUMBER=c(", paste("tmp.names[,", inst.id.index, "]", collapse=","),
				"), INSTRUCTOR_NAME=c(", paste("tmp.names[,", inst.name.index, "]", collapse=","),
				"), SCHOOL_NUMBER=rep(", paste("tmp.names[,", sch.id.index, "],", length(inst.id.index), collapse=","),
				"), SCHOOL_NAME=rep(", paste("tmp.names[,", sch.name.index, "],", length(inst.id.index), collapse=","), 
				"), DISTRICT_NUMBER=rep(", paste("tmp.names[,", dst.id.index, "],", length(inst.id.index), collapse=","),
				"), DISTRICT_NAME=rep(", paste("tmp.names[,", dst.name.index, "],", length(inst.id.index), collapse=","), ")))")))
			if (bPlot.anonymize) {
				tmp.names$INSTRUCTOR_NAME <- paste("Instructor", as.numeric(as.factor(tmp.names$INSTRUCTOR_NUMBER)))
				tmp.names$SCHOOL_NAME <- paste("School", as.numeric(as.factor(tmp.names$SCHOOL_NUMBER)))
				tmp.names$DISTRICT_NAME <- paste("District", as.numeric(as.factor(tmp.names$DISTRICT_NUMBER)))
			}

			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data) & "SCHOOL_NUMBER" %in% names(tmp.data) & !"DISTRICT_NUMBER" %in% names(tmp.data)) {
				setkeyv(tmp.names, c("INSTRUCTOR_NUMBER", "SCHOOL_NUMBER"))
				setkeyv(tmp.data, c("INSTRUCTOR_NUMBER", "SCHOOL_NUMBER"))
			}
			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data) & !"SCHOOL_NUMBER" %in% names(tmp.data) & "DISTRICT_NUMBER" %in% names(tmp.data)) {
				setkeyv(tmp.names, c("INSTRUCTOR_NUMBER", "DISTRICT_NUMBER"))
				setkeyv(tmp.data, c("INSTRUCTOR_NUMBER", "DISTRICT_NUMBER"))
			}
			tmp.names[tmp.data, mult="last"][!is.na(INSTRUCTOR_NUMBER)]
		} else tmp.names[tmp.data, mult="last"]
	}

	get.my.iters <- function(tmp.data, bubblePlot_LEVEL, ...) {
		my.iters <- list()

		# Year Stuff

		if (is.null(bPlot.years)) {
			if ("YEAR" %in% names(tmp.data)) {
				my.iters$tmp.years <- tail(sort(unique(tmp.data$YEAR)), 1)
			} else {
				my.iters$tmp.years <- "All Years"
			}
		} else {
			my.iters$tmp.years <- bPlot.years
		}

		# Content Area Stuff

		if (is.null(bPlot.content_areas)) {
			if ("CONTENT_AREA" %in% names(tmp.data)) {
				my.iters$tmp.content_areas <- unique(tmp.data$CONTENT_AREA) %w/o% NA
			} else {
				my.iters$tmp.content_areas <- "All Content Areas"
			}
		} else {
			my.iters$tmp.content_areas <- bPlot.content_areas
		}

		# Reconcile choice of District and Schools

		if (is.null(bPlot.instructors) & is.null(bPlot.schools) & is.null(bPlot.districts)) {
			if ("DISTRICT_NUMBER" %in% names(tmp.data)) {
				if (identical(my.iters$tmp.years, "All Years")) {
					my.iters$tmp.districts <- sort(unique(tmp.data$DISTRICT_NUMBER)) %w/o% NA
				} else {
					my.iters$tmp.districts <- sort(unique(tmp.data[YEAR %in% my.iters$tmp.years]$DISTRICT_NUMBER)) %w/o% NA
				}
			}
			if ("SCHOOL_NUMBER" %in% names(tmp.data)) {
				if (identical(my.iters$tmp.years, "All Years")) {
					my.iters$tmp.schools <- sort(unique(tmp.data$SCHOOL_NUMBER)) %w/o% NA
				} else {
					my.iters$tmp.schools <- sort(unique(tmp.data[YEAR %in% my.iters$tmp.years]$SCHOOL_NUMBER)) %w/o% NA
				}
			}
			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data)) {
				if (identical(my.iters$tmp.years, "All Years")) {
					my.iters$tmp.instructors <- sort(unique(tmp.data$INSTRUCTOR_NUMBER)) %w/o% NA
				} else {
					my.iters$tmp.instructors <- sort(unique(tmp.data[YEAR %in% my.iters$tmp.years]$INSTRUCTOR_NUMBER)) %w/o% NA
				}
			}
		}

		if (is.null(bPlot.instructors) & is.null(bPlot.schools) & !is.null(bPlot.districts)) {
	 		my.iters$tmp.districts <- bPlot.districts
			if ("SCHOOL_NUMBER" %in% names(tmp.data)) my.iters$tmp.schools <- unique(tmp.data$SCHOOL_NUMBER[tmp.data$DISTRICT_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data)) my.iters$tmp.instructors <- unique(tmp.data$INSTRUCTOR_NUMBER[tmp.data$INSTRUCTOR_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
		}

		if (is.null(bPlot.instructors) & !is.null(bPlot.schools) & is.null(bPlot.districts)) {
	 		my.iters$tmp.schools <- bPlot.schools 
			if ("DISTRICT_NUMBER" %in% names(tmp.data)) my.iters$tmp.districts <- unique(tmp.data$DISTRICT_NUMBER[tmp.data$SCHOOL_NUMBER %in% my.iters$tmp.schools]) %w/o% NA
			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data)) my.iters$tmp.instructors <- unique(tmp.data$INSTRUCTOR_NUMBER[tmp.data$INSTRUCTOR_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
		}

		if (!is.null(bPlot.instructors) & is.null(bPlot.schools) & is.null(bPlot.districts)) {
			my.iters$tmp.instructors <- bPlot.instructors 
			if ("DISTRICT_NUMBER" %in% names(tmp.data)) my.iters$tmp.districts <- unique(tmp.data$DISTRICT_NUMBER[tmp.data$SCHOOL_NUMBER %in% my.iters$tmp.schools]) %w/o% NA
			if ("SCHOOL_NUMBER" %in% names(tmp.data)) my.iters$tmp.schools <- unique(tmp.data$SCHOOL_NUMBER[tmp.data$DISTRICT_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
		}

		if (is.null(bPlot.instructors) & !is.null(bPlot.schools) & !is.null(bPlot.districts)) {
	 		my.iters$tmp.districts <- bPlot.districts
	 		my.iters$tmp.schools <- bPlot.schools 
			if ("INSTRUCTOR_NUMBER" %in% names(tmp.data)) my.iters$tmp.instructors <- unique(tmp.data$INSTRUCTOR_NUMBER[tmp.data$INSTRUCTOR_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
		}

		if (!is.null(bPlot.instructors) & !is.null(bPlot.schools) & is.null(bPlot.districts)) {
	 		my.iters$tmp.schools <- bPlot.schools 
			my.iters$tmp.instructors <- bPlot.instructors 
			if ("DISTRICT_NUMBER" %in% names(tmp.data)) my.iters$tmp.districts <- unique(tmp.data$DISTRICT_NUMBER[tmp.data$SCHOOL_NUMBER %in% my.iters$tmp.schools]) %w/o% NA
		}

		if (!is.null(bPlot.instructors) & is.null(bPlot.schools) & !is.null(bPlot.districts)) {
	 		my.iters$tmp.districts <- bPlot.districts
			my.iters$tmp.instructors <- bPlot.instructors 
			if ("SCHOOL_NUMBER" %in% names(tmp.data)) my.iters$tmp.schools <- unique(tmp.data$SCHOOL_NUMBER[tmp.data$DISTRICT_NUMBER %in% my.iters$tmp.districts]) %w/o% NA
		}

		if (!is.null(bPlot.schools) & !is.null(bPlot.districts)) {
	 		my.iters$tmp.districts <- bPlot.districts
	 		my.iters$tmp.schools <- bPlot.schools 
	 		my.iters$tmp.instructors <- bPlot.instructors 
			my.iters$tmp.instructors <- unique(c(my.iters$tmp.instructors, tmp.data$INSTRUCTOR_NUMBER[tmp.data$SCHOOL_NUMBER %in% my.iters$tmp.schools])) %w/o% NA
			my.iters$tmp.schools <- unique(c(my.iters$tmp.schools, tmp.data$SCHOOL_NUMBER[tmp.data$DISTRICT_NUMBER %in% my.iters$tmp.districts])) %w/o% NA
			my.iters$tmp.districts <- unique(c(my.iters$tmp.districts, tmp.data$DISTRICT_NUMBER[tmp.data$SCHOOL_NUMBER %in% my.iters$tmp.schools])) %w/o% NA
		}

		# y.variable (include/not include prior achievement)

		if (bPlot.prior.achievement & length(grep("PRIOR", names(tmp.data))) > 0) {
			if (bubblePlot_LEVEL=="Summary") my.iters$tmp.y.variable <- c("PERCENT_AT_ABOVE_PROFICIENT", "PERCENT_AT_ABOVE_PROFICIENT_PRIOR")
			if (bubblePlot_LEVEL=="Individual") my.iters$tmp.y.variable <- c("SCALE_SCORE", "SCALE_SCORE_PRIOR")
		} else {
			if (bubblePlot_LEVEL=="Summary") my.iters$tmp.y.variable <- "PERCENT_AT_ABOVE_PROFICIENT"
			if (bubblePlot_LEVEL=="Individual") my.iters$tmp.y.variable <- "SCALE_SCORE"
		}
		return(my.iters)
	} ## END get.my.iters

	get.my.level.labels <- function(bPlot.level.cuts) {
		tmp.list <- list()
		tmp.list[[1]] <- paste("Less than", bPlot.level.cuts[2], "percent")
		if (length(bPlot.level.cuts) > 3) {
			for (i in 2:(length(bPlot.level.cuts)-1)) {
				tmp.list[[i]] <- paste(bPlot.level.cuts[i], "to", bPlot.level.cuts[i+1], "percent")
			}
		}
		tmp.list[[length(bPlot.level.cuts)-1]] <- paste("More than", bPlot.level.cuts[length(bPlot.level.cuts)-1], "percent")
	do.call(c, tmp.list)
	}

	get.bPlot.data <- function(tmp.bPlot.data) {
		tmp <- "MEDIAN_SGP_COUNT >= bPlot.minimum.n"
		if (content_area.iter != "All Content Areas") tmp <- paste("CONTENT_AREA==as.character(content_area.iter) &", tmp)
		if (year.iter != "All Years") tmp <- paste("YEAR==year.iter &", tmp)
		subset(tmp.bPlot.data, eval(parse(text=tmp)))
	}

	get.multiple.membership <- function(names.df) {
		"%w/o%" <- function(x, y) x[!x %in% y]
		tmp.names <- list()
		tmp.number.variables <- unique(suppressWarnings(as.numeric(sapply(strsplit(
			names.df[["names.type"]][grep("institution_multiple_membership", names.df[["names.type"]])], "_"), 
			function(x) tail(x,1)))) %w/o% NA)
		if (length(tmp.number.variables)==0) {
			tmp.names <- NULL
		} else {
			for (i in seq(tmp.number.variables)) {
				tmp.variable.names <- as.character(names.df[names.df$names.type==paste("institution_multiple_membership_", i, sep=""), "names.sgp"])

				tmp.length <- sum(paste("institution_multiple_membership_", i, sep="")==names.df[["names.type"]], na.rm=TRUE)
				tmp.weight.length <- sum(paste("institution_multiple_membership_", i, "_weight", sep="")==names.df[["names.type"]], na.rm=TRUE)
				tmp.inclusion.length <- sum(paste("institution_multiple_membership_", i, "_inclusion", sep="")==names.df[["names.type"]], na.rm=TRUE)

				if ((tmp.weight.length != 0 & tmp.weight.length != tmp.length) | (tmp.inclusion.length != 0 & tmp.inclusion.length != tmp.length)) {
					stop("\tNOTE: The same (non-zero) number of inclusion/weight Multiple Membership variables must exist as the number of multiple Membership variables.")
				}

				if (tmp.weight.length == 0) {
					tmp.weights <- NULL
				} else {
					tmp.weights <- as.character(names.df[names.df$names.type==paste("institution_multiple_membership_", i, "_weight", sep=""), "names.sgp"])
				}
				
				if (tmp.inclusion.length != 0 & tmp.inclusion.length != tmp.length) {
					stop("\tNOTE: The same number (or zero) of Multiple membership inclusion variables must exist as the number of multiple membership variables.")
				}
				if (tmp.inclusion.length == 0) {
					tmp.inclusion <- NULL 
				} else {
					tmp.inclusion <- as.character(names.df[names.df$names.type==paste("institution_multiple_membership_", i, "_inclusion", sep=""), "names.sgp"])
				}

				tmp.names[[i]] <- list(VARIABLE.NAMES=tmp.variable.names, WEIGHTS=tmp.weights, ENROLLMENT_STATUS=tmp.inclusion)
			}
		}
		return(tmp.names)
	} ### END get.multiple.membership


	get.my.cutscore.year <- function(state, content_area, year) {
		tmp.cutscore.years <- sapply(strsplit(names(SGPstateData[[state]][["Achievement"]][["Cutscores"]])[
			grep(content_area, names(SGPstateData[[state]][["Achievement"]][["Cutscores"]]))], "[.]"), function(x) x[2])
		if (any(!is.na(tmp.cutscore.years))) {
			if (year %in% tmp.cutscore.years) {
				return(paste(content_area, year, sep="."))
			} else {
				if (year==sort(c(year, tmp.cutscore.years))[1]) {
					return(content_area)
				} else {
					return(paste(content_area, sort(tmp.cutscore.years)[which(year==sort(c(year, tmp.cutscore.years)))-1], sep="."))
				}
			}
		} else {
			return(content_area)
		}
	}


#######################################################################################
### BubblePlot Style 10 (State level bubblePlots with district schools highlighted)
#######################################################################################

	### Data sets and relevant quantities used for bubblePlots

	tmp.bPlot.data <- Washington_SGP@Summary[["SCHOOL_NUMBER"]][["SCHOOL_NUMBER__CONTENT_AREA__YEAR__SCHOOL_ENROLLMENT_STATUS"]][SCHOOL_ENROLLMENT_STATUS=="Enrolled School: Yes"]

	# Merge in school and district names and anonymize school names (if requested)

	tmp.bPlot.data <- names.merge(tmp.bPlot.data, bPlot.anonymize)

	### Get tmp.years, tmp.content_areas, and tmp.y.variable

	my.iters <- get.my.iters(tmp.bPlot.data, bubblePlot_LEVEL)
	
	###  Temporarily assign these values for preliminary testing:
	# year.iter <- '2012_2013'
	# y.variable.iter <- my.iters$tmp.y.variable[1]
	# content_area.iter <- my.iters$tmp.content_areas[1]
	# district_number.iter <- my.iters$tmp.districts

	### Start loops for bubblePlots

	for (year.iter in my.iters$tmp.years) {  ### Loop over year
	for (content_area.iter in my.iters$tmp.content_areas) { ### Loop over content areas
	
	if (content_area.iter %in% c('MATHEMATICS', 'READING')) {
		if (content_area.iter == 'MATHEMATICS') bPlot.test <- "MSP" else bPlot.test <- "MSP/HSPE"
		my.iters$tmp.y.variable <- c("PERCENT_MET_STANDARD", "PERCENT_ACHIEVEMENT_LEVEL_PRIOR")
	} else { # EOC Maths
		bPlot.test <- "EOC"
		my.iters$tmp.y.variable <- "PERCENT_MET_STANDARD"
	}

	# Subset data

	bPlot.data <- get.bPlot.data(tmp.bPlot.data)

	# Loop over unique districts

	for (district_number.iter in intersect(my.iters$tmp.districts, bPlot.data$DISTRICT_NUMBER)) { ### Loop over DISTRICT NUMBERS
	for (y.variable.iter in my.iters$tmp.y.variable) {  ### Loop over CURRENT and PRIOR achievement (if requested)

	# Create labels  paste(bPlot.test, "Median Growth Percentiles & Achievement"),  

	bPlot.labels <- create.bPlot.labels(year.iter, y.variable.iter, bubblePlot_LEVEL)
	district.name.label <- as.character(bPlot.data[DISTRICT_NUMBER==district_number.iter]$DISTRICT_NAME[1])

	### Create bubblePlot ###
	bubblePlot(
		bubble_plot_data.X=bPlot.data[["MEDIAN_SGP"]],
		bubble_plot_data.Y=bPlot.data[[y.variable.iter]],
		bubble_plot_data.SUBSET=which(bPlot.data[["DISTRICT_NUMBER"]]==district_number.iter & !is.na(bPlot.data[[y.variable.iter]])),
		bubble_plot_data.INDICATE=NULL,
		bubble_plot_data.BUBBLE_CENTER_LABEL=NULL,
		bubble_plot_data.SIZE=bPlot.data[["MEDIAN_SGP_COUNT"]],
		bubble_plot_data.LEVELS=NULL,
		bubble_plot_data.BUBBLE_TIPS_LINES=list(paste(bPlot.data[["MEDIAN_SGP"]], " (", bPlot.data[["MEDIAN_SGP_COUNT"]], ")", sep=""),
			paste(bPlot.data[[y.variable.iter]], " (", bPlot.data[[paste(y.variable.iter, "_COUNT", sep="")]], ")", sep="")),
		bubble_plot_labels.X=c("Growth", paste(bPlot.labels$x.year.label, "Median Student Growth Percentile")),
		bubble_plot_labels.Y=c("Achievement", bPlot.labels$y.year.label),
		bubble_plot_labels.SIZE=c(50, 100, 250, 500),
		bubble_plot_labels.LEVELS=NULL, #levels(bubblePlot[["subset.factor"]]),
		bubble_plot_labels.BUBBLE_TIPS_LINES=list(paste(bPlot.labels$x.year.label, "Median SGP (Count)"),
			paste(bPlot.labels$y.year.label, " (Count)")),
		bubble_plot_labels.BUBBLE_TITLES=bPlot.data[["SCHOOL_NAME"]],
		bubble_plot_titles.MAIN=gsub("MSP/HSPE Growth", paste(bPlot.test, "Median Growth Percentiles"), bPlot.labels$main.title),
		bubble_plot_titles.SUB1=paste(district.name.label, "School District"),
		bubble_plot_titles.SUB2="All Schools' Performance",
		bubble_plot_titles.SUB3=paste(bPlot.labels$x.year.label, capwords(content_area.iter, special.words=wa.special.words)), # 
			# gsub("Eoc ", "EOC ", capwords(content_area.iter, special.words=wa.special.words))), # used this to get EOC cap'd without EOC or EOCT in the wa.special.words above.  Not necessary with those in there.
		bubble_plot_titles.LEGEND1="School Size",
		bubble_plot_titles.LEGEND2_P1= NULL,
		bubble_plot_titles.LEGEND2_P2=NULL,
		bubble_plot_titles.NOTE="Only students that are\n continuously enrolled \n are displayed. \nSchools with fewer\nthan 10 students \nare not displayed.",

		bubble_plot_configs.BUBBLE_MIN_MAX=c(0.04, 0.11),
		bubble_plot_configs.BUBBLE_X_TICKS=seq(0,100,10),
		bubble_plot_configs.BUBBLE_X_TICKS_SIZE=c(rep(0.6, 5), 1, rep(0.6, 5)),
		bubble_plot_configs.BUBBLE_Y_TICKS=seq(0,100,10),
		bubble_plot_configs.BUBBLE_SUBSET_INCREASE=0.01,
		bubble_plot_configs.BUBBLE_COLOR="deeppink2",
		bubble_plot_configs.BUBBLE_SUBSET_ALPHA=list(Transparent=0.3, Opaque=0.9),
		bubble_plot_configs.BUBBLE_TIPS="TRUE",
		bubble_plot_configs.BUBBLE_PLOT_DEVICE="PDF",
		bubble_plot_configs.BUBBLE_PLOT_FORMAT=bPlot.format, #"presentation", #
		bubble_plot_configs.BUBBLE_PLOT_LEGEND="TRUE",
		bubble_plot_configs.BUBBLE_PLOT_TITLE="TRUE",
		bubble_plot_configs.BUBBLE_PLOT_EXTRAS=bPlot.message,
		bubble_plot_configs.BUBBLE_PLOT_NAME=paste(paste(district.name.label, year.iter, capwords(content_area.iter, special.words=wa.special.words), bPlot.labels$pdf.title, sep="_"), ".pdf", sep=""),
		bubble_plot_configs.BUBBLE_PLOT_PATH=file.path(bPlot.folder, year.iter, paste("District", district_number.iter, sep="_"), "District-Level_Plots"),
		bubble_plot_pdftk.CREATE_CATALOG=FALSE)

	} ## END loop over y.variable.iter
	} ## End loop over district_number.iter
	} ## End loop over content_area.iter
	} ## End loop over year.iter



#################################################################################################################
#################################################################################################################
####
#### Individual Level bubblePlots
####
#################################################################################################################
#################################################################################################################

### >= 100 are @Data level bubblePlots

		bubblePlot_LEVEL <- "Individual"


		### Get tmp.years, tmp.content_areas, and tmp.y.variable

		my.iters <- get.my.iters(slot.data["VALID_CASE"], bubblePlot_LEVEL)

		### Create PRIOR SGP, SGP_TARGET and CONTENT_AREA

		slot.data[, YEAR_INTEGER_TMP:=as.integer(as.factor(slot.data$YEAR))]
		setkeyv(slot.data, c("ID", "CONTENT_AREA", "YEAR_INTEGER_TMP", "VALID_CASE")) ## CRITICAL that VALID_CASE is last in group
		if (!"SGP_PRIOR" %in% names(slot.data)) {
			slot.data[,SGP_PRIOR:=slot.data[SJ(ID, CONTENT_AREA, YEAR_INTEGER_TMP-1), mult="last"][["SGP"]]]
		}
		if (!"SGP_TARGET_PRIOR" %in% names(slot.data)) {
			slot.data[,SGP_TARGET_PRIOR:=slot.data[SJ(ID, CONTENT_AREA, YEAR_INTEGER_TMP-1), mult="last"][["SGP_TARGET_2_YEAR"]]]
		}
		if (!"CONTENT_AREA_PRIOR" %in% names(slot.data) & "SGP_NORM_GROUP" %in% names(slot.data)) {
			slot.data[,CONTENT_AREA_PRIOR:=SGP_NORM_GROUP]
			levels(slot.data$CONTENT_AREA_PRIOR) <- sapply(strsplit(sapply(strsplit(sapply(strsplit(levels(slot.data$CONTENT_AREA_PRIOR), ";"), function(x) rev(x)[2]), "/"), function(x) rev(x)[1]), "_"), function(x) paste(head(x, -1), collapse=" "))
		}
		slot.data[,YEAR_INTEGER_TMP:=NULL]
 

###################################################################
### bubblePlot style 100 (Individual Student within Grade Chart)
###################################################################

	### Key slot.data for fast subsetting

	setkeyv(slot.data, c("VALID_CASE", "YEAR", "CONTENT_AREA", "DISTRICT_NUMBER"))

	### Start loops for bubblePlots

	for (year.iter in my.iters$tmp.years) {  ### Loop over year
	for (content_area.iter in my.iters$tmp.content_areas) { ### Loop over content areas
	for (district.iter in seq_along(my.iters$tmp.districts)) { ### Loop over districts (seq_along to get integer for anonymize)
	
	# Subset data

	tmp.bPlot.data.1 <- slot.data[SJ("VALID_CASE", year.iter, content_area.iter, my.iters$tmp.districts[district.iter])]

	tmp.unique.schools <- my.iters$tmp.schools[my.iters$tmp.schools %in% unique(tmp.bPlot.data.1$SCHOOL_NUMBER)]
	for (school.iter in seq_along(tmp.unique.schools)) { ### Loop over schools (seq_along to get integer for anonymize)

	# Subset data

	tmp.bPlot.data <- tmp.bPlot.data.1[SCHOOL_NUMBER==tmp.unique.schools[school.iter] & !is.na(SGP) & !is.na(SCALE_SCORE)]

	for (grade.iter in intersect(SGPstateData[[state]][["Student_Report_Information"]][["Grades_Reported"]][[content_area.iter]],
		sort(unique(tmp.bPlot.data$GRADE)))) { 
			
	bPlot.data <- subset(tmp.bPlot.data, GRADE==grade.iter)

	if (dim(bPlot.data)[1] > 0) {

	# Create labels

	bPlot.labels <- create.bPlot.labels(year.iter, "SCALE_SCORE_PRIOR", bubblePlot_LEVEL)

	if (content_area.iter %in% c('MATHEMATICS', 'READING')) {
		if (content_area.iter == 'MATHEMATICS') bPlot.test <- "MSP" else {
			if (grade.iter == '10') bPlot.test <- "HSPE" else bPlot.test <- "MSP"
		}
		data.BUBBLE_TIPS_LINES=list(
			paste(bPlot.data$SGP, " (", bPlot.data$SGP_TARGET_2_YEAR, ")", sep=""),
			paste(bPlot.data$ACHIEVEMENT_LEVEL, " (", bPlot.data$SCALE_SCORE, ")", sep=""),
			paste(bPlot.data$SGP_PRIOR, " (", bPlot.data$SGP_TARGET_PRIOR, ")", sep=""),
			paste(bPlot.data$ACHIEVEMENT_LEVEL_PRIOR, " (", bPlot.data$SCALE_SCORE_PRIOR, ")", sep=""))
		labels.BUBBLE_TIPS_LINES=list(
			paste(bPlot.labels$x.year.label, "Student Growth Percentile (Target)", sep=""),
			paste(bPlot.labels$y.year.label$CURRENT, " (Scale Score)", sep=""),
			paste(bPlot.labels$y.year, "Student Growth Percentile (Target)"),
			paste(bPlot.labels$y.year.label$PRIOR, " (Scale Score)", sep=""))
	} else { # EOC Maths
		bPlot.test <- "EOC" 
		data.BUBBLE_TIPS_LINES=list(
			bPlot.data$SGP,
			paste(bPlot.data$ACHIEVEMENT_LEVEL, " (", bPlot.data$SCALE_SCORE, ")", sep=""),
			bPlot.data$SCALE_SCORE_PRIOR)
		labels.BUBBLE_TIPS_LINES=list(
			paste(bPlot.labels$x.year.label, "Student Growth Percentile"),
			paste(bPlot.labels$y.year.label$CURRENT, " (Scale Score)", sep=""),
			paste(bPlot.labels$y.year, " Scale Score", sep=""))
	}

	# Create cutscore ranges

	my.content_area <- get.my.cutscore.year(state, content_area.iter, as.character(year.iter))
	tmp.y.range <- extendrange(c(bPlot.data[["SCALE_SCORE"]],
		SGPstateData[[state]][["Achievement"]][["Cutscores"]][[my.content_area]][[paste("GRADE", grade.iter, sep="_")]]), f=0.1)
	tmp.loss.hoss <- SGPstateData[[state]][["Achievement"]][["Knots_Boundaries"]][[content_area.iter]][[paste("loss.hoss", grade.iter, sep="_")]]
	tmp.y.ticks <- sort(c(max(tmp.loss.hoss[1], tmp.y.range[1]), min(tmp.loss.hoss[2], tmp.y.range[2]),
		SGPstateData[[state]][["Achievement"]][["Cutscores"]][[my.content_area]][[paste("GRADE", grade.iter, sep="_")]])) 

	# Get median SGP for grade, school, content area combination

	school.content_area.grade.median <- Washington_SGP@Summary[["SCHOOL_NUMBER"]][["SCHOOL_NUMBER__CONTENT_AREA__YEAR__GRADE__SCHOOL_ENROLLMENT_STATUS"]][
		SCHOOL_ENROLLMENT_STATUS=="Enrolled School: Yes" & SCHOOL_NUMBER==tmp.unique.schools[school.iter] & 
		CONTENT_AREA==content_area.iter & YEAR==year.iter & GRADE==grade.iter][["MEDIAN_SGP"]]
	if (length(school.content_area.grade.median)==0) school.content_area.grade.median <- NA


	### Custom draft message with two median SGP lines

	if (!is.na(school.content_area.grade.median)) {
		school.content_area.grade.median.line <- 
			c(paste("grid.lines(x=unit(", school.content_area.grade.median, ", 'native'), y=c(0.03,0.97), gp=gpar(col='blue', lwd=1.75, lty=2, alpha=0.75))", sep=""),
			paste("grid.text('Grade ", grade.iter, " Median = ", school.content_area.grade.median, "', x=unit(", school.content_area.grade.median,
				", 'native'), y=0.005, gp=gpar(col='blue', cex=0.85))", sep=""))
	} else {
		school.content_area.grade.median.line <- NULL
	}
	bPlot.message.style.100 <- c("grid.text(x=unit(50, 'native'), y=unit(mean(bubble_plot_data.Y), 'native'), 'CONFIDENTIAL \n STUDENT DATA -\n DO NOT DISTRIBUTE', 
			rot=-30, gp=gpar(col='grey80', cex=2, alpha=0.8, fontface=2))",
		school.content_area.grade.median.line)


	### Create bubblePlot ###

	bubblePlot(
		bubble_plot_data.X=bPlot.data[["SGP"]],
		bubble_plot_data.Y=bPlot.data[["SCALE_SCORE"]],
		bubble_plot_data.SUBSET=NULL,
		bubble_plot_data.INDICATE=NULL,
		bubble_plot_data.BUBBLE_CENTER_LABEL=NULL,
		bubble_plot_data.SIZE=rep(50, length(bPlot.data[["SGP"]])),
		bubble_plot_data.LEVELS=NULL, 
		bubble_plot_data.BUBBLE_TIPS_LINES=data.BUBBLE_TIPS_LINES,
		bubble_plot_labels.X=c("Growth", paste(bPlot.labels$x.year.label, "Student Growth Percentile")),
		bubble_plot_labels.Y=c("Achievement", bPlot.labels$y.year.label$CURRENT),
		bubble_plot_labels.SIZE=NULL,
		bubble_plot_labels.LEVELS=NULL, #levels(bubblePlot[["subset.factor"]]),
		bubble_plot_labels.BUBBLE_TIPS_LINES=labels.BUBBLE_TIPS_LINES,
		bubble_plot_labels.BUBBLE_TITLES=paste(bPlot.data$FIRST_NAME, bPlot.data$LAST_NAME),
		bubble_plot_titles.MAIN=paste(bPlot.test, "Student Growth Percentiles & Achievement"),
		bubble_plot_titles.SUB1=paste(bPlot.data$SCHOOL_NAME[1]), #'Test Elementary',#
		bubble_plot_titles.SUB2='Student Performance',
		bubble_plot_titles.SUB3=paste(bPlot.labels$x.year.label, "Grade", grade.iter, capwords(content_area.iter, special.words=wa.special.words)),
		bubble_plot_titles.LEGEND1="",
		bubble_plot_titles.LEGEND2_P1=NULL,
		bubble_plot_titles.LEGEND2_P2=NULL,

		bubble_plot_configs.BUBBLE_MIN_MAX=c(0.07, 0.07),
		bubble_plot_configs.BUBBLE_X_TICKS=c(1, seq(10,90,10), 99),
		bubble_plot_configs.BUBBLE_X_TICKS_SIZE=c(rep(0.7, 5), 1, rep(0.7, 5)),
		bubble_plot_configs.BUBBLE_Y_TICKS=tmp.y.ticks,
		bubble_plot_configs.BUBBLE_Y_BANDS=tmp.y.ticks,
		bubble_plot_configs.BUBBLE_Y_BAND_LABELS=SGPstateData[[state]][["Achievement"]][["Levels"]][["Labels"]],
		bubble_plot_configs.BUBBLE_SUBSET_INCREASE=0.00,
		bubble_plot_configs.BUBBLE_COLOR="blue",
		bubble_plot_configs.BUBBLE_SUBSET_ALPHA=list(Transparent=0.3, Opaque=0.9),
		bubble_plot_configs.BUBBLE_TIPS="TRUE",
		bubble_plot_configs.BUBBLE_PLOT_DEVICE="PDF",
		bubble_plot_configs.BUBBLE_PLOT_FORMAT=bPlot.format,
		bubble_plot_configs.BUBBLE_PLOT_LEGEND="FALSE",
		bubble_plot_configs.BUBBLE_PLOT_TITLE="TRUE",
		bubble_plot_configs.BUBBLE_PLOT_BACKGROUND_LABELS=NULL,
		bubble_plot_configs.BUBBLE_PLOT_EXTRAS=bPlot.message.style.100,
		bubble_plot_configs.BUBBLE_PLOT_NAME=paste(paste(gsub(" ", "_", bPlot.data$SCHOOL_NAME[1]), "Grade", grade.iter,
			year.iter, capwords(content_area.iter, special.words=wa.special.words), bPlot.labels$pdf.title, sep="_"), ".pdf", sep=""),
		bubble_plot_configs.BUBBLE_PLOT_PATH=file.path(bPlot.folder, year.iter, paste("District", gsub(" ", "_", bPlot.data$DISTRICT_NUMBER[1]), sep="_"), 
			"Grade-Level_Plots", paste("School", gsub(" ", "_", bPlot.data$SCHOOL_NUMBER[1]), sep="_")),
		bubble_plot_pdftk.CREATE_CATALOG=FALSE)

	} ## END if dim(bPlot.data)[1] > 0
	} ## END grade.iter loop
	} ## END school.iter loop
	} ## END district.iter loop
	} ## END content_area.iter loop
	} ## END year.iter loop
