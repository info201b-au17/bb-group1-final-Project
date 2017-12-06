#SHIV'S CODE 
library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(mapproj)
library(leaflet)
library(tidyr)

source("../DataIngest.R")

data_time <- getTime()

my.server <- shinyServer(function(input, output) {
  output$time.plot <- renderPlot({
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
  
  #shannon's code, ploting on leaflet the location of the closest
  # 50 bikes to a station
  output$limeMap <- renderLeaflet({
    Names<- c("Husky Stadium", "University Street",
              "Capital Hill","International Station/Chinatown",
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
    print(building)
    pair<- c(as.character(building$Lat), as.character(building$Long))
    print(pair)
    print(typeof(building$Lat))
    points = getLimeBikeData(pair)
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = points)
  })
})
