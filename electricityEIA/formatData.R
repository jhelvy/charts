# Data source:
#
# Data Sources: See "data_sources.txt" for details
#
# U.S. Energy Information Administration (EIA)
# Official Energy Statistics from the U.S. Government
# https://www.eia.gov/beta/international/data/browser/

library(tidyverse)
library(here)

# Read in raw data
china_us <- read_csv(
    here::here('electricityEIA', 'data', 'international_data_china_us.csv'),
    skip = 4)
europe_world <- read_csv(
    here::here('electricityEIA', 'data', 'international_data_europe_world.csv'),
    skip = 4)

# Drop non-informative columnes and rename first two columnes
china_us     <- china_us[,-1]
europe_world <- europe_world[,-1]
df <- rbind(china_us, europe_world)
colnames(df)[1:2] <- c('category', 'unit')

# Get the row IDs for the countries and the categories
china_i  <- which(str_detect(df$category, 'China'))
us_i     <- china_i + 1
cat_i    <- china_i - 1
europe_i <- which(str_detect(df$category, 'Europe'))
world_i  <- europe_i + 1

# Create meta data df
category <- df[cat_i,]$category
unit     <- df[cat_i,]$unit
category[which(category %in% c('Capacity', 'Generation'))] <- 'Total'
metaDf <- data.frame(category = category, unit = unit) %>%
    mutate(type = as.character(
        c(rep('Capacity', n()/2), rep('Generation', n()/2))))

# Format individual country data frames
obsCols  <- which(! colnames(df) %in% c('category', 'unit'))
chinaDf  <- cbind(metaDf, df[china_i, obsCols])
usDf     <- cbind(metaDf, df[us_i, obsCols])
europeDf <- cbind(metaDf, df[europe_i, obsCols])
worldDf  <- cbind(metaDf, df[world_i, obsCols])
chinaDf$country  <- 'China'
usDf$country     <- 'USA'
europeDf$country <- 'Europe'
worldDf$country  <- 'World'

# Merge into one data frame
df <- rbind(chinaDf, europeDf, usDf, worldDf) %>%
    gather(year, value, `1980`:`2017`) %>%
    mutate(
        value = ifelse(is.na(value), 0, value),
        value = ifelse(value %in% c('-', '--'), 0, value),
        value = parse_number(value)) %>%
    spread(country, value) %>%
    mutate(Other = World - China - Europe - USA) %>%
    select(-World) %>%
    gather(country, value, China:Other)

# Export formatted data to "data" folder:
write_csv(df, here::here('electricityEIA', 'data', 'formattedData.csv'))
