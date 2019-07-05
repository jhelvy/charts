library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(readxl)

# ----------------------------------------------------------------------------
# Data source:
# U.S. Energy Information Administration (EIA)
# Official Energy Statistics from the U.S. Government
# https://www.eia.gov/beta/international/data/browser/

China_USA <- read_csv(
    here('electricityEIA', 'data', 'international_data_china_us.csv'),
        skip=4)
Europe_World <- read_csv(
    here('electricityEIA', 'data', 'international_data_china_us.csv'),
        skip=4)

