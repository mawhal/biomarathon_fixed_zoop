# 
#
# fixed zooplankton samples with sample metadata (airtable+forms)
#
# created by Matt Whalen - 2020.07.31
#


library(tidyverse)
library(lubridate)
library(vegan)

# read data
d <- read_csv( "data/zooplankton/CAHS_report_merged.csv" )
d <- d %>% 
  pivot_longer( cols=annelid.trochophore:Insecta )
d <-d %>%
  mutate( date.time=ymd_hms(paste(Date,`Sample Time`)) ) %>% 
  # standardize
  mutate( mouth.area = 1, volume = as.numeric(`Sample Depth`)*mouth.area ) %>% 
  mutate(value=value/volume)
  group_by(`Collection Code`,`Survey Code`,Date, `Sample Time`, date.time) 
  
# total abundance
dsum <- d %>% 
  group_by(`Collection Code`,`Survey Code`,Date, `Sample Time`, date.time) %>% 
  summarise( N = sum(value, na.rm=T) ) 

ggplot(dsum, aes( x=date.time, y=N) ) + geom_path() + geom_point() + 
  scale_y_log10()
  
# abundance per group

# pivot wider and nmds
dwide <- d %>% 
  pivot_wider( id_cols = c(`Collection Code`,`Survey Code`,Date, `Sample Time`, date.time) )

dcomm <- dwide[-c(10,11),-c(1:5)]
dcomm[ is.na(dcomm) ] <- 0
mds1 <- metaMDS(dcomm)
plot(mds1)
scores(mds1)
mdsdf <- cbind( dwide[-c(10,11),c(1:5)], mds1$points )
ggplot( mdsdf, aes(x=MDS1,y=MDS2) ) + 
  geom_point(  aes(col=as.factor(Date)),size=5) #+
  # geom_segment(data=vec.pos.strong,aes(x=0,xend=MDS1,y=0,yend=MDS2),
  #              arrow = arrow(length = unit(0.2, "cm")),colour="black", alpha=0.5) + 
  # geom_text_repel(data=vec.pos.strong,aes(x=MDS1,y=MDS2,label=family),
  #                 point.padding=0.9, box.padding = 0.1,
  #                 size=4, col="black", segment.color="slategray", segment.alpha = 0.5) +
  # # xlim(xlimits) + ylim(ylimits) +
  theme_classic() + theme( axis.line = element_blank() )


  
# diagnostic plots
ggplot( d, aes(x=`Sample Depth`,y=`Net Revolutions`) ) + geom_point()



# calculate volume, roughly from depth 
d <- d %>% 
  mutate( mouth.area = 1, volume = as.numeric(`Sample Depth`)*mouth.area ) 
d$volume 




