# ================================================
# FBI Mock Project: Cyberattack Pattern Analysis
# Author: [Your Name]
# Purpose: Investigate cyberattack trends from mock data
# ================================================

# -----------------------------------------
# 1. Load Required Libraries
# -----------------------------------------

# The tidyverse is a collection of R packages for data science tasks
# Includes dplyr (data manipulation), ggplot2 (visualization), etc.
library(tidyverse)

# lubridate is useful for working with dates (e.g., extracting months)
library(lubridate)

# -----------------------------------------
# 2. Load Your Cyberattack Dataset
# -----------------------------------------

# Load the CSV file you generated previously
cyber_data <- read_csv("data/cyber_incidents_mock.csv")

# Check the structure to ensure everything loaded properly
glimpse(cyber_data)

# -----------------------------------------
# 3. Summary Tables for Exploratory Analysis
# -----------------------------------------

# Count how often each attack type appears
attack_freq <- cyber_data %>%
  count(attack_type, sort = TRUE)

# Count number of incidents per target sector
sector_freq <- cyber_data %>%
  count(target_sector, sort = TRUE)

# Count distribution of severity levels
severity_freq <- cyber_data %>%
  count(severity_level, sort = TRUE)

# Summarize financial impact by attack type
loss_by_attack <- cyber_data %>%
  group_by(attack_type) %>%
  summarize(
    total_loss = sum(estimated_loss_usd),
    avg_loss = mean(estimated_loss_usd),
    .groups = 'drop'
  )

# Top 5 states with the most incidents
hotspot_states <- cyber_data %>%
  count(reported_location, sort = TRUE) %>%
  top_n(5)

# Save summary tables to CSV for reporting
write_csv(attack_freq, "data/attack_frequency.csv")
write_csv(sector_freq, "data/sector_distribution.csv")
write_csv(loss_by_attack, "data/loss_by_attack.csv")
write_csv(hotspot_states, "data/hotspot_states.csv")

# -----------------------------------------
# 4. Create and Save Visualizations
# -----------------------------------------

# Attack Type Frequency Plot
p1 <- cyber_data %>%
  count(attack_type) %>%
  ggplot(aes(x = reorder(attack_type, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Attack Type Frequency", x = "Attack Type", y = "Incidents")

ggsave("visuals/attack_type_frequency.png", p1, width = 8, height = 5)

# Severity Level Distribution Plot
p2 <- cyber_data %>%
  count(severity_level) %>%
  ggplot(aes(x = severity_level, y = n)) +
  geom_col(fill = "firebrick") +
  labs(title = "Severity Level Distribution", x = "Severity", y = "Count")

ggsave("visuals/severity_level_distribution.png", p2, width = 8, height = 5)

# Incident Trend Over Time Plot
p3 <- cyber_data %>%
  mutate(month = floor_date(incident_date, "month")) %>%
  count(month) %>%
  ggplot(aes(x = month, y = n)) +
  geom_line(color = "darkgreen", size = 1) +
  geom_smooth(se = FALSE, color = "black") +
  labs(title = "Cyber Incidents Over Time", x = "Month", y = "Incident Count")

ggsave("visuals/incidents_trend_over_time.png", p3, width = 8, height = 5)

# Top 5 States with Most Incidents Plot
p4 <- hotspot_states %>%
  ggplot(aes(x = reorder(reported_location, n), y = n)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(title = "Top 5 States by Number of Incidents", x = "State", y = "Number of Incidents")

ggsave("visuals/top_5_states_hotspot.png", p4, width = 8, height = 5)

# -----------------------------------------
# 5. End of Script
# -----------------------------------------

# All summary tables and plots are now saved for use in your report.
# Next step: open `cyber_analysis_report.Rmd` and use these outputs.