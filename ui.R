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
library(stringr)

ui <-
  dashboardPage(skin = "blue",
                dashboardHeader(title = "Coursera Assignment 3"),
                dashboardSidebar(
                  sidebarUserPanel(name= "Crimes in Seattle",
                                   #image = "http://www.schoolautomationsoftwares.com/assets/images/modules-color/assignment.png"
                                   image ="http://vivateachers.org/wp-content/uploads/2012/07/No-Guns.png"
                                   ),
                  sidebarMenu(
                    menuItem("Help Page",tabName = "help",icon = icon("info")),
                    menuItem("Var Vs. Crime Freq", tabName = "plot", icon = icon("signal")),
                    menuItem("Location Vs. Crime Freq", tabName = "plot1", icon = icon("map-marker")),submitButton("submit")
                  )),
                dashboardBody(tabItems(
                  tabItem(tabName = "help",box(textOutput("text"),background = "black")),
                  tabItem(tabName = "plot", 
                          fluidRow(
                            box(
                              numericInput(
                                inputId = "crime_Frequency",
                                label = "choose frequency threshold",
                                value = 25,
                                min = 0,
                                max = 10000,
                                step = 10
                              ),width = 4,background = "black"
                            ),box(
                              selectInput(
                                inputId = "x_axis",
                                label = "Select Category",
                                choices = c("Summarized.Offense.Description","District.Sector","Zone.Beat","Month","Year")
                              ),width = 4,background = "black"
                              
                            )
                          ),fluidRow(box(plotlyOutput("hist",height = "500px",width = "700px"),background = "black",width = 12))),
                  tabItem(tabName = "plot1",
                          fluidRow(box(numericInput(
                            inputId = "loc",
                            label = "choose frequency threshold",
                            value = 1,
                            min = 0 ,
                            max = 5,
                            step = 1
                          ),background = "black",width = 4),
                          box(
                            selectInput(
                              inputId = "crime_type",
                              label = "Select crime Category",
                              choices = c("ANIMAL COMPLAINT","ASSAULT","BIAS INCIDENT","BIKE THEFT","BURGLARY","BURGLARY-SECURE PARKING-RES","CAR PROWL","COUNTERFEIT","DISPUTE","DISTURBANCE","DUI","ELUDING","EMBEZZLE","FALSE REPORT","FORGERY","FRAUD","HOMICIDE","ILLEGAL DUMPING","INJURY","LIQUOR VIOLATION","LOST PROPERTY","MAIL THEFT","NARCOTICS","OBSTRUCT","OTHER PROPERTY","PICKPOCKET","PORNOGRAPHY","PROPERTY DAMAGE","PROSTITUTION","PURSE SNATCH","RECKLESS BURNING",
                                          "RECOVERED PROPERTY","ROBBERY","SHOPLIFTING","STOLEN PROPERTY","THEFT OF SERVICES","THREATS","TRAFFIC",
                                          "TRESPASS","VEHICLE THEFT","VIOLATION OF COURT ORDER","WARRANT ARREST","WEAPON",
                                          "All")),width = 4,background = "black"
                          ),
                          fluidRow(box(leafletOutput("map1", height = "600px", width = "1300px"),background = "black",width = 12)))
                )
                )))

