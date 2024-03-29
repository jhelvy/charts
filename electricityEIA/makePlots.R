# Author: John Paul Helveston
# Date: First written on Friday, July 5, 2019
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Barplots of energy capacity and generation by country / region using
# EIA data.

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# Load and format data
dfPath <- here::here('electricityEIA', 'data', 'formattedData.csv')
electricityDf <- read_csv(dfPath)

# Reorder factors for plotting
electricityDf$country <- factor(electricityDf$country,
                                c('Other', 'Europe', 'USA', 'China'))

# Plot comparing wind and nuclear power
windNuclearCapacityCompare <- ggplot(electricityDf %>%
    filter(
        type == 'Capacity', year > 1999, year < 2017,
        category %in% c('Wind', 'Nuclear')),
    aes(x = year, y = value)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    facet_wrap(~category) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    scale_x_discrete(breaks=seq(2000, 2016, 2)) +
    scale_y_continuous(limits=c(0, 500), breaks=seq(0, 500, 100)) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.2)) +
    labs(x       = 'Year',
         y       = 'Installed Power Capacity (GW)',
         title   = 'Installed Wind and Nuclear Power Capacity by Country / Region',
         fill    = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

# Wind - capacity
windCapacity <- ggplot(electricityDf %>%
    filter(type == 'Capacity', category == 'Wind', year > 1999, year < 2017),
    aes(x = year, y = value)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    scale_x_discrete(breaks=seq(2000, 2016, 2)) +
    scale_y_continuous(limits=c(0, 500), breaks=seq(0, 500, 100)) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.2)) +
    labs(x       = 'Year',
         y       = 'Installed Power Capacity (GW)',
         title   = 'Installed Wind Power Capacity by Country / Region',
         fill    = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

windCapacity_lines <- ggplot(electricityDf %>%
    filter(type == 'Capacity', category == 'Wind', year > 1999, year < 2017),
    aes(x = as.numeric(year), y = value)) +
    geom_point(aes(color = country)) +
    geom_line(aes(color = country)) +
    scale_color_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    scale_x_continuous(breaks=seq(2000, 2016, 2)) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.2)) +
    labs(x       = 'Year',
         y       = 'Installed Power Capacity (GW)',
         title   = 'Installed Wind Power Capacity by Country / Region',
         color   = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

# Nuclear - current capacity
nuclearCapacity_current <- ggplot(electricityDf %>%
    filter(type == 'Capacity', category == 'Nuclear'),
    aes(x = year, y = value)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    scale_x_discrete(breaks=seq(1980, 2016, 4)) +
    scale_y_continuous(limits=c(0, 400), breaks=seq(0, 400, 100)) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none",
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.2)) +
    labs(x       = 'Date',
         y = 'Nuclear Energy Capacity (GW)',
         title   = 'Installed Nuclear Power Capacity by Country / Region',
         fill    = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here::here('electricityEIA', 'plots', 'windNuclearCapacityCompare.pdf'),
       windNuclearCapacityCompare, width=11, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'windCapacity.pdf'),
       windCapacity, width=8, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'windCapacity_lines.pdf'),
       windCapacity_lines, width=8, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'nuclearCapacity_current.pdf'),
       nuclearCapacity_current, width=8, height=5, dpi=150)

# Previews
ggsave(here::here('electricityEIA', 'plots', 'windNuclearCapacityCompare.png'),
       windNuclearCapacityCompare, width=11, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'windCapacity.png'),
       windCapacity, width=8, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'windCapacity_lines.png'),
       windCapacity_lines, width=8, height=5, dpi=150)
ggsave(here::here('electricityEIA', 'plots', 'nuclearCapacity_current.png'),
       nuclearCapacity_current, width=8, height=5, dpi=150)

# Print summary of 2016 wind capacity
electricityDf %>%
    filter(type == 'Capacity', category == 'Wind', year == 2016) %>%
    mutate(percent = value / sum(value))
