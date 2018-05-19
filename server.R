library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(lubridate)
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(dplyr)
library(lubridate)
library(ggplot2)


#setwd("c:/Users/ujwala/Documents/Cousera_Assignment_3")

seattle <- read.csv("seattle.csv",header = TRUE,sep = ",")

server <- function(input,output) {

  seattle$Occurred.Date.or.Date.Range.Start <-
    mdy_hms(seattle$Occurred.Date.or.Date.Range.Start)
  seattle$DOW <- wday(seattle$Occurred.Date.or.Date.Range.Start)
  seattle$TOD <- hour(seattle$Occurred.Date.or.Date.Range.Start)
  time_day <-
    seattle %>% select(DOW, TOD) %>% group_by(DOW, TOD) %>% summarise(crime_count = n())
  seattle_small <- seattle[,c(7,9,12,13,16:21)]
  seattle_small <- seattle_small[,-c(2,5,6)]
  
  location <-
    seattle %>% select(Longitude, Latitude,Summarized.Offense.Description) %>% group_by(Longitude, Latitude,Summarized.Offense.Description) %>% summarise(crime_Frequency = n()) %>% arrange(desc(crime_Frequency))
  location <- location[-1,]
  location
output$text <- renderText({"What does this app do?
  This R shiny App shows how crime frequency is varying with factors like Offense type,district sector,zone,month and year.
  It also shows the locations of crimes on the map according to the crime frequency and offense type."})
      output$hist <-
    renderPlotly({
      plot_ly(
        data =  dat(),
        type = "bar",
        #y = ~ get(input$x_axis),
        #x = ~ dat()$crime_Frequency,orientation = 'h'
        x = ~ get(input$x_axis),
        y = ~ dat()$crime_Frequency,orientation = 'v'
      ) %>% layout(
        xaxis = list(title = ""),
        yaxis = list(title = 'Crime Frequency')
      )
      
    })
  
  dat <- reactive({a <- input$crime_Frequency
  
  seattle_small %>% group_by_(input$x_axis) %>% summarize(crime_Frequency = n()) %>% arrange(desc(crime_Frequency))  %>% filter(crime_Frequency >= a) 
  })
  
  dat2 <- reactive({b <- input$loc
  location %>% filter(crime_Frequency >= b) %>% filter(Summarized.Offense.Description == input$crime_type)})
  
  dat3 <- reactive({b <- input$loc
  location %>% filter(crime_Frequency >= b)})
  
  
  output$map1 <-
    renderLeaflet({
      if(input$crime_type == "All"){
      dat3() %>% leaflet() %>% addTiles() %>% addCircleMarkers(
        lng = ~ Longitude,
        lat = ~ Latitude,
        radius = ~ crime_Frequency,
        clusterOptions = markerOptions(clickable = TRUE, draggable = TRUE),
        label = ~ htmlEscape(as.character(crime_Frequency))
      ) 
      
    }else 
      dat2() %>% leaflet() %>% addTiles() %>% addCircleMarkers(
        lng = ~ Longitude,
        lat = ~ Latitude,
        radius = ~ crime_Frequency,
        clusterOptions = markerOptions(clickable = TRUE, draggable = TRUE),
        label = ~ htmlEscape(as.character(crime_Frequency))
      )})
} 
