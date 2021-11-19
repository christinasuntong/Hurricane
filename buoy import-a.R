pacman::p_load(tidyverse, magrittr, lubridate, ggplot2, maps, mapdata)


buoy_coord <- data.frame(id = c("41037", "BFTN7","JMPN7","HCGN7","CLKN7","41013","44099","41004","WATS1",   "MNPV2"), 
                         lat = c(33.988, 34.717, 34.213, 35.209, 34.622, 33.441, 36.915,  32.502, 34.335,   36.778      ),
                         lon = c(77.362, 76.671, 77.786, 75.704, 76.525, 77.764, 75.722,  79.099, 80.7027,   76.302))

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





