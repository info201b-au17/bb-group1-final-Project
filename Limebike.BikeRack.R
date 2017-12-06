#Question 2 - Location of limebikes versus location of official bike parking (bike rack) locations
library(dplyr)
library(ggplot2)
library(mapproj)
library(ggmap)

#source script that pulls limebike data
source("DataIngest.R")

#set variable bikeData to the data pulled from function from DataIngest.R
bikeData <- getBikeData()

#Get bike & bike rack data from DataIngest.R
Racks.And.Bikes <- getBikeAndRackData()
    
#Seattle map
    #map.seattle_city <- qmap("seattle", zoom = 11, source="stamen", maptype="toner",darken = c(.3,"#BBBBBB"))
    seattle.map <- qmap("downtown seattle", zoom = 15, source="stamen", maptype = "toner-lite")
    
#Seattle map with bike & bike rack plot overlayed
    seattle.bikes <- seattle.map+geom_point(data=Racks.And.Bikes, 
                                              aes(longitude, latitude, col=Racks.And.Bikes$type), 
                                                alpha=0.6, size=0.7)+
                                                  labs(title="Downtown Seattle LimeBikes v. Bike Racks", color="Type")
    print(seattle.bikes)

#Stats data table creation
    bikes <- Racks.And.Bikes %>% filter(type == "bike")
    bikes <- transform(bikes, loc=paste(round(bikes$latitude, digits = 4), ", ", round(bikes$longitude, digits = 4)))
    num.bikes <- as.numeric(nrow(bikes))
    
    racks <- Racks.And.Bikes %>% filter(type == "rack")
    racks <- transform(racks, loc=paste(round(racks$latitude, digits = 4), ", ", round(racks$longitude, digits = 4)))
    num.racks <- as.numeric(nrow(racks))
    
    overlap <- merge(bikes, racks, by.x = "loc", by.y = "loc")
    num.overlap <- as.numeric(nrow(overlap))
    
    Count <- c(num.bikes, num.racks, num.overlap, num.bikes-num.overlap)
    Type <- c("Bikes", "Racks", "Bikes Parked At Rack", "Bikes Parked Randomly")
    parked.bikes <- data.frame(Type, Count)
    




