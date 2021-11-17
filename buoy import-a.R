library(tidyverse)
library(magrittr)
library(lubridate)

### reading data from buoy 44013  --  outside Boston harbor
### make URLs by splitting the URL into two pieces --
### "before the year" and "after the year"


buoys <- c("41037", "41110", "41025", "44056", "BFTN7", "CLKN7","JMPN7","HCGN7")
buoys %<>% tolower() 

buoy_coord <- data.frame(id = c("41037", "BFTN7", "JMPN7", "41110" , "41025", "HCGN7", "CLKN7", "44056"), 
                         lat = c(33.988,34.717,34.213,34.142, 35.010,35.209, 34.622,36.200 ),
                         lon = c(77.362,76.671,77.786, 77.715,75.454,75.704, 76.525, 75.714))

buoy_coord$lon <- buoy_coord$lon * -1




url1 <-  "https://www.ndbc.noaa.gov/view_text_file.php?filename="
url2 <- ".txt.gz&dir=data/historical/stdmet/"
urls <- c()

for (b in buoys){
  urls <- append(urls, paste0(url1, b, "h2011", url2))
}



filenames <- str_c("mr", buoys, sep = "")

###  Read the data from the website

N <- length(urls)

for (i in 1:N){
  suppressMessages(  ###  This stops the annoying messages on your screen.
    file <- read_table(urls[i], col_names = TRUE)
    )
    file$date_time <- make_datetime(year = 2011, month = as.integer(file$MM), day = as.integer(file$DD), hour = as.integer(file$hh), min = as.integer(file$mm))
  
    file <- file[file$date_time>"2011-08-19 00:0:00 UTC",]
    file <- file[file$date_time<"2011-08-29 00:0:00 UTC",]

    #create buoy id, lat, long
    #append to a complete dataset of all buoys
   
   
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

rbind(mr41025, mr41037)
