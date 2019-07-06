# Author: John Paul Helveston
# Date: First written on Tuesday, July 2, 2019
#
# Description:
# Barplot of global annual solar photovoltaic cell production by country
#
# Original figures by Ed Hawkins:
# http://www.climate-lab-book.ac.uk/2018/warming-stripes/#more-5516

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# Read in and format data
source(here('solarPvProduction', 'formatData.R'))

# Make the plot
solarPlot <- ggplot(solarDf %>% filter(Year > 2000),
    aes(x = Year, y = Production)) +
    geom_bar(aes(fill = Country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(1999, 2019),
                       breaks = c(seq(2000, 2015, 5), 2018)) +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Year',
         y = 'Solar Voltaic Cell Production (GW)',
         fill = 'Country')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('solarPvProduction', 'plots', 'solarPlot.pdf'),
       solarPlot, width=8, height=5, dpi=150)

ggsave(here('solarPvProduction', 'plots', 'solarPlot.png'),
       solarPlot, width=8, height=5, dpi=150)

# Summary of China's production: Since joining the WTO in 2001,
# China went from producing 1% to 40% of the world’s solar panels
solarDf %>%
    spread(Country, Production) %>%
    mutate(
        world = China + `Rest of World` + `United States`,
        chinaPercent = 100*(China / world)
    ) %>%
    select(Year, chinaPercent) %>%
    as.data.frame()
