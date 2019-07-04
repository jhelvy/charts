# Author: John Paul Helveston
# Date: First written on Thursday, July 4, 2019
#
# Description:
# Barplots of clean energy investment by country and type
#
# Data Sources: See "sources.txt" in "data" folder for details
#
# Clean energy investment by Bloomberg New Energy Finance:
# https://about.bnef.com/clean-energy-investment/

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# Read in and format 1995 to 2013 data
chinaSolar <- read_csv(
    here('newEnergyInvestment', 'data', 'chinaSolar.csv'))
chinaSolarWind <- read_csv(
    here('newEnergyInvestment', 'data', 'chinaSolarWind.csv'))
chinaSolarWindOther <- read_csv(
    here('newEnergyInvestment', 'data', 'chinaSolarWindOther.csv'))
europeWindon <- read_csv(
    here('newEnergyInvestment', 'data', 'europeWindon.csv'))
europeWindonWindoff <- read_csv(
    here('newEnergyInvestment', 'data', 'europeWindonWindoff.csv'))
europeWindonWindoffSolar <- read_csv(
    here('newEnergyInvestment', 'data', 'europeWindonWindoffSolar.csv'))
europeWindonWindoffSolarOther <- read_csv(
    here('newEnergyInvestment', 'data', 'europeWindonWindoffSolarOther.csv'))
usWind <- read_csv(
    here('newEnergyInvestment', 'data', 'usWind.csv'))
usWindSolar <- read_csv(
    here('newEnergyInvestment', 'data', 'usWindSolar.csv'))
usWindSolarOther <- read_csv(
    here('newEnergyInvestment', 'data', 'usWindSolarOther.csv'))






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
