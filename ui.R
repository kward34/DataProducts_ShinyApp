library(shiny)    # for shiny apps
library(leaflet)  # renderLeaflet function
 
ui = fluidPage(
  titlePanel(p("Geospatial App - Default Rate by State by Year of Loan Default", style = "color:#3474A7")),
  includeMarkdown('html/geospatial_description.md'),
  sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "activity_year_selected", label = "Select  activity year",
                    choices = 2000:2018),
        
        p("Made with", a("Shiny", href = "http://shiny.rstudio.com"), "."),
        img(src = "r-shiny-logo.png", width = "150px", height = "70px")),
      mainPanel(
        leafletOutput(outputId = "map")
      )
    )
  )




