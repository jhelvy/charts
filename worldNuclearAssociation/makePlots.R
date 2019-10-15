# Author: John Paul Helveston
# Date: First written on Friday, July 5, 2019
#
# Description:
# Barplots of nuclear energy capacity by country
#
# Data sources:
# Webscraped data from the World Nuclear Association
# http://www.world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# Read in and format data
dfPath <- here::here('worldNuclearAssociation', 'data', 'formattedData.csv')
nuclearDf <- read_csv(dfPath)

# Reorder factors for plotting
nuclearDf$country <- factor(nuclearDf$country,
                          c('Rest of World', 'China', 'United States'))

# Current operating capacity plot
currentCapacity <- ggplot(nuclearDf,
    aes(x=year, y=capacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2006, 2020),
                       breaks = seq(2007, 2019, 2)) +
    scale_y_continuous(limits = c(0, 400), breaks=seq(0, 400, 100)) +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x = 'Date',
         y = 'Nuclear Energy Capacity (GW)',
         fill = 'Country')

# New capacity plot
newCapacity <- ggplot(nuclearDf %>% filter(year > 2007),
    aes(x=year, y=newCapacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(breaks=c(2008, 2012, 2016, 2019)) +
    scale_y_continuous(limits = c(0, 8), breaks=seq(0, 8, 2)) +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x = 'Date',
         y = 'New Nuclear Energy Capacity (GW)',
         fill = 'Country')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('worldNuclearAssociation', 'plots', 'currentCapacity.pdf'),
       currentCapacity, width=10, height=5, dpi=150)
ggsave(here('worldNuclearAssociation', 'plots', 'newCapacity.pdf'),
       newCapacity, width=7, height=5, dpi=150)

ggsave(here('worldNuclearAssociation', 'plots', 'currentCapacity.png'),
       currentCapacity, width=10, height=5, dpi=150)
ggsave(here('worldNuclearAssociation', 'plots', 'newCapacity.png'),
       newCapacity, width=7, height=5, dpi=150)
