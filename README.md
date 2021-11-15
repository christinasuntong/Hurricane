# Hurricane

Data from Buoy:
1.Station 44056 - Duck FRF, NC
https://www.ndbc.noaa.gov/view_text_file.php?filename=44056h2011.txt.gz&dir=data/historical/stdmet/


2.Station 41025 (LLNR 637) - Diamond Shoals, NC
https://www.ndbc.noaa.gov/view_text_file.php?filename=41025h2011.txt.gz&dir=data/historical/stdmet/


## Plots comparing wind speed from Irene_tracks and one bouy(mr41037)

library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(ggpubr)

ht <- hurr_tracks %>% filter(storm_id == "Irene-2011")

str(ht)
ht$date <- ymd_hm(ht$date)

wind_Irene <- ht %>% ggplot(aes(x = date, y = wind/1.94384))+ # turn knot to m/s
  geom_point()+
  geom_line()+
  ggtitle("Wind change of Irene")


## mr 41037 date within Irene
## 33.988N 77.362W 
mr41037 <- mr41037[-1, ]
date_mr41037 <- mr41037 %>% mutate(date = paste(`#YY`, `MM`, `DD`, `hh`, `mm`, sep = ""))
date_mr41037$date <- ymd_hm(date_mr41037$date)
date_mr41037$WSPD <- as.numeric(date_mr41037$WSPD)

date_l <- as.POSIXct(min(ht$date))
date_u <- as.POSIXct(max(ht$date))
rng <- interval(date_l, date_u)
August_mr41037 <- date_mr41037[date_mr41037$date %within% rng, ]

wind_mr41037 <- ggplot(August_mr41037, aes(x = date, y = WSPD), pch = 20)+
  geom_line()+
  geom_point()+
  ggtitle("Wind change by mr41037")

ggarrange(wind_Irene, wind_mr41037, ncol = 1, nrow = 2)
