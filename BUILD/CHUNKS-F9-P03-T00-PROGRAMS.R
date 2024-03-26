#' @title 
#'   Build table F9-P03-T00-PROGRAMS
#' 
#' @description 
#'   Generate a 1:1 table for the relational database.
#' 
#' @export 
BUILD_F9_P03_T00_PROGRAMS <- function( doc, url )
{


####----------------------------------------------------
####     KEYS
####----------------------------------------------------


## OBJECT ID

OBJECTID <- get_object_id( url )


## URL

URL <- url


## RETURN VERSION

RETURN_VERSION <- xml2::xml_attr( doc, attr='returnVersion' )


## VARIABLE NAME:  ORG_EIN
## DESCRIPTION:  Orgainization Employer Identification Number (EIN)
## LOCATION:  F990-PC-PART-00-SECTION-D
## TABLE:  F9-P00-T00-HEADER
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

ORG_EIN <- xml2::xml_text( xml2::xml_find_all( doc, '/Return/ReturnHeader/Filer/EIN' ) )



## VARIABLE NAME:  ORG_NAME_L1
## DESCRIPTION:  Name of Filing Organization (line 1)
## LOCATION:  F990-PC-PART-00-SECTION-C
## TABLE:  F9-P00-T00-HEADER
## VARIABLE TYPE:  text
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnHeader/Filer/Name/BusinessNameLine1'
V2 <- '//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine1'
V3 <- '//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt'
TEMP_ORG_NAME_L1 <- paste( V1, V2, V3 , sep='|' )
ORG_NAME_L1 <- xml2::xml_text( xml2::xml_find_all( doc, TEMP_ORG_NAME_L1 ) )



## VARIABLE NAME:  ORG_NAME_L2
## DESCRIPTION:  Name of Filing Organization (line 2)
## LOCATION:  F990-PC-PART-00-SECTION-C
## TABLE:  F9-P00-T00-HEADER
## VARIABLE TYPE:  text
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnHeader/Filer/Name/BusinessNameLine2'
V2 <- '//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine2'
V3 <- '//Return/ReturnHeader/Filer/BusinessName/BusinessNameLine2Txt'
TEMP_ORG_NAME_L2 <- paste( V1, V2, V3 , sep='|' )
ORG_NAME_L2 <- xml2::xml_text( xml2::xml_find_all( doc, TEMP_ORG_NAME_L2 ) )



## VARIABLE NAME:  RETURN_TYPE
## DESCRIPTION:  Return type
## LOCATION:  F990-PC-PART-00-LINE-00
## TABLE:  F9-P00-T00-HEADER
## VARIABLE TYPE:  text
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnHeader/ReturnType'
V2 <- '//Return/ReturnHeader/ReturnTypeCd'
TEMP_RETURN_TYPE <- paste( V1, V2 , sep='|' )
RETURN_TYPE <- xml2::xml_text( xml2::xml_find_all( doc, TEMP_RETURN_TYPE ) )



## VARIABLE NAME:  TAX_YEAR
## DESCRIPTION:  Tax year
## LOCATION:  F990-PC-PART-00-SECTION-A
## TABLE:  F9-P00-T00-HEADER
## VARIABLE TYPE:  date
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnHeader/TaxYear'
V2 <- '//Return/ReturnHeader/TaxYr'
TEMP_TAX_YEAR <- paste( V1, V2 , sep='|' )
TAX_YEAR <- xml2::xml_text( xml2::xml_find_all( doc, TEMP_TAX_YEAR ) )



######----------------------------------------------------
######
######    1:1 TABLE VARIABLES
######
######----------------------------------------------------


## VARIABLE NAME:  F9_03_INFO_SCHED_O_X
## DESCRIPTION:  Was Schedule O used to respond to any part of Part III?
## LOCATION:  F990-PC-PART-03-LINE-00
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  checkbox
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/InfoInScheduleOPartIII'
V2 <- '//Return/ReturnData/IRS990/InfoInScheduleOPartIIIInd'
V3 <- '//Return/ReturnData/IRS990EZ/InfoInScheduleOPartIII'
V4 <- '//Return/ReturnData/IRS990EZ/InfoInScheduleOPartIIIInd'
V_INFO_SCHED_O_X <- paste( V1, V2, V3, V4 , sep='|' )
F9_03_INFO_SCHED_O_X <- xml2::xml_text( xml2::xml_find_all( doc, V_INFO_SCHED_O_X ) )
if( length( F9_03_INFO_SCHED_O_X ) > 1 )
{ 
  create_record( varname=F9_03_INFO_SCHED_O_X, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_INFO_SCHED_O_X <-  paste0( '{', F9_03_INFO_SCHED_O_X, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_CODE
## DESCRIPTION:  IRS990 - Activity code
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/ActivityCd'
V2 <- '//Return/ReturnData/IRS990/ActivityCode'
V3 <- '//Return/ReturnData/IRS990/Form990PartIII/ActivityCode'
V_PROG_CODE <- paste( V1, V2, V3 , sep='|' )
F9_03_PROG_CODE <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_CODE ) )
if( length( F9_03_PROG_CODE ) > 1 )
{ 
  create_record( varname=F9_03_PROG_CODE, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_CODE <-  paste0( '{', F9_03_PROG_CODE, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_DESC
## DESCRIPTION:  Program Accomplishment Description
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  text
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/Desc'
V2 <- '//Return/ReturnData/IRS990/Description'
V3 <- '//Return/ReturnData/IRS990/Form990PartIII/Description'
V4 <- '//Return/ReturnData/IRS990/ProgramServiceAccomplishments/DescriptionProgramServiceAccom'
V_PROG_DESC <- paste( V1, V2, V3, V4 , sep='|' )
F9_03_PROG_DESC <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_DESC ) )
if( length( F9_03_PROG_DESC ) > 1 )
{ 
  create_record( varname=F9_03_PROG_DESC, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_DESC <-  paste0( '{', F9_03_PROG_DESC, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_EXP
## DESCRIPTION:  Program Accomplishment Expenses
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/Expense'
V2 <- '//Return/ReturnData/IRS990/ExpenseAmt'
V3 <- '//Return/ReturnData/IRS990/Form990PartIII/Expense'
V4 <- '//Return/ReturnData/IRS990/Form990PartIII/TotalOfOtherProgramServiceExp'
V5 <- '//Return/ReturnData/IRS990/ProgramServiceAccomplishments/ProgramServiceExpenses'
V_PROG_EXP <- paste( V1, V2, V3, V4, V5 , sep='|' )
F9_03_PROG_EXP <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_EXP ) )
if( length( F9_03_PROG_EXP ) > 1 )
{ 
  create_record( varname=F9_03_PROG_EXP, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_EXP <-  paste0( '{', F9_03_PROG_EXP, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_GRANT
## DESCRIPTION:  Form990 Part III - Grants
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/Form990PartIII/Grants'
V2 <- '//Return/ReturnData/IRS990/Form990PartIII/TotalOfOtherProgramServiceGrnt'
V3 <- '//Return/ReturnData/IRS990/GrantAmt'
V4 <- '//Return/ReturnData/IRS990/Grants'
V5 <- '//Return/ReturnData/IRS990/ProgramServiceAccomplishments/GrantsAndAllocations'
V6 <- '//Return/ReturnData/IRS990EZ/GrantAmt'
V7 <- '//Return/ReturnData/IRS990EZ/Grants'
V_PROG_GRANT <- paste( V1, V2, V3, V4, V5, V6, V7 , sep='|' )
F9_03_PROG_GRANT <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_GRANT ) )
if( length( F9_03_PROG_GRANT ) > 1 )
{ 
  create_record( varname=F9_03_PROG_GRANT, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_GRANT <-  paste0( '{', F9_03_PROG_GRANT, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_REV
## DESCRIPTION:  Form990 Part III - Revenue
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/Form990PartIII/Revenue'
V2 <- '//Return/ReturnData/IRS990/Form990PartIII/TotalOfOtherProgramServiceRev'
V3 <- '//Return/ReturnData/IRS990/Revenue'
V4 <- '//Return/ReturnData/IRS990/RevenueAmt'
V_PROG_REV <- paste( V1, V2, V3, V4 , sep='|' )
F9_03_PROG_REV <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_REV ) )
if( length( F9_03_PROG_REV ) > 1 )
{ 
  create_record( varname=F9_03_PROG_REV, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_REV <-  paste0( '{', F9_03_PROG_REV, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_EXP_OTH_TOT
## DESCRIPTION:  Total of other program service expense
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/TotalOfOtherProgramServiceExp'
V2 <- '//Return/ReturnData/IRS990/TotalOtherProgSrvcExpenseAmt'
V_PROG_EXP_OTH_TOT <- paste( V1, V2 , sep='|' )
F9_03_PROG_EXP_OTH_TOT <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_EXP_OTH_TOT ) )
if( length( F9_03_PROG_EXP_OTH_TOT ) > 1 )
{ 
  create_record( varname=F9_03_PROG_EXP_OTH_TOT, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_EXP_OTH_TOT <-  paste0( '{', F9_03_PROG_EXP_OTH_TOT, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_GRANT_OTH_TOT
## DESCRIPTION:  Total of other program service grants
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/TotalOfOtherProgramServiceGrnt'
V2 <- '//Return/ReturnData/IRS990/TotalOtherProgSrvcGrantAmt'
V_PROG_GRANT_OTH_TOT <- paste( V1, V2 , sep='|' )
F9_03_PROG_GRANT_OTH_TOT <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_GRANT_OTH_TOT ) )
if( length( F9_03_PROG_GRANT_OTH_TOT ) > 1 )
{ 
  create_record( varname=F9_03_PROG_GRANT_OTH_TOT, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_GRANT_OTH_TOT <-  paste0( '{', F9_03_PROG_GRANT_OTH_TOT, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_REV_OTH_TOT
## DESCRIPTION:  Total of other program service revenue
## LOCATION:  F990-PC-PART-03-LINE-04-ABCD
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/TotalOfOtherProgramServiceRev'
V2 <- '//Return/ReturnData/IRS990/TotalOtherProgSrvcRevenueAmt'
V_PROG_REV_OTH_TOT <- paste( V1, V2 , sep='|' )
F9_03_PROG_REV_OTH_TOT <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_REV_OTH_TOT ) )
if( length( F9_03_PROG_REV_OTH_TOT ) > 1 )
{ 
  create_record( varname=F9_03_PROG_REV_OTH_TOT, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_REV_OTH_TOT <-  paste0( '{', F9_03_PROG_REV_OTH_TOT, '}', collapse=';' ) 
} 




## VARIABLE NAME:  F9_03_PROG_EXP_TOT
## DESCRIPTION:  Total program service expense
## LOCATION:  F990-PC-PART-03-LINE-04E
## TABLE:  F9-P03-T00-PROGRAMS
## VARIABLE TYPE:  numeric
## PRODUCTION RULE:  NA

V1 <- '//Return/ReturnData/IRS990/Form990PartIII/TotalProgramServiceExpense'
V2 <- '//Return/ReturnData/IRS990/TotalProgramServiceExpense'
V3 <- '//Return/ReturnData/IRS990/TotalProgramServiceExpensesAmt'
V4 <- '//Return/ReturnData/IRS990/TotalProgramServicesExpenses'
V5 <- '//Return/ReturnData/IRS990EZ/TotalProgramServiceExpenses'
V6 <- '//Return/ReturnData/IRS990EZ/TotalProgramServiceExpensesAmt'
V_PROG_EXP_TOT <- paste( V1, V2, V3, V4, V5, V6 , sep='|' )
F9_03_PROG_EXP_TOT <- xml2::xml_text( xml2::xml_find_all( doc, V_PROG_EXP_TOT ) )
if( length( F9_03_PROG_EXP_TOT ) > 1 )
{ 
  create_record( varname=F9_03_PROG_EXP_TOT, ein=ORG_EIN, year=TAX_YEAR, url=URL )
  F9_03_PROG_EXP_TOT <-  paste0( '{', F9_03_PROG_EXP_TOT, '}', collapse=';' ) 
} 




var.list <- 
namedList(OBJECTID,URL,RETURN_VERSION,ORG_EIN,ORG_NAME_L1,ORG_NAME_L2,RETURN_TYPE,TAX_YEAR,F9_03_INFO_SCHED_O_X,F9_03_PROG_CODE,F9_03_PROG_DESC,F9_03_PROG_EXP,F9_03_PROG_GRANT,F9_03_PROG_REV,F9_03_PROG_EXP_OTH_TOT,F9_03_PROG_GRANT_OTH_TOT,F9_03_PROG_REV_OTH_TOT,F9_03_PROG_EXP_TOT)
df <- as.data.frame( var.list )


return( df )


}


