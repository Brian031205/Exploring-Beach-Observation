#### Preamble ####
# Purpose: Save the models.
# Author: Bolin Shen
# Date: March 25 2024
# Contact: bolin.shen@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)
library(here)
library(rstanarm)
library(modelsummary)
library(caTools)

#### Read data ####
cleaned_beach_data = read_csv(
  file = here("data/cleaned_beach_data.csv"),
  show_col_types = FALSE
)


# split data for training and testing

set.seed(853)
index  <-  sample.split(cleaned_beach_data$windSpeed,SplitRatio = 0.8)
train_data <- subset(cleaned_beach_data, index == TRUE)
test_data <- subset(cleaned_beach_data, index == FALSE)

## training
change_of_turbidity <-
  stan_glm(
    formula = turbidity ~ beachName + rainAmount + airTemp + waterTemp + windSpeed + dataCollectionDate + waterFowl + waveAction,
    data = train_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5,autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5,autoscale = TRUE),
    prior_aux = exponential(rate = 1),
    seed = 853
  )

modelsummary(change_of_turbidity)

saveRDS(
  change_of_turbidity,
  file = "models/change_of_turbidity.rds"
)

## testing
model <-  readRDS(file = here("models/change_of_turbidity.rds"))
predictions <- predict(model, newdata = test_data, type = "response")

# save data
write_csv(
  x = train_data,
  file = "data/cleaned_beach_data_train.csv"
)

test_data$predict = predictions
write_csv(
  x = test_data,
  file = "data/cleaned_beach_data_test_with_predict.csv"
)
