# Our own buoy import
# - Station ORIN7
# - Station 44099
# - Station 44089
# - Station ACYN4
# - Station 44091
# - Station BRHC3


library(tidyverse)
library(magrittr)


b <- tolower(c("ORIN7", "44099", "44089", "ACYN4","44091",  "BRHC3"))

url1 <- "http://www.ndbc.noaa.gov/view_text_file.php?filename="
url1_list <- c()

for (buoy in b){
  url1_list <- append(url1_list, paste0(url1, buoy,"h")) }



url2 <- ".txt.gz&dir=data/historical/stdmet/"
years <- 2011

urls <- c()
for (url in url1_list){
  urls <-append(urls, paste0(url, years, url2, sep = ""))
}


N <- length(urls)

for (i in 1:N){
  suppressMessages(  ###  This stops the annoying messages on your screen.
  file <- read_table(urls[i], col_names = TRUE)
  )
  
  
  if(colnames(file)=="YY"){
    yr = file[1,1]
    yr = paste0("19", yr)
    file %<>% rename(YYYY=YY)
    file$YYYY <- rep(yr, nrow(file))
  }
  
  
  assign(filenames[i], file)
  
  # file <- get(filenames[i]) ## get() returns the value of an object
  ## when the arguement is the name of the 
  ## object -- as a string.
  
  ## example:
  ## a <- c(1,3)
  ## b <- get(a)  throws and error
  ##
  ## b <- get('a')
  ## b
  ## [1] 1 3
  
  
  
  
  # put '19' in front of 2 digit years
  # check that all columns are included
  # filter down to only the 1 daily observation that you want
  # etc etc etc
  
  # if(i == 1){
  #   MR <- file
  # }
  # 
  # else{
  #   MR <- rbind.data.frame(MR, file)
  # }
  
  
  
}

