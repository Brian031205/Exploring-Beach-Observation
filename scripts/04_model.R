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


#### Read data ####
cleaned_beach_data = read_csv(
  file = here("data/cleaned_beach_data.csv"),
  show_col_types = FALSE
)


summarized_beach_data <-
  cleaned_beach_data |>
  group_by(dataCollectionDate) |>
  summarise(across(c(windSpeed, turbidity, airTemp, waterTemp, rainAmount), mean))


summarized_beach_data
# model1

# Create a line plot, x-axis is the wind speed and the y-axis is the turbidity
model_1 <- summarized_beach_data |>
  ggplot(aes(x = windSpeed, y = turbidity)) +
  labs(x = "Wind speed",
       y = "Turbidity",
       title = "Wind speed effect on turbidity",
       caption = "Figure 1") +
  geom_point() + 
  geom_smooth(
    method = "lm",
    se = TRUE,
    linetype = "dashed",
    formula = "y ~ x"
  ) +
  theme_minimal()

model_1



#model2


# Create a line plot, x-axis is the air temperature and the y-axis is the turbidity
model_2 <- summarized_beach_data |>
  ggplot(aes(x = airTemp, y = turbidity)) +
  labs(x = "Air temperature",
       y = "Turbidity",
       title = "Air temperature effect on turbidity",
       caption = "Figure 2") +
  geom_point() + 
  geom_smooth(
    method = "lm",
    se = TRUE,
    linetype = "dashed",
    formula = "y ~ x"
  ) +
  theme_minimal()

model_2



# model 3


# Create a line plot, x-axis is the water temperature and the y-axis is the turbidity
model_3 <- summarized_beach_data |>
  ggplot(aes(x = waterTemp, y = turbidity)) +
  labs(x = "Water temperature",
       y = "Turbidity",
       title = "Water temperature effect on turbidity",
       caption = "Figure 3") +
  geom_point() + 
  geom_smooth(
    method = "lm",
    se = TRUE,
    linetype = "dashed",
    formula = "y ~ x"
  ) +
  theme_minimal()

model_3


# model 4


# Create a line plot, x-axis is the rain amount and the y-axis is the turbidity
model_4 <- summarized_beach_data |>
  ggplot(aes(x = rainAmount, y = turbidity)) +
  labs(x = "Rain amount",
       y = "Turbidity",
       title = "Rain amount effect on turbidity",
       caption = "Figure 4") +
  geom_point() + 
  geom_smooth(
    method = "lm",
    se = TRUE,
    linetype = "dashed",
    formula = "y ~ x"
  ) +
  theme_minimal()

model_4


change_of_turbidity <-
  stan_glm(
    formula = turbidity ~ rainAmount + airTemp + waterTemp + windSpeed,
    data = summarized_beach_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5),
    prior_intercept = normal(location = 0, scale = 2.5),
    prior_aux = exponential(rate = 1),
    seed = 853
  )


modelsummary(change_of_turbidity)

saveRDS(
  change_of_turbidity,
  file = "models/change_of_turbidity.rds"
)