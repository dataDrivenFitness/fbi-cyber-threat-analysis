# =============================================
# Operation Silent Web — Predictive Model Script
# Author: Christopher Davis
# Purpose: Forecast future cyberattacks by month
# =============================================

# ---------------------------------------------
# Step 1: Load required libraries
# ---------------------------------------------

# tidyverse for data wrangling
library(tidyverse)

# lubridate to handle dates
library(lubridate)

# forecast for time series modeling and projections
library(forecast)

# ---------------------------------------------
# Step 2: Load and prepare your dataset
# ---------------------------------------------

# Load the mock cyber incident data
cyber_data <- read_csv("data/cyber_incidents_mock.csv")

# Convert incident_date column to Date format if needed
cyber_data$incident_date <- as.Date(cyber_data$incident_date)

# Aggregate number of incidents by month
monthly_data <- cyber_data %>%
  mutate(month = floor_date(incident_date, "month")) %>%
  count(month)

# View a sample of the result
head(monthly_data)

# ---------------------------------------------
# Step 3: Convert to time series object
# ---------------------------------------------

# Create a time series object from monthly counts
# start = c(2023, 1) assumes your dataset begins in Jan 2023
incident_ts <- ts(monthly_data$n, start = c(2023, 1), frequency = 12)

# Plot the time series to visualize trends
plot(incident_ts,
     main = "Monthly Cyber Incidents (2023–2024)",
     ylab = "Incidents", xlab = "Time")

# ---------------------------------------------
# Step 4: Fit ARIMA model
# ---------------------------------------------

# Automatically select best ARIMA model based on AIC
model <- auto.arima(incident_ts)

# Summary of model
summary(model)

# ---------------------------------------------
# Step 5: Forecast next 12 months
# ---------------------------------------------

# Predict 12 months into the future (for 2025)
forecasted <- forecast(model, h = 12)

# Plot the forecast
autoplot(forecasted) +
  labs(
    title = "Forecasted Monthly Cyber Incidents for 2025",
    x = "Month", y = "Predicted Incident Count"
  )

# Save forecast chart
ggsave("visuals/forecasted_cyber_incidents.png", width = 8, height = 5)

# ---------------------------------------------
# Step 6: Export forecast data (optional)
# ---------------------------------------------

# Save forecasted values to CSV
write_csv(as_tibble(forecasted), "data/cyber_incident_forecast.csv")