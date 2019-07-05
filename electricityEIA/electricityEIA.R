library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# ----------------------------------------------------------------------------
# Data source:
# U.S. Energy Information Administration (EIA)
# Official Energy Statistics from the U.S. Government
# https://www.eia.gov/beta/international/data/browser/

paths <- list(
    here('electricityEIA', 'data', 'international_data_china_us.csv'),
    here('electricityEIA', 'data', 'international_data_europe_world.csv'))


China_USA <- read_csv(
    ,
        skip=4)
Europe_World <- read_csv(
    here('electricityEIA', 'data', 'international_data_china_us.csv'),
        skip=4)

