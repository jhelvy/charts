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
read <- function(path) {return(read.csv(path, header=F)$V2)}
china_solar <- read(
    here('newEnergyInvestment', 'data', 'china_solar.csv'))
china_solar_wind <- read(
    here('newEnergyInvestment', 'data', 'china_solar_wind.csv'))
china_total <- read(
    here('newEnergyInvestment', 'data', 'china_total.csv'))
us_wind <- read(
    here('newEnergyInvestment', 'data', 'us_wind.csv'))
us_wind_solar <- read(
    here('newEnergyInvestment', 'data', 'us_wind_solar.csv'))
us_total <- read(
    here('newEnergyInvestment', 'data', 'us_total.csv'))
europe_windon <- read(
    here('newEnergyInvestment', 'data', 'europe_windon.csv'))
europe_windon_windoff <- read(
    here('newEnergyInvestment', 'data', 'europe_windon_windoff.csv'))
europe_windon_windoff_solar <- read(
    here('newEnergyInvestment', 'data', 'europe_windon_windoff_solar.csv'))
europe_total <- read(
    here('newEnergyInvestment', 'data', 'europe_total.csv'))
world_solar <- read(
    here('newEnergyInvestment', 'data', 'world_solar.csv'))
world_wind <- read(
    here('newEnergyInvestment', 'data', 'world_wind.csv'))
world_total <- read(
    here('newEnergyInvestment', 'data', 'world_total.csv'))
world_other <- read(
    here('newEnergyInvestment', 'data', 'world_other.csv'))

# Compute sector-specific data
china_wind     <- china_solar_wind - china_solar
china_other    <- china_total - china_solar_wind
us_solar       <- us_wind_solar - us_wind
us_other       <- us_total - us_wind_solar
europe_windoff <- europe_windon_windoff - europe_windon
europe_solar   <- europe_windon_windoff_solar - europe_windon_windoff
europe_other   <- europe_total - europe_windon_windoff_solar
world_biofuels <- world_total - world_solar - world_wind - world_other

# Create data frame







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
