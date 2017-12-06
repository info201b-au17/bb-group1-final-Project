#SHIV'S CODE 
library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(mapproj)

my.server <- shinyServer(function(input, output) {
  output$time.plot <- renderPlot({
    date_time <- date_time %>% 
      select(longitude, latitude, hour) %>%
      filter(hour >= input$time) 
    
    seattle.map <- get_map(location = "university of washington", maptype = "satellite", source = "google", zoom = 15)
    seattle.bikes <- ggmap(seattle.map) + 
      geom_point(data = date_time, mapping = aes(x = longitude, y = latitude, color = hour)) +
      labs(title = "Bikes Used During Last Specified Hour", xlab = "Longitude", ylab = "Latitude") +
      theme(axis.title = element_text(size = 12, face = "bold")) +
      theme(legend.text = element_text(size = 12, face = "bold")) +
      theme(plot.title = element_text(size = 20, face = "bold"))
    print(seattle.bikes)
  })
})
