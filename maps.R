source("buoy import-a.R")



#MAP OF BUOY LOCATIONS -------------------------------------------------------------#
mapview(buoy_coord, xcol = "lon", ycol = "lat", crs = 4269, grid = FALSE)