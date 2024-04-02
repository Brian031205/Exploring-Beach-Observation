#### Preamble ####
# Purpose: Download data from "https://open.toronto.ca/dataset/toronto-beaches-observations/"
# Author: Bolin Shen
# Date: March 25 2024
# Contact: bolin.shen@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)

# get package
package <- show_package("toronto-beaches-observations")
package

# get all resources for this package
resources <- list_package_resources("toronto-beaches-observations")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data


# write data
write_csv(
  x = data,
  file = "data/raw_beach_data.csv"
)