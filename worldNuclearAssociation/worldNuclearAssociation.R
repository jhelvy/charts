library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(readxl)

# ----------------------------------------------------------------------------
# Nuclear energy

# Data sources:
# Webscraped data from the World Nuclear Association
# http://www.world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx

nuclearDf <- read_csv(here('data', 'nuclear', 'nuclearDf.csv'))
nuclearDf <- nuclearDf %>%
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
nuclearPlot_currentCap <- ggplot(nuclearDf,
    aes(x=year, y=capacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Date',
         y = 'Nuclear Energy Production (GW)',
         fill = 'Country')

# New capacity plot
nuclearPlot_newCap <- ggplot(nuclearDf %>% filter(year > 2007),
    aes(x=year, y=newCapacity)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(values = jColors('extended', c('gray', 'red', 'blue'))) +
    scale_x_continuous(breaks=c(2008, 2012, 2016, 2019)) +
    background_grid(major = "xy", minor = "none") +
    labs(x = 'Date',
         y = 'New Nuclear Energy Capacity (GW)',
         fill = 'Country')
