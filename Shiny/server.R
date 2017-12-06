#server.R

library(shiny)
library(ggplot2)
library(dplyr)

#SHIV'S CODE 
my.server <- shinyServer(function(input, output) {
    output$time.plot <- renderPlot({
      date_time <- date_time %>% 
        select(longitude, latitude, hour) %>%
        filter(hour == input$time) 
      
        ggplot(data = date_time) +
        geom_point(mapping = aes(x = longitude, y = latitude, color = hour)) +
        labs(title = "Bike Used During Specified Hour", xlab = "Longitude", ylab = "Latitude") +
        theme(axis.title = element_text(size = 12, face = "bold")) +
        theme(legend.text = element_text(size = 12, face = "bold")) +
        theme(plot.title = element_text(size = 20, face = "bold"))
    })
})
