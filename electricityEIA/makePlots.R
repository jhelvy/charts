# Author: John Paul Helveston
# Date: First written on Friday, July 5, 2019
#
# Description:
# Barplots of energy capacity and generation by country / region using
# EIA data.

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# Load and format data
source(here('electricityEIA', 'formatData.R'))

# Make plots
windCapacity <- ggplot(electricityDf %>%
    filter(type == 'Capacity', category == 'Wind', year > 1999, year < 2017),
    aes(x = year, y = value)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = 'Installed Power Capacity (GW)',
         title   = 'Installed Wind Power Capacity by Country / Region',
         fill    = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('electricityEIA', 'plots', 'windCapacity.pdf'),
       windCapacity, width=11, height=5, dpi=150)

ggsave(here('electricityEIA', 'plots', 'windCapacity.png'),
       windCapacity, width=11, height=5, dpi=150)

# Print summary of 2016 wind capacity
electricityDf %>%
    filter(type == 'Capacity', category == 'Wind', year == 2016) %>%
    mutate(percent = value / sum(value))
