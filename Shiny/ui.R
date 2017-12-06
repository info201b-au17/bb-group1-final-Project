#ui.R
library(shiny)

# Define UI for application
shinyUI(fluidPage(
  navbarPage("My Application",
    #Shannon's code, tab 1
    tabPanel("Question 1",
      titlePanel("Seattle Limebike Data"),
      sidebarLayout(
        sidebarPanel(
          selectInput("building", "Chose a station:", 
                  choices = c("Husky Stadium", "University Street",
                              "Capital Hill","International Station/Chinatown",
                              "Stadium", "Sodo")),
          helpText("Lime Bikes near this locations")
        ),
        mainPanel(
          leafletOutput("limeMap"),
          p()
        )
      )
    ),
    #shiv's code, question 2
    tabPanel("Question 2",
          sidebarLayout(
            sidebarPanel(
              sliderInput("time",
                          "Insert Hour:",
                          00, 23, 00)
            ),
            mainPanel(
              plotOutput("time.plot")
            )
          )
    ),
    #question 3
    #I just put this here for a place holder, replace it with whatever
    #you need
    tabPanel("Question 3",
        sidebarLayout(
          sidebarPanel(),
          mainPanel("limeMap")
          
        
        )
             
    )
 )
))

