## Dashboard UI Coding

library(bslib)
library(shiny)
library(shinydashboard)
library(gitcreds)


## Create Header

header <- 
  dashboardHeader( title = ('DIR Workplace Fatality Dashboard'),
                   disable=FALSE,
                   titleWidth =  550
  )



## Create Sidebar

sidebar <-
  dashboardSidebar(
    tags$image(src='Cal-OSHA_Division-of-Occupational-Safety-and-Health-Logo_Full-Color-Reversed-RGB_2025.PNG',height='80',width='186.93',align='top'),
    sidebarMenu(
      menuItem("Dashboard", tabname="dashboard",icon = icon("dashboard"))

    )
  )


## Create Body

body <-
  dashboardBody(
    
      ## modify the dashboard's skin color
      tags$style(HTML('
                       /* logo */
                       .skin-blue .main-header .logo {
                       background-color: #25408F;
                       }

                       /* logo when hovered */
                       .skin-blue .main-header .logo:hover {
                       background-color: #25408F;
                       }

                       /* navbar (rest of the header) */
                       .skin-blue .main-header .navbar {
                       background-color: #25408F;
                       }

                       /* active selected tab in the sidebarmenu */
                       .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                       background-color: #25408F;
                                 }
                       ')
      ),
      
      ## Hide carrot icon in sidebar menu selection
      tags$style(HTML('
                      /* Hide icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview>a>.fa-angle-left {
                      display: none;
                      } 
                      '
      )) ,
      
      tags$style( HTML("hr {border-top: 1px solid #000000;}") ),
      
      ## to not show error message in shiny
      tags$style( HTML(".shiny-output-error { visibility: hidden; }") ),
      tags$style( HTML(".shiny-output-error:before { visibility: hidden; }") ),
     
    layout_columns(
      width='250px',
        value_box(title = 'Total Workplace Fatalties 2023:',
                  value = "439"),
        value_box(title = "California Fatality Rate (per 100,000):",
                  value = "2.5"),
        value_box(title = "U.S. Fatality Rate (per 100,000)",
                  value = "3.5",
                  theme = 'red')

        ),
    selectInput(
      "select",
      "Select Data Filtered By:",
      list("Choice 1A" = "1A", "Choice 1B" = "1B", "Choice 1C" = "1C")
    
    )

  )

## Put everything together

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {}

shinyApp(ui, server)

