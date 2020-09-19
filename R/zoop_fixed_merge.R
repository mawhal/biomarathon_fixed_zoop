# 
#
# Merge data on fixed zooplankton samples with sample metadata (airtable+forms)
#
# created by Matt Whalen - 2020.07.31
#


library(tidyverse)

# read data
air    <- read_csv("data/zooplankton/airtable_fixedzoop_20200731.csv")
forms  <- read_csv("data/zooplankton/BioSiege Summary - Zoop_Nets_20200731.csv", skip=2)
report <- read_csv("data/zooplankton/cahs/CAHS_t0271.csv")

af <- left_join( air, forms )
afr <- left_join( af,report )

write_csv( afr, "data/zooplankton/CAHS_report_merged.csv" )

# diagnostic plots
ggplot( afr, aes(x=`Sample Depth`,y=`Net Revolutions`) ) + geom_point()

