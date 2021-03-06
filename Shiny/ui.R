#ui.R
library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(mapproj)
library(leaflet)
library(tidyr)

source("../DataIngest.R")

# Define UI for application
shinyUI(fluidPage(
  navbarPage("My Application",
    #Question 1 - Shannon's code, tab 1
    tabPanel("Question 1",
      titlePanel("Seattle Limebike Data"),
      sidebarLayout(
        sidebarPanel(
          selectInput("building", "Chose a station:", 
                  choices = c("Husky Stadium", "University Street",
                              "Capital Hill","International Station/Chinatown",
                              "Stadium", "Sodo"), selected = "Husky Stadium"),
          helpText("Lime Bikes near this locations")
        ),
        mainPanel(
          leafletOutput("limeMap"),
          p()
        )
      )
    ),
    
    #Question 2 - shiv's code, tab 2
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
    
    #Question 3 - Riddhi's code, tab 3
    #I just put this here for a place holder, replace it with whatever
    #you need
    tabPanel("Question 3",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput(inputId = "type",
                                    label = "Type:",
                                    choices = c("bike", "rack"),
                                    selected = "rack")
               ),
               mainPanel(
                 plotOutput("BikeRackPlot"),
                 tableOutput("BikeRackTable")
               )
             )
        )
    
    
    )
 )
)

