#server.R
library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(mapproj)
library(leaflet)
library(tidyr)

source("../DataIngest.R")


#Question 2 - Shiv's code


my.server <- shinyServer(function(input, output) {
  #question 2
  output$time.plot <- renderPlot({
    data_time <- getTime()
    data_time <- data_time %>% 
      select(longitude, latitude, hour) %>%
      filter(hour >= input$time) 
    
    seattle.map <- get_map(location = "university of washington", maptype = "satellite", source = "google", zoom = 15)
    seattle.bikes <- ggmap(seattle.map) + 
      geom_point(data = data_time, mapping = aes(x = longitude, y = latitude, color = hour)) +
      labs(title = "Bikes Used During Last Specified Hour", xlab = "Longitude", ylab = "Latitude") +
      theme(axis.title = element_text(size = 12, face = "bold")) +
      theme(legend.text = element_text(size = 12, face = "bold")) +
      theme(plot.title = element_text(size = 20, face = "bold"))
    print(seattle.bikes)
})

#Question 3 - Riddhi's code
  #pull data from DataIngest and create concise dataframes
  

  
  #output#1 - returns map with bike & bike rack locations
  output$BikeRackPlot <- renderPlot({
    Racks.And.Bikes <- getBikeAndRackData()
    bikes <- Racks.And.Bikes %>% filter(type == "bike")
    racks <- Racks.And.Bikes %>% filter(type == "rack")
    seattle.map <- get_map(location = "downtown seattle", zoom = 15, source="stamen", maptype = "toner-lite")
    
    if(length(input$type) == 1){
      if(input$type == "bike"){
        seattle.bikes <- ggmap(seattle.map)+geom_point(bikes, 
                                                       aes(longitude, latitude, col=bikes$type), 
                                                       alpha=0.6, size=0.7)+
          labs(title="Downtown Seattle LimeBikes v. Bike Racks", color="Type")
      }else if(input$type == "rack"){
        seattle.bikes <- ggmap(seattle.map)+geom_point(racks, 
                                                       aes(longitude, latitude, col=racks$type), 
                                                       alpha=0.6, size=0.7)+
          labs(title="Downtown Seattle LimeBikes v. Bike Racks", color="Type")
      }
    }else{
      seattle.bikes <- ggmap(seattle.map)+geom_point(Racks.And.Bikes, 
                                                     aes(longitude, latitude, col=Racks.And.Bikes$type), 
                                                     alpha=0.6, size=0.7)+
        labs(title="Downtown Seattle LimeBikes v. Bike Racks", color="Type")
    }
    return(seattle.bikes)
  })
  #output#2 - Creating Table with Bike & Bike Rack stats
  output$BikeRackTable <- renderTable({
    bikes <- transform(bikes, loc=paste(round(bikes$latitude, digits = 4), ", ", round(bikes$longitude, digits = 4)))
    num.bikes <- as.numeric(nrow(bikes))
    
    racks <- transform(racks, loc=paste(round(racks$latitude, digits = 4), ", ", round(racks$longitude, digits = 4)))
    num.racks <- as.numeric(nrow(racks))
    
    #merge to create column that is shared by racks and bikes 
    overlap <- merge(bikes, racks, by.x = "loc", by.y = "loc")
    num.overlap <- as.numeric(nrow(overlap))
    
    #get stats
    Count <- c(num.bikes, num.racks, num.overlap, num.bikes-num.overlap)
    Type <- c("Bikes", "Racks", "Bikes Parked At Rack", "Bikes Parked Randomly")
    
    #make df
    parked.bikes <- data.frame(Type, Count)
    return(parked.bikes)
  })
  
  #Question 1 - shannon's code, ploting on leaflet the location of the closest
  # 50 bikes to a station
  output$limeMap <- renderLeaflet({
    Names<- c("Husky Stadium", "University Street",
              "Capitol Hill","International Station/Chinatown",
              "Stadium","Sodo"
    )
    Lat<- c("47.6503", "47.607922", "47.620911",
            "47.59850", "47.591961", "47.581309"
    )
    Long<- c("-122.3016", "-122.336058", "-122.320704",
             "-122.328001", "-122.327315", "-122.327358"
    )
    buildingInfo<-data.frame(Names, Lat, Long)
    building = buildingInfo %>% filter(Names == input$building) %>% select(Lat, Long)
    pair<- c(as.character(building$Lat), as.character(building$Long))
    points = getLimeBikeData(pair)
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = points)
  })

})
