library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)

# ----------------------------------------------------------------------------
# Data source:
# U.S. Energy Information Administration (EIA)
# Official Energy Statistics from the U.S. Government
# https://www.eia.gov/beta/international/data/browser/

# Read in raw data
china_us <- read_csv(
    here('electricityEIA', 'data', 'international_data_china_us.csv'),
    skip = 4)
europe_world <- read_csv(
    here('electricityEIA', 'data', 'international_data_europe_world.csv'),
    skip = 4)

# Drop non-informative columnes and rename first two columnes
china_us     <- china_us[,-1]
europe_world <- europe_world[,-1]
df <- rbind(china_us, europe_world)
colnames(df)[1:2] <- c('category', 'unit')

# Get the row IDs for the countries and the categories
china_i  <- which(str_detect(df$category, 'China'))
us_i     <- chinaRowIDs + 1
cat_i    <- chinaRowIDs - 1
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
electricityDf <- rbind(chinaDf, europeDf, usDf, worldDf) %>%
    gather(year, value, `1980`:`2017`) %>%
    mutate(
        value = ifelse(is.na(value), 0, value),
        value = ifelse(value %in% c('-', '--'), 0, value),
        value = parse_number(value)) %>% 
    spread(country, value) %>% 
    mutate(Other = World - China - Europe - USA) %>% 
    select(-World) %>% 
    gather(country, value, China:Other) 

# Reorder factors for plotting
electricityDf$country <- factor(electricityDf$country, 
                                c('Other', 'Europe', 'USA', 'China'))

# Make plots 
windCapacity <- ggplot(electricityDf %>% 
    filter(type == 'Capacity', category == 'Wind', year > 1999, year < 2017),
    aes(x = year, y = value)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = 'Installed Power Capacity (GW)',
         title   = 'Installed Wind Power Capacity by Country / Region',
         fill    = 'Country / Region',
         caption = 'Data Source: U.S. Energy Information Administration')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('electricityEIA', 'plots', 'windCapacity.pdf'),
       windCapacity, width=11, height=5, dpi=150)

ggsave(here('electricityEIA', 'plots', 'windCapacity.png'),
       windCapacity, width=11, height=5, dpi=150)