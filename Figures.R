#ADD FUNCTIONS FOR YOUR FIGURES HERE
#WE CAN THEN CALL THE FUNCTIONS IN THE HurricaneIrene_Report.Rmd FILE
source("buoy import-a.R")
pacman::p_load(ggmap, maps, mapdata)

static_map <- function(){
  bbox = c(left = -81.0, bottom = 32.00, 
           right =-74.0 , top = 37.00)
  map <- get_stamenmap(bbox = bbox, maptype = "terrain-background", 
                 source= "stamen")
  
  ggmap(map) + 
    geom_point(data = buoy_coord, aes(x = lon, y = lat), color = "black", fill = "white", size = 3, shape = 21)+
    theme_nothing()
}