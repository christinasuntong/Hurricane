library(tidyverse)
library(magrittr)
library(lubridate)

### reading data from buoy 44013  --  outside Boston harbor
### make URLs by splitting the URL into two pieces --
### "before the year" and "after the year"




buoy_coord <- data.frame(id = c("41037", "BFTN7", "JMPN7", "41110" , "41025", "HCGN7", "CLKN7", "44056"), 
                         lat = c(33.988,34.717,34.213,34.142, 35.010,35.209, 34.622,36.200 ),
                         lon = c(77.362,76.671,77.786, 77.715,75.454,75.704, 76.525, 75.714))

buoy_coord$lon <- buoy_coord$lon * -1
buoy_coord$id  %<>% tolower()



url1 <-  "https://www.ndbc.noaa.gov/view_text_file.php?filename="
url2 <- ".txt.gz&dir=data/historical/stdmet/"
urls <- c()

for (b in buoy_coord$id){
  urls <- append(urls, paste0(url1, b, "h2011", url2))
}
filenames <- buoy_coord$id
filenames


all_buoys <- c()
###  Read the data from the website

N <- length(urls)

for (i in 1:N){
  suppressMessages(  ###  This stops the annoying messages on your screen.
    file <- read_table(urls[i], col_names = TRUE)
    )
    file$date_time <- make_datetime(year = 2011, month = as.integer(file$MM), day = as.integer(file$DD), hour = as.integer(file$hh), min = as.integer(file$mm))
  
    file <- file[file$date_time>"2011-08-19 00:0:00 UTC",]
    file <- file[file$date_time<"2011-08-29 00:0:00 UTC",]
    file$id <- filenames[i]
    file$lat <- buoy_coord$lat[i]
    file$lon <- buoy_coord$lon[i]
    #create buoy id, lat, long
    #append to a complete dataset of all buoys
   
   all_buoys <- rbind(all_buoys, file)
   
   assign(filenames[i], file)
  
}
all_buoys$WSPD <- as.numeric(all_buoys$WSPD)

all_buoys %<>% filter(WSPD<99)

