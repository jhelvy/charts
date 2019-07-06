# Data Sources: See "sources.txt" in "data" folder for details
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
