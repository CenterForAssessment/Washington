###################################################################################################
###
### Script to convert SGP configurations for EOCT analyses to SGP_NORM_GROUP preference tables
###
###################################################################################################

### Load packages

require("data.table")
options(error=recover)

### utility function

configToSGPNormGroup <- function(sgp.config) {
	if ("sgp.norm.group.preference" %in% names(sgp.config)) {
		tmp.data.all <- data.table()
		for (g in 1:length(sgp.config$sgp.grade.sequences)) {
			l <- length(sgp.config$sgp.grade.sequences[[g]])
	        tmp.norm.group <- paste(tail(sgp.config$sgp.panel.years, l), paste(tail(sgp.config$sgp.content.areas, l), unlist(sgp.config$sgp.grade.sequences[[g]]), sep="_"), sep="/") #tmp.norm.group.baseline <- 
	        
	        tmp.data <- data.table(
				SGP_NORM_GROUP=paste(tmp.norm.group, collapse="; "), 
				# SGP_NORM_GROUP_BASELINE=paste(tmp.norm.group.baseline, collapse="; "),
				PREFERENCE= sgp.config$sgp.norm.group.preference*100)
						
	        if (length(tmp.norm.group) > 2) {
		        for (n in 1:(length(tmp.norm.group)-2)) {
					tmp.data <- rbind(tmp.data, data.table(
						SGP_NORM_GROUP=paste(tail(tmp.norm.group, -n), collapse="; "), 
						# SGP_NORM_GROUP_BASELINE=paste(tmp.norm.group.baseline, collapse="; "),
						PREFERENCE= (sgp.config$sgp.norm.group.preference*100)+n))
				}
			}
			tmp.data.all <- rbind(tmp.data.all, tmp.data)
		}
		return(unique(tmp.data.all))
	} else {
		return(NULL)
	}
}


### Load and create 2012_2013 EOC Configuration

source("EOCT/2010_2011/MATHEMATICS.R")
source("EOCT/2011_2012/MATHEMATICS.R")
# source("EOCT/2010_2011/BIOLOGY.R") # BIO starts in 2012
source("EOCT/2011_2012/BIOLOGY.R") # not calculating Science or Biology in 2013, but leave this in for WA_SGP_Norm_Group_Preference.Rdata
source("EOCT/2012_2013/MATHEMATICS.R")



WA_EOCT_2010_2011.config <- c(
                EOC_MATHEMATICS_1.2010_2011.config,
                EOC_MATHEMATICS_2.2010_2011.config)

WA_EOCT_2011_2012.config <- c(
                EOC_MATHEMATICS_1.2011_2012.config,
                EOC_MATHEMATICS_2.2011_2012.config,
                BIOLOGY.2011_2012.config)

WA_EOC_2012_2013.config <- c(
                EOC_MATHEMATICS_1.2012_2013.config,
                EOC_MATHEMATICS_2.2012_2013.config)

### Create configToNormGroup data.frame

tmp.configToNormGroup <- lapply(WA_EOCT_2010_2011.config, configToSGPNormGroup)

WA_SGP_Norm_Group_Preference_2010_2011 <- data.table(
					YEAR="2010_2011",
					rbindlist(tmp.configToNormGroup))


tmp.configToNormGroup <- lapply(WA_EOCT_2011_2012.config, configToSGPNormGroup)

WA_SGP_Norm_Group_Preference_2011_2012 <- data.table(
					YEAR="2011_2012",
					rbindlist(tmp.configToNormGroup))
					
					
tmp.configToNormGroup <- lapply(WA_EOC_2012_2013.config, configToSGPNormGroup)

WA_SGP_Norm_Group_Preference_2012_2013 <- data.table(
                                        YEAR="2012_2013",					
                                        rbindlist(tmp.configToNormGroup))					

WA_SGP_Norm_Group_Preference <- rbind(
			WA_SGP_Norm_Group_Preference_2010_2011,
			WA_SGP_Norm_Group_Preference_2011_2012,
			WA_SGP_Norm_Group_Preference_2012_2013
			)

WA_SGP_Norm_Group_Preference$SGP_NORM_GROUP <- as.factor(WA_SGP_Norm_Group_Preference$SGP_NORM_GROUP)


### Save result

setkey(WA_SGP_Norm_Group_Preference, YEAR, SGP_NORM_GROUP)
save(WA_SGP_Norm_Group_Preference, file="WA_SGP_Norm_Group_Preference.Rdata")
