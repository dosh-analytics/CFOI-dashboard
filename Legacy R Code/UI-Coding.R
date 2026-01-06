## Dashboard UI Coding

library(bslib)
library(shiny)
library(shinydashboard)
library(gitcreds)
library(ggplot2)

load('Raw-Fatality-Data.Rda')
load('Segmented-Data.RData')

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
    selectizeInput(
      "select",
      "Select Data Filtered By:",
      list("Total Fatalities" = "totals", "Gender" = "gender", "Race" = "race", 
           "Employment Status" = "employment", "Fatal Event" = "event", "Industry" = "industry", "Occupation" = "occupation")
    ),
    plotOutput("plot")

  )

## Put everything together

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
    output$plot <- renderPlot({
      if (input$select == 'totals')
      {ggplot(data=df_totals, aes(x=year, y=count)) +
        scale_x_continuous(breaks=1999:2023) +
        geom_bar(stat="identity", fill="#9098CF") +
        geom_line(linewidth=1, color = '#B94700') + 
        geom_text(aes(label=count), vjust=4.0, color="black", size=4.5) +
        theme(plot.title = element_text(hjust = 0.5)) +
        labs(
          x = "Year",
          y = "Fatal Occupational Injuries",
          title = "California Fatal Occupational Injuries Within the Scope of CFOI (1999-2023)")
    } else if (input$select == 'gender')
      {ggplot(df_gender, aes(x = year, y = count, fill = label)) + 
        geom_bar(stat = "identity", position="stack") +
        geom_label(aes(label = count, size = 6), position = position_stack(vjust = 0.5), show.legend = FALSE) +
        scale_y_continuous(limits = c(0,550), breaks=c(0, 100, 200, 300, 400, 500, 500)) + 
        scale_x_continuous(breaks=2009:2023) + 
        scale_fill_manual(values=c("#FFD41C", "#6ECAC8")) + 
        theme(plot.title = element_text(hjust = 0.5)) +
        labs(
          x = "Year",
          y = "Fatal Occupational Injuries",
          title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Gender",
          fill = 'Gender')
    }
      else if (input$select == 'race')
      {ggplot(df_race,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
          geom_line(linewidth=1) + 
          geom_label_repel(aes(label = label), max.overlaps = 0, nudge_x = 1, na.rm = TRUE) + 
          geom_point(size=3) + 
          theme(plot.title = element_text(hjust = 0.5)) +
          coord_cartesian(xlim=c(2013,2023)) + 
          labs(
            x = "Year",
            y = "Fatal Occupational Injuries",
            color = "",
            title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Race/Ethnicity (2013-2023)"
          ) + 
          theme(legend.position="bottom")}
      else if (input$select == 'employment')
      {ggplot(df_employment, aes(x = year, y = count, fill = label)) + 
          geom_bar(stat = "identity", position="stack") +
          geom_label(aes(label = count, size = 6), position = position_stack(vjust = 0.5), show.legend = FALSE) +
          scale_y_continuous(limits = c(0,550), breaks=c(0, 100, 200, 300, 400, 500, 500)) + 
          scale_x_continuous(breaks=2009:2023) + 
          scale_fill_manual(values=c("#FFD41C", "#6ECAC8")) + 
          theme(plot.title = element_text(hjust = 0.5)) +
          labs(
            x = "Year",
            y = "Fatal Occupational Injuries",
            title = "California Fatal Occupational Injuries by Employment Status",
            fill = 'Employment Status'
          )}
      else if (input$select == 'event')
      {ggplot(df_causes,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
          geom_line(linewidth=1) + 
          geom_point(size=3) + 
          theme(plot.title = element_text(hjust = 0.5)) +
          scale_x_continuous(breaks=2013:2023) + 
          labs(
            x = "Year",
            y = "Fatal Occupational Injuries",
            color = "",
            title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Event (2013-2023)"
          ) + 
          theme(legend.position="bottom")}
      else if (input$select == 'industry')
      {ggplot(df_industry,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
          geom_line(linewidth=1) + 
          geom_point(size=3) + 
          theme(plot.title = element_text(hjust = 0.5)) +
          scale_x_continuous(breaks=2013:2023) + 
          labs(
            x = "Year",
            y = "Fatal Occupational Injuries",
            color = "",
            title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Industry (2013-2023)"
          ) + 
          theme(legend.position="bottom")}
      else if (input$select == 'occupation')
      {ggplot(df_occupation,aes(x = year, y = count, group = label, color = label, pattern = label)) + 
          geom_line(linewidth=1) + 
          geom_point(size=3) + 
          theme(plot.title = element_text(hjust = 0.5)) +
          scale_x_continuous(breaks=2013:2023) + 
          labs(
            x = "Year",
            y = "Fatal Occupational Injuries",
            color = "",
            title = "California Fatal Occupational Injuries Within the Scope of CFOI, by Occupation (2013-2023)"
          ) + 
          theme(legend.position="bottom")}
    })}


shinyApp(ui, server)

