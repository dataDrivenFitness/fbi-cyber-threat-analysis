# Operation Silent Web: Cybersecurity Threat Analysis (FBI Mock Project)

## Overview
This project simulates an FBI cybersecurity investigation analyzing 1,000+ mock cyber incidents across various sectors and states. The goal is to detect patterns in attack types, severity levels, geographic hotspots, and propose actionable recommendations based on real-world investigative processes.

## Files and Structure

- `/data/` — Generated datasets and analysis exports.
- `/analysis/` — Scripts for data analysis, dashboard, and predictive modeling.
- `/visuals/` — Key visualizations generated from the analysis.
- `/reports/` — Final investigative report in Word format.

## Key Features
- Full cyber threat pattern analysis using R (tidyverse, lubridate).
- Dynamic R Markdown reporting with embedded plots and tables.
- Interactive Shiny Dashboard to explore incidents by type, sector, and severity.
- Basic predictive modeling to forecast future cyberattacks.

## How to Run
1. Open the RStudio project.
2. Run `cyber_analysis_script.R` to generate analysis outputs.
3. Knit `cyber_analysis_report.Rmd` to produce the final written report.
4. Run `/analysis/shiny_app/app.R` to launch the interactive dashboard.
5. Run `/analysis/predictive_model/predictive_model_script.R` to view forecasts.

## Skills Demonstrated
- Data cleaning and generation
- Exploratory Data Analysis (EDA)
- Data visualization
- Predictive time-series modeling
- Dashboard development with Shiny
- Professional investigative reporting

## Author
Christopher Davis

