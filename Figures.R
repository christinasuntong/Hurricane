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
  
  ggsave("static_map.png")
}


library(knitr)
knit('ws_of_Irene&buoys.Rmd', tangle=TRUE)
source("ws_of_Irene&buoys.R")

ws_Irene <- function(){
  Irene_t %>% ggplot(aes(x = date, y = wind/1.94384))+ # turn knot to m/s
    # geom_point()+
    scale_y_continuous(name="WSPD")+
    geom_line()+
    ggtitle("Wind change of Irene")+
    theme(plot.title = element_text(size = 25, face = "bold"))
}

ws_buoys <- function(){
  ggplot(data = all_buoys, mapping = aes(group = id, color = id, x = date_time, y = WSPD))+
    geom_line()+
    ggtitle("Wind speed of buoys")+
    theme(plot.title = element_text(size = 30, face = "bold"))+ 
    theme(legend.text=element_text(size=20))+
    facet_grid(id ~. )+
    theme(legend.position = "none")
}
