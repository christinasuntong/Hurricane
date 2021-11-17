##Variogram
library(geoR)
library(ggplot2)
library(viridis)
#Load data
Y<-all_buoys$WSPD
#Here I only choose the data of mr41037 when landfall is coming.
#I think we can use all of buoys' data when landfall is coming to do variogram
df<-data.frame(long=all_buoys$lon,lat=all_buoys$lat, Y=all_buoys$WSPD)
ggplot(df, aes(long, lat)) +
  borders("state") + xlim(-78,-74) + ylim(33.5,36.5) + coord_fixed() +
  geom_point(aes(color=Y)) +
  scale_color_gradientn(colors = viridis(10)) +
  xlab("")+ylab("")+labs(title = "wind speeds[m/s]")
#(The parameters are wrong, I'm still confused about it.Feel free to change anything.)
#Variogram and directional variogram
library(sp)
coordinates(df)<-~long + lat
library(rgdal)
proj4string(df) = "+proj=longlat +datum=WGS84"
UTM<-spTransform(df, CRS=CRS("+proj=utm +zone=35V+north+ellps=WGS84+datum=WGS84"))
UTM1<-as.data.frame(UTM)
coords<-UTM1[, 2:3]
var.geoR<-variog(coords = coords, data = Y, estimator.type = 'classical')
plot(var.geoR)
v1<-variog(df, coords = df)
plot(v1)
