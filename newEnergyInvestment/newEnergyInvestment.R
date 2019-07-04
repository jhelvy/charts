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
europe_wind <- read(
    here('newEnergyInvestment', 'data', 'europe_windon_windoff.csv'))
europe_wind_solar <- read(
    here('newEnergyInvestment', 'data', 'europe_wind_solar.csv'))
europe_total <- read(
    here('newEnergyInvestment', 'data', 'europe_total.csv'))
us_wind <- read(
    here('newEnergyInvestment', 'data', 'us_wind.csv'))
us_wind_solar <- read(
    here('newEnergyInvestment', 'data', 'us_wind_solar.csv'))
us_total <- read(
    here('newEnergyInvestment', 'data', 'us_total.csv'))
world_solar <- read(
    here('newEnergyInvestment', 'data', 'world_solar.csv'))
world_wind <- read(
    here('newEnergyInvestment', 'data', 'world_wind.csv'))
world_total <- read(
    here('newEnergyInvestment', 'data', 'world_total.csv'))
world_other <- read(
    here('newEnergyInvestment', 'data', 'world_other.csv'))

# Create data frame
df <- data.frame(
    year         = seq(2005, 2018),
    China_Solar  = china_solar,
    China_Wind   = china_solar_wind - china_solar,
    China_Other  = china_total - china_solar_wind,
    Europe_Solar = europe_wind_solar - europe_wind,
    Europe_Wind  = europe_wind,
    Europe_Other = europe_total - europe_wind_solar,
    USA_Solar     = us_wind_solar - us_wind,
    USA_Wind      = us_wind,
    USA_Other     = us_total - us_wind_solar,
    World_Solar  = world_solar,
    World_Wind   = world_wind,
    World_Other  = world_total - world_solar - world_wind) %>%
    mutate(
        Other_Solar = World_Solar - China_Solar - USA_Solar - Europe_Solar,
        Other_Wind  = World_Wind - China_Wind - USA_Wind - Europe_Wind,
        Other_Other = World_Other - China_Other - USA_Other - Europe_Other,
    ) %>%
    gather(country_type, investment, China_Solar:Other_Other) %>%
    separate(country_type, c('country', 'type'), sep='_') %>%
    filter(country != 'World')

# Reorder factors for plotting
df$country <- factor(df$country, c('Other', 'Europe', 'USA', 'China'))
df$type <- factor(df$type, c('Solar', 'Wind', 'Other'))

# Make the plots
facetPlot <- ggplot(df,
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    facet_wrap(~ type) +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance') +
    theme(
        legend.position   = c(0.81, 0.8),
        legend.background = element_rect(
            fill = 'white', size = 0.5, linetype = 'solid', colour = 'black'))

solarPlot <- ggplot(df %>% filter(type == 'Solar'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Solar Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

windPlot <- ggplot(df %>% filter(type == 'Wind'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Wind Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

otherPlot <- ggplot(df %>% filter(type == 'Other'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Other Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('newEnergyInvestment', 'plots', 'facetPlot.pdf'),
       facetPlot, width=11, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'solarPlot.pdf'),
       solarPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'windPlot.pdf'),
       windPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'otherPlot.pdf'),
       otherPlot, width=7, height=5, dpi=150)

ggsave(here('newEnergyInvestment', 'plots', 'facetPlot.png'),
       facetPlot, width=11, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'solarPlot.png'),
       solarPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'windPlot.png'),
       windPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'otherPlot.png'),
       otherPlot, width=7, height=5, dpi=150)
