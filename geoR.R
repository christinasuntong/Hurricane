##Variogram
library(geoR)
library(ggplot2)
library(viridis)
#Load data
s<-cbind(buoy_coord$lon, buoy_coord$lat)
mr41037 <- mr41037[160:167, ]
mr41037$WSPD <- as.numeric(mr41037$WSPD)
hist(mr41037$WSPD, breaks = 25)
#Here I only choose the data of mr41037 when landfall is coming.
#I think we can use all of buoys' data when landfall is coming to do variogram
df<-data.frame(long=s[,1],lat=s[,2], Y=mr41037$WSPD)
ggplot(df, aes(long, lat)) +
  borders("state") + xlim(-78,-74) + ylim(33.5,36.5) + coord_fixed() +
  geom_point(aes(color=Y)) +
  scale_color_gradientn(colors = viridis(10)) +
  xlab("")+ylab("")+labs(title = "wind speeds[m/s]")
#(The parameters are wrong, I'm still confused about it.Feel free to change anything.)
#Variogram and directional variogram
bins<-seq(0,100,l=1)
v1<-variog(coords = s,data = Y, uvec = bins)
plot(v1)

bins<-seq(0,1,.05)
v2<-variog4(coords = s,data = Y,uvec = bins)
plot(v2)

#Compute the MLE under isotropy
fit_mle1<-likfit(data = Y, coords = s,
                 fix.nugget = FALSE, nugget = 2,
                 cov.model = "exponential",
                 ini =c(2,0.2))
summary(fit_mle1)

#Compute the MLE under anisotropy
fit_mle2<-likfit(data = Y,coords = s,
                 fix.nugget = FALSE, nugget = 2,
                 cov.model = "exponential",
                 fix.psiA = FALSE, psiA = pi/4,
                 fix.psiR = FALSE, psiR = 2,
                 ini =c(2,0.2))
summary(fit_mle2)