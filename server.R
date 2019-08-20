library(shiny)
library(dplyr)
state_table_by_actyr <- readRDS("state_table_by_actyr.rds")
us_geo <- readRDS("us_geo.rds")
shinyServer(
  function(input, output) {
    output$map = renderLeaflet({
      filtered_merge <-  state_table_by_actyr %>% 
        dplyr::ungroup() %>% 
        filter(actyr == input$activity_year_selected) %>%
        tmaptools::append_data(
          shp = us_geo, 
          data =  ., 
          key.shp = "STUSPS", 
          key.data = "state", 
          ignore.duplicates = TRUE)
        
      bins <- c(0, .01, .03, .06, .2, .25, .3, .35)
      pal <- colorBin("YlOrRd", domain = filtered_merge$default_rate, bins = bins)
      
      labels <- sprintf(
        "State: %s <br> default rate: %g",
         filtered_merge$STUSPS, filtered_merge$default_rate) %>% 
        lapply(htmltools::HTML)
      
      leaflet(filtered_merge) %>%
        setView(-96, 37.8, 4) %>%
        addTiles() %>%
        addPolygons(
          fillColor = ~pal(default_rate),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = labels,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
        addLegend(pal = pal, values = ~default_rate, opacity = 0.7, title = "Default Rate",
                  position = "bottomright")})
  }
)   




