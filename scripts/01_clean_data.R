#### Preamble ####
# Purpose: Cleans the raw poll data
# Author: Bolin Shen
# Date: March 25 2024
# Contact: bolin.shen@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

#### Read in raw data ####

raw_beach_data <-
  read_csv(
    file = "data/raw_beach_data.csv",
    show_col_types = FALSE
  )

# reformat the date to year only
data_year_month = as.Date(data$dataCollectionDate, format = "%Y-%m-%d")|> format("%Y-%m")
cleaned_beach_data = raw_beach_data |> mutate(dataCollectionDate = data_year_month)


# Remove all observations with missing data 
cleaned_beach_data <- na.omit(cleaned_beach_data)


cleaned_beach_data <- cleaned_beach_data |> 
  select(
    windSpeed,
    dataCollectionDate,
    airTemp,
    waterTemp,
    rainAmount,
    turbidity
  
)



cleaned_beach_data


# save cleaned data #
write_csv(
  x = cleaned_beach_data,
  file = "data/cleaned_beach_data.csv"
)
