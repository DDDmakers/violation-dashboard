##Violation Dashboard Helpers File

#Load Libraries
library(shiny)
library(ggmap)
library(maps)
library(maptools)

#functions for maps
open.violations <- read.csv("openviolations.csv")
syracuse <- get_map(location="Syracuse NY", zoom = 13, color="bw")
syr.map <- ggmap(syracuse, extent = "device")
vacancy <- as.factor(open.violations$VacantBuilding)

#functions for closeout
closedViolations <- read.csv("ComplaintsDays.csv", stringsAsFactors = FALSE )
averageDays <- read.csv("AverageDays.csv", stringsAsFactors = F)
averageDays2 <- read.csv("AverageDays2.csv", stringsAsFactors = F)

#functions before Server begins for Frequency
dat <- read.csv( "Violation-Report.csv", stringsAsFactors=F )
violation.date <- as.Date( dat$Violation.Date, "%m/%d/%Y" )
gt.2012 <- violation.date > "2011-12-31"
dat <- dat[ gt.2012 , ]
violation.date <- as.Date( dat$Violation.Date, "%m/%d/%Y" )
closed.date <- as.Date( dat$Complaint.Close.Date, "%m/%d/%Y" )
duration <- closed.date - violation.date 
month.year <- cut( violation.date, breaks="month" )
month.year.name <- format( violation.date, "%b-%Y" )
total.complaints <- tapply( dat$Complaint.Type, month.year, length )
total.complaints[ is.na(total.complaints) ] <- 0
dat$month.year <- month.year


#Heatmap Functions
nov.parcel <- read.xlsx("Data/all data by property.csv")

##Code for heat maps
newyork <- readShapePoly( fn="Data/tl_2015_36_tract", proj4string=CRS("+proj=longlat"))
onondaga <- subset(newyork, subset=(COUNTYFP== "067" ))
tract.nums2<- c("000100","001000","001400","001500","001600","001701","001702","001800","001900",
                "000200","002000","002101","002300","002400","002700","002901",
                "000300","003000","003200","003400","003500","003601","003602","003800","003900",
                "000400","004000","004200","004301","004302","004400","004500","004600","004800","004900",
                "000501","005000","005100","005200","005300","005400","005500","005601","005602","005700","005800","005900",
                "000600","006000","006101","006102","006103","000700","000800","000900")
syracuse <- onondaga[ onondaga$TRACTCE %in% tract.nums2 , ]
roads <- readShapeLines( fn="Data/tl_2015_36067_roads", proj4string=CRS("+proj=longlat"))
road.nums2 <- c("S1100","S1200","S1630","S1710","S1740")
major.roads <- roads[ roads$MTFCC %in% as.factor(road.nums2),] 

##I've made this adjustment so I don't blow up our ShinyApp! The original roads file seemed to be too big. 
## Proportion of Delinquent Houses per Census Tract ## 
is.del <- nov.parcel$AmtDelinqu > 0
num.del     <- tapply( is.del, nov.parcel$CensusTract, sum, na.rm=T )
num.parcels <- tapply( is.del, nov.parcel$CensusTract, length )

# Because is.del is a logical expression, this function counts the entire count of TRUEs and FALSES minues NAs 
# and indexes according to Census Tract. This can be used to find proportions for all of my KPI. When I ran the 
# function for each variable, it ended up being 42017, which makes sense. 
prop.del <- num.del / num.parcels 

## Proportion of Seizable Properties per Census Tract"
seizable <- nov.parcel$SEIZB == "Y"
num.seizable <- tapply(seizable, nov.parcel$CensusTract,sum,na.rm=1)
prop.seizable <- num.seizable/num.parcels

## Proportion of SURA Properties per Census Tract
sura <- nov.parcel$SURA == "Y"
num.sura <- tapply(sura, nov.parcel$CensusTract,sum,na.rm=1)
prop.sura <- num.sura/num.parcels

## Proportion of Vacant Properties per Census Tract 
vacant <- nov.parcel$VacantBuilding == "Y"
num.vacant <- tapply(vacant, nov.parcel$CensusTract,sum,na.rm=1)
prop.vacant <- num.vacant/num.parcels

## Creating color.vector for heat map ## 
color.function <- colorRampPalette( c("light gray","firebrick4" ) )
col.ramp <- color.function( 11 )
# match the correct levels to the proper tracts

tract.id <- as.character(syracuse$TRACTCE)
this.order <- match( tract.id, tract.nums2 )

## Set Up For Heat Map of Delinquent Properties ##
color.vector.del <- cut( rank(prop.del), breaks=11, labels=col.ramp )
color.vector.del <- as.character( color.vector.del )
color.vec.del.ordered <- color.vector.del[ this.order ]

## Set Up For Heat Map of Seizable Properties ##
color.vector.seizable <- cut( rank(prop.seizable), breaks=11, labels=col.ramp )
color.vector.seizable <- as.character( color.vector.seizable )
color.vec.seizable.ordered <- color.vector.seizable[this.order]

## Set Up For Heat Map of SURA Properties ##
color.vector.sura <- cut( rank(prop.sura), breaks=11, labels=col.ramp )
color.vector.sura <- as.character( color.vector.sura)
color.vec.sura.ordered <- color.vector.sura[this.order]

## Set Up For Heat Map of Vacant Properties ##
color.vector.vacant <- cut( rank(prop.vacant), breaks=11, labels=col.ramp )
color.vector.vacant <- as.character( color.vector.vacant )
color.vec.vacant.ordered <- color.vector.vacant[ this.order ]