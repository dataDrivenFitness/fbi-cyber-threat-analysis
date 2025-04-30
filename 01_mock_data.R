# ================================================
# FBI Mock Project: Cyberattack Pattern Analysis
# Author: [Your Name]
# Purpose: Simulate FBI Cybersecurity Data Investigation
# ================================================

# -----------------------------------------
# Load Required Libraries
# -----------------------------------------

# 'tidyverse' contains packages like dplyr and ggplot2 for data manipulation and plotting.
# 'lubridate' makes working with dates easier (especially month extraction).
library(tidyverse)
library(lubridate)

# -----------------------------------------
# 1. Generate Mock Cyberattack Dataset
# -----------------------------------------

# Set a random seed for reproducibility.
# This ensures that every time you run the code, you get the same random results.
set.seed(123)

# Define the possible categories for each variable based on realistic cyberattacks.
attack_types <- c("Phishing", "Ransomware", "Malware", "SQL Injection", "DDoS")
sectors <- c("Healthcare", "Banking", "Education", "Government", "Retail")
severity_levels <- c("Low", "Medium", "High", "Critical")
states <- c("CA", "NY", "TX", "FL", "IL", "GA", "PA", "OH", "NC", "MI")

# Set the number of incidents you want to simulate.
n <- 1000

# Create the dataset using 'tibble' for easy viewing and manipulation.
cyber_data <- tibble(
  incident_id = 1:n,  # Unique identifier for each event.
  
  # Randomly assign attack types with some probabilities.
  attack_type = sample(
    attack_types,
    n,
    replace = TRUE,
    prob = c(0.35, 0.25, 0.2, 0.1, 0.1)  # Phishing is more common than DDoS.
  ),
  
  # Randomly assign a target sector.
  target_sector = sample(
    sectors,
    n,
    replace = TRUE
  ),
  
  # Assign random incident dates between Jan 1, 2023, and Dec 31, 2024.
  incident_date = sample(
    seq(as.Date('2023-01-01'), as.Date('2024-12-31'), by="day"),
    n,
    replace = TRUE
  ),
  
  # Assign severity levels, more likely to be Low or Medium.
  severity_level = sample(
    severity_levels,
    n,
    replace = TRUE,
    prob = c(0.4, 0.3, 0.2, 0.1)
  ),
  
  # Assign locations, some states have a higher chance (e.g., CA and NY).
  reported_location = sample(
    states,
    n,
    replace = TRUE,
    prob = c(0.2, 0.2, 0.15, 0.15, 0.1, 0.05, 0.05, 0.05, 0.025, 0.025)
  ),
  
  # Assign an estimated financial loss, randomly from $100 to $5,000,000.
  estimated_loss_usd = round(runif(n, min = 100, max = 5000000), 2)
)

# Quickly inspect the first few rows of the dataset.
head(cyber_data)

# Save the dataset to a CSV file so you can use it later or share it.
write_csv(cyber_data, "cyber_incidents_mock.csv")

# -----------------------------------------
# 2. Exploratory Data Analysis (EDA)
# -----------------------------------------

# We now explore the data to detect patterns and hotspots.

# a) Attack Type Frequency
# How many times did each type of attack occur?
attack_freq <- cyber_data %>%
  count(attack_type, sort = TRUE)

# Print results
print(attack_freq)

# b) Target Sector Distribution
# What industries are being attacked most?
sector_freq <- cyber_data %>%
  count(target_sector, sort = TRUE)

# Print results
print(sector_freq)

# c) Severity Level Distribution
# How severe are the incidents overall?
severity_freq <- cyber_data %>%
  count(severity_level, sort = TRUE)

# Print results
print(severity_freq)

# d) Total Financial Loss by Attack Type
# Which attack types are causing the most money loss?
loss_by_attack <- cyber_data %>%
  group_by(attack_type) %>%
  summarize(
    total_loss = sum(estimated_loss_usd),
    avg_loss = mean(estimated_loss_usd),
    .groups = 'drop'
  )

# Print results
print(loss_by_attack)

# -----------------------------------------
# 3. Simple Visualizations
# -----------------------------------------

# a) Attack Frequency by Type
cyber_data %>%
  count(attack_type) %>%
  ggplot(aes(x = reorder(attack_type, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Attack Type Frequency",
    x = "Attack Type",
    y = "Number of Incidents"
  )

# Explanation:
# - `reorder()` sorts bars by count.
# - `coord_flip()` flips x and y for horizontal bars (easier to read).

# b) Severity Levels Across Incidents
cyber_data %>%
  count(severity_level) %>%
  ggplot(aes(x = severity_level, y = n)) +
  geom_col(fill = "darkred") +
  labs(
    title = "Severity Level Distribution",
    x = "Severity Level",
    y = "Number of Incidents"
  )

# c) Incidents Over Time (Trend)
cyber_data %>%
  mutate(month = floor_date(incident_date, "month")) %>%
  count(month) %>%
  ggplot(aes(x = month, y = n)) +
  geom_line(color = "darkgreen", size = 1) +
  geom_smooth(method = "loess", se = FALSE, color = "black") +
  labs(
    title = "Cyber Incidents Over Time",
    x = "Month",
    y = "Number of Incidents"
  )

# Explanation:
# - `floor_date()` rounds dates to months.
# - `geom_smooth()` adds a smoothed trend line to visualize general growth or decline.

# -----------------------------------------
# 4. (Optional) Hotspot Detection
# -----------------------------------------

# Top 5 states with most incidents
hotspot_states <- cyber_data %>%
  count(reported_location, sort = TRUE) %>%
  top_n(5)

print(hotspot_states)

# Bar chart of top states
hotspot_states %>%
  ggplot(aes(x = reorder(reported_location, n), y = n)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(
    title = "Top 5 States by Number of Incidents",
    x = "State",
    y = "Number of Incidents"
  )

# -----------------------------------------
# 5. Save Outputs
# -----------------------------------------

# Save important tables as CSVs if needed
write_csv(attack_freq, "attack_frequency.csv")
write_csv(sector_freq, "sector_distribution.csv")
write_csv(loss_by_attack, "loss_by_attack.csv")
write_csv(hotspot_states, "hotspot_states.csv")

# ================================================
# End of FBI Cybersecurity Mock Project Script
# ================================================