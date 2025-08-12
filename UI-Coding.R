## Dashboard UI Coding

library(bslib)
library(shiny)
library(shinydashboard)
library(gitcreds)

3

## Create Header

header <- 
  dashboardHeader( title = ('DIR Workplace Fatality Dashboard'),
                   disable=FALSE,
                   titleWidth =  550
  )

header$children[[2]]$children[[2]] <- header$children[[2]]$children[[1]]
header$children[[2]]$children[[1]] <- tags$a(href='https://www.dir.ca.gov/dosh/',
                                             tags$image(src=)
                                             )

## Create Sidebar

sidebar <-
  dashboardSidebar('Test')


## Create Body

body <-
  dashboardBody('Test')

## Put everything together

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {}

shinyApp(ui, server)