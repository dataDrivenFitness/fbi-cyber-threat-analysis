# ==================================================
# Operation Silent Web — Shiny App
# Purpose: Interactively explore cyberattack patterns
# ==================================================

# ---------------------------------------------
# Step 1: Load libraries and dataset
# ---------------------------------------------

library(shiny)
library(tidyverse)
library(lubridate)

# Load the mock dataset
cyber_data <- read_csv("data/cyber_incidents_mock.csv")

# Ensure incident_date is a Date type
cyber_data$incident_date <- as.Date(cyber_data$incident_date)

# ---------------------------------------------
# Step 2: Define the UI (User Interface)
# ---------------------------------------------

ui <- fluidPage(
  titlePanel("Cyber Incident Explorer: Operation Silent Web"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("attack", "Attack Type:",
                  choices = unique(cyber_data$attack_type),
                  selected = unique(cyber_data$attack_type),
                  multiple = TRUE),
      
      selectInput("sector", "Target Sector:",
                  choices = unique(cyber_data$target_sector),
                  selected = unique(cyber_data$target_sector),
                  multiple = TRUE),
      
      selectInput("severity", "Severity Level:",
                  choices = unique(cyber_data$severity_level),
                  selected = unique(cyber_data$severity_level),
                  multiple = TRUE)
    ),
    
    mainPanel(
      plotOutput("attackPlot"),
      br(),
      plotOutput("trendPlot")
    )
  )
)

# ---------------------------------------------
# Step 3: Define the server logic
# ---------------------------------------------

server <- function(input, output) {
  
  # Filter dataset based on input values
  filtered_data <- reactive({
    cyber_data %>%
      filter(
        attack_type %in% input$attack,
        target_sector %in% input$sector,
        severity_level %in% input$severity
      )
  })
  
  # Plot 1: Attack Type Frequency (Bar Chart)
  output$attackPlot <- renderPlot({
    filtered_data() %>%
      count(attack_type) %>%
      ggplot(aes(x = reorder(attack_type, n), y = n)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(title = "Filtered Attack Type Frequency",
           x = "Attack Type", y = "Incidents")
  })
  
  # Plot 2: Monthly Trend of Incidents (Line Chart)
  output$trendPlot <- renderPlot({
    filtered_data() %>%
      mutate(month = floor_date(incident_date, "month")) %>%
      count(month) %>%
      ggplot(aes(x = month, y = n)) +
      geom_line(color = "darkgreen", size = 1) +
      labs(title = "Monthly Incident Trend",
           x = "Month", y = "Number of Incidents")
  })
}

# ---------------------------------------------
# Step 4: Run the app
# ---------------------------------------------

shinyApp(ui = ui, server = server)