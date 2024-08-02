#####################################################################################
###
### Scripts associated with 2010_2011 EOCT MATHEMATICS 1 & 2
###
#####################################################################################

EOC_MATHEMATICS_1.2010_2011.config = list(
	EOC_MATHEMATICS_1.2010_2011 =list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(c(3:6, 'EOCT'), c(3:7, 'EOCT'), c(4:8, 'EOCT')),
		sgp.norm.group.preference=1),
	EOC_MATHEMATICS_1.2010_2011 =list(  #Skip Year
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_1"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(5:8, 'EOCT')),
		sgp.norm.group.preference=2)
) ### END EOC_MATHEMATICS_1.2010_2011.config


EOC_MATHEMATICS_2.2010_2011.config = list(
	EOC_MATHEMATICS_2.2010_2011 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011"),
		sgp.grade.sequences=list(c(7, 'EOCT'), c(4:8, 'EOCT')), # 3:7, EOCT produces singular design matrix.  Only works with 7th grade prior ...
		sgp.norm.group.preference=1),
	EOC_MATHEMATICS_2.2010_2011 =list(  #Skip Year
		sgp.content.areas=c(rep("MATHEMATICS", 4), "EOC_MATHEMATICS_2"),
		sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2010_2011"),
		sgp.grade.sequences=list(c(4:7, 'EOCT'), c(5:8, 'EOCT')),
		sgp.norm.group.preference=2)
) ### END EOC_MATHEMATICS_2.2010_2011.config
