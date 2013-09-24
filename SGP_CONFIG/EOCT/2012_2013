#####################################################################################
###
### Scripts associated with 2012_2013 EOC MATHEMATICS 1 & 2
###
#####################################################################################

EOC_MATHEMATICS_1.2012_2013.config = list(  
  EOC_MATHEMATICS_1.2012_2013 =list(		# Consecutive Year 
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


EOC_MATHEMATICS_2.2012_2013.config = list(	
  EOC_MATHEMATICS_2.2012_2013 = list(		# Consecutive Year with EOC 1 as prior
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_1", "EOC_MATHEMATICS_2"),	
    sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012", "2012_2013"),		
    sgp.grade.sequences=list(c(3:6, 7, 8), c(3:7, 8, 9), c(4:8, 9, 10)),	
    sgp.norm.group.preference=1),	
  EOC_MATHEMATICS_2.2012_2013 = list(		# Consecutive Year
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),		
    sgp.panel.years=c("2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2011_2012", "2012_2013"),		
    sgp.grade.sequences=list(c(3:7, 8), c(3:8, 9)), # 3:7, EOCT produces singular design matrix.  Only works with 7th grade prior ...
    ## Does this still hold true if we don't use EOCT? 
    sgp.norm.group.preference=2),	
  EOC_MATHEMATICS_2.2012_2013 =list(  # Skip Year		
    sgp.content.areas=c(rep("MATHEMATICS", 6), "EOC_MATHEMATICS_2"),		
    sgp.panel.years=c("2005_2006", "2006_2007", "2007_2008", "2008_2009", "2009_2010", "2010_2011", "2012_2013"),		
    sgp.grade.sequences=list(c(3:8, 10)),		
    sgp.norm.group.preference=3)
  ) ### END EOC_MATHEMATICS_2.2012_2013.config
