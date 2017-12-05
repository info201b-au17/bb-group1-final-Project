#ui.R
library(shiny)

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Seattle Limebike Data"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(

    ),
    
    #Main panel
    mainPanel(

    )
  )
))

#SHIV'S CODE
my.ui <- shinyUI(fluidPage(
  
  # Creates a title for the page
  titlePanel("Last Time Bike was Used"),
  
  # Creates two widgets for user input
  sidebarLayout(
    sidebarPanel(
      sliderInput("time",
                  "Insert Hour:",
                  00, 23, 00)
    ),
    
    # Ouputs the plot to the website.
    mainPanel(
      plotOutput("time.plot")
    )
  )
))
