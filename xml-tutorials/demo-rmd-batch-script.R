#####  EXAMPLE BATCH.R FILE      

getwd()  # make sure your files are here OR use setwd( "file/path" ) to change 
dir()    # double-check that files are in the current working directory 

## 2020 REPORT
url.2020 <- "https://docs.google.com/spreadsheets/d/1RoiO9bfpbXowprWdZrgtYXG9_WuK3NFemwlvDGdym7E/export?gid=1335284952&format=csv"
rmarkdown::render( input='salary-report.rmd', 
                   output_file = "ASU-2020-Salary-Report.HTML",
                   params = list( url = url.2020 ) )

## 2019 REPORT 
url.2019 <- "https://docs.google.com/spreadsheets/d/1RoiO9bfpbXowprWdZrgtYXG9_WuK3NFemwlvDGdym7E/export?gid=1948400967&format=csv"
rmarkdown::render( input='salary-report.rmd', 
                   output_file = "ASU-2019-Salary-Report.HTML",
                   params = list( url = url.2019 ) )