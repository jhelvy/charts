# Data Sources: See "data_sources.txt" for details
#
# Clean energy investment by Bloomberg New Energy Finance:
# https://about.bnef.com/clean-energy-investment/

library(tidyverse)
library(here)

# Read in and format 1995 to 2013 data
read <- function(path) {return(read.csv(path, header=F)$V2)}
china_solar <- read(
    here('newEnergyInvestment', 'data', 'china_solar.csv'))
china_solar_wind <- read(
    here('newEnergyInvestment', 'data', 'china_solar_wind.csv'))
china_total <- read(
    here('newEnergyInvestment', 'data', 'china_total.csv'))
eu_wind <- read(
    here('newEnergyInvestment', 'data', 'europe_windon_windoff.csv'))
eu_wind_solar <- read(
    here('newEnergyInvestment', 'data', 'europe_wind_solar.csv'))
eu_total <- read(
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

# Create main data frame merging all the data
df <- data.frame(
    year        = seq(2005, 2018),
    China_Solar = china_solar,
    China_Wind  = china_solar_wind - china_solar,
    China_Other = china_total - china_solar_wind,
    EU_Solar    = eu_wind_solar - eu_wind,
    EU_Wind     = eu_wind,
    EU_Other    = eu_total - eu_wind_solar,
    USA_Solar   = us_wind_solar - us_wind,
    USA_Wind    = us_wind,
    USA_Other   = us_total - us_wind_solar,
    World_Solar = world_solar,
    World_Wind  = world_wind,
    World_Other = world_total - world_solar - world_wind) %>%
    mutate(
        ROW_Solar = World_Solar - China_Solar - USA_Solar - EU_Solar,
        ROW_Wind  = World_Wind - China_Wind - USA_Wind - EU_Wind,
        ROW_Other = World_Other - China_Other - USA_Other - EU_Other,
    ) %>%
    gather(country_type, investment, China_Solar:ROW_Other) %>%
    separate(country_type, c('country', 'type'), sep='_') %>%
    filter(country != 'World')

# Export formatted data to "data" folder:
write_csv(df, here::here('newEnergyInvestment', 'data', 'formattedData.csv'))
