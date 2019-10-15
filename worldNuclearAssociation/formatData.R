# Data Sources: See "data_sources.txt" for details
#
library(tidyverse)
library(here)
library(readxl)

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

# Export formatted data to "data" folder:
savePath <- here::here('worldNuclearAssociation', 'data', 'formattedData.csv')
write_csv(nuclearDf, savePath)
