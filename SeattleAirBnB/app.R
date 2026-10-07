library(shiny)
library(dplyr) 
library(leaflet)

seadata = read.csv("listings_cleaned.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Seattle Airbnb Locations"),
  sidebarLayout(
    sidebarPanel(
      #select neighborhoods, start with none
      checkboxGroupInput("selected_neighborhoods", "Select Neighborhoods:",
                         choices = sort(unique(seadata$neighbourhood_group_cleansed)),
                         selected = ""),
      #select size of group travelling
      numericInput(
        inputId = "groupsize",
        label = "Group Size:",
        value = 4,
        min = 1,
        max = 16,
        step = 1
      ),
      #select length of stay
      numericInput(
        inputId = "staylength",
        label = "Stay Length:",
        value = 2,
        min = 1,
        max = 1125,
        step = 1
      ),
      actionButton("update_btn", "Update Map", class = "btn-primary")
    ),
    mainPanel(
      leafletOutput("map", height = "500px")
    )
  )
)

#server logic
server <- function(input, output, session) {
  
  #base map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -122.335, lat = 47.608, zoom = 11)
  }) 
  
  #user inputs
  observeEvent(input$update_btn, {
    
    #make sure user gave all necessary input
    req(input$selected_neighborhoods, input$groupsize, input$staylength)
    
    #make data match user selections
    filtered_data = seadata %>%
      filter(neighbourhood_group_cleansed %in% input$selected_neighborhoods) %>%
      filter(accommodates >= input$groupsize) %>%
      filter(minimum_nights <= input$staylength) %>%
      filter(maximum_nights >= input$staylength)
    
    #filter map points
    leafletProxy("map", data = filtered_data) %>%
      clearMarkers() %>%
      addMarkers(
        lng = ~longitude, 
        lat = ~latitude, 
        label = ~name,
        popup = ~paste0(
          "<b>", description, "</b><br/>",
          '<a href="', listing_url, '" target="_blank" class="btn btn-primary btn-sm" style="margin-top: 5px; color: white;">See Property</a>'
        )
      )

  })
}

#run the application 
shinyApp(ui = ui, server = server)
