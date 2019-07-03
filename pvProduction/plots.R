library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(readxl)

# ----------------------------------------------------------------------------
# Solar production

# Data sources:
# 1995 to 2012: Earth Policy Institute
#               http://www.earth-policy.org/datacenter/xls/indicator12_2013_2.xlsx
# 2013 to 2018: Jäger-Waldau, A. (2019).
#               Snapshot of Photovoltaics—February 2019. Energies, 12(5), 769.
#               https://www.mdpi.com/1996-1073/12/5/769
#               Data reverse engineered from Figure 1 using WebPlotDigitizer:
#               https://automeris.io/WebPlotDigitizer/

# Read in and format 1995 to 2012 data
solar95_12 <- read_excel(here('data', 'solar', 'indicator12_2013_2.xlsx'),
                         sheet = 'PV Prod by Country', skip = 2)
# Drop first two (blank) rows,
solar95_12 <- solar95_12[-c(1:2), ] %>%
    # Drop summary rows past year 2012
    filter(Year <= 2012) %>%
    # Select focal columns
    select(Year, China, `United States`, World) %>%
    # Replace NAs with 0
    mutate(China = ifelse(China == 'n.a.', 0, China)) %>%
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'World') %>%
    # Convert from MW to GW
    mutate(Production = as.numeric(Production) / 10^3)

# Read in and format 2013 to 2018 data (Production in GW)
total <- read.csv(here('data', 'solar', 'productionTotal.csv'), header=F)$V2
china <- read.csv(here('data', 'solar', 'productionChina.csv'), header=F)$V2
us0   <- read.csv(here('data', 'solar', 'productionUS0.csv'), header=F)$V2
us1   <- read.csv(here('data', 'solar', 'productionUS1.csv'), header=F)$V2
solar05_18 <- tibble(
    Year            = c(2005, 2008, seq(2010, 2018)),
    China           = china,
    `United States` = us1 - us0,
    World           = total) %>%
    # Convert to tidy format for plotting
    gather('Country', 'Production', 'China':'World')

# Merge and gather for plotting
solarDf <- rbind(solar95_12, filter(solar05_18, Year > 2012)) %>%
    mutate(
        Year = as.numeric(Year),
        Country = ifelse(Country == 'World', 'Rest of World', Country))

# Reorder factors for plotting
solarDf$Country <- factor(solarDf$Country,
    c('Rest of World', 'China', 'United States'))

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

# ----------------------------------------------------------------------------
# Wind

# Data source:
# U.S. Energy Information Administration (EIA)
# https://www.eia.gov/beta/international/data/browser/#/?pa=0000000000000000000007vo7&c=00000000000000000000000000000000000000000000000001&ug=8&tl_id=2-A&vs=INTL.2-7-WORL-MK.A&cy=2016&vo=0&v=C&end=2016

windUC <- read_csv(here('data', 'wind', 'International_data_china_us.csv'), 
                   skip=4)
windWorld <- read_csv(here('data', 'wind', 'International_data_world.csv'),
                      skip=4)
windUC[,1] <- NULL

# ----------------------------------------------------------------------------
# View plots

solarPlot
nuclearPlot_currentCap
nuclearPlot_newCap
