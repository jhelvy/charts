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
nuclearDf <- read_csv(
    here('worldNuclearAssociation', 'data', 'nuclearDf.csv')) %>%
    mutate(capacity = operable_mw / 10^3) %>%
    select(country, year, month, capacity) %>%
    filter(country %in% c('China', 'Usa', 'World')) %>%
    distinct() %>%
    spread(country, capacity) %>%
    mutate('Rest of World' = World - China - Usa) %>%
    select(-World) %>%
    gather(country, capacity, China:'Rest of World') %>%
    mutate(country = ifelse(country == 'Usa',
        as.character('United States'), country)) %>%
    group_by(country, year) %>%
    summarise(capacity = mean(capacity)) %>%
    mutate(
        newCapacity = capacity - lag(capacity, 1),
        newCapacity = ifelse(newCapacity < 0, 0, newCapacity))

# Reorder factors for plotting
nuclearDf$country <- factor(nuclearDf$country,
                          c('Rest of World', 'China', 'United States'))

# Current operating capacity plot
currentCapacity <- ggplot(nuclearDf,
    aes(x=year, y=capacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Date',
         y = 'Nuclear Energy Capacity (GW)',
         fill = 'Country')

# New capacity plot
newCapacity <- ggplot(nuclearDf %>% filter(year > 2007),
    aes(x=year, y=newCapacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    scale_x_continuous(breaks=c(2008, 2012, 2016, 2019)) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Date',
         y = 'New Nuclear Energy Capacity (GW)',
         fill = 'Country')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('worldNuclearAssociation', 'plots', 'currentCapacity.pdf'),
       currentCapacity, width=11, height=5, dpi=150)
ggsave(here('worldNuclearAssociation', 'plots', 'newCapacity.pdf'),
       newCapacity, width=7, height=5, dpi=150)

ggsave(here('worldNuclearAssociation', 'plots', 'currentCapacity.png'),
       currentCapacity, width=11, height=5, dpi=150)
ggsave(here('worldNuclearAssociation', 'plots', 'newCapacity.png'),
       newCapacity, width=7, height=5, dpi=150)
