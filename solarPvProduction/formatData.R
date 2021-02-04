# Data Sources: See "data_sources.txt" for details

library(tidyverse)
library(here)
library(janitor)
options(dplyr.width = Inf)

# Read in & format 2010 to 2019 data (Production in GW) from Engauge Digitizer
df <- read_csv(here::here('data', 'digitize.csv')) %>% 
    clean_names() %>% 
    rename(year = x) %>% 
    mutate(year = floor(year) + 1) %>% 
    gather(key = "country", value = "n", china:total) %>% 
    group_by(year, country) %>% 
    summarise(production_gw = mean(n)) %>% 
    spread(key = country, value = production_gw) %>% 
    mutate(
        taiwan = china_taiwan - china, 
        europe = china_taiwan_europe - china_taiwan, 
        japan = china_taiwan_europe_japan - china_taiwan_europe, 
        malaysia = china_taiwan_europe_japan_malaysia - china_taiwan_europe_japan, 
        us = china_taiwan_europe_japan_malaysia_us - china_taiwan_europe_japan_malaysia, 
        row = total - china_taiwan_europe_japan_malaysia_us) %>% 
    select(year, china, taiwan, europe, japan, malaysia, us, row) %>% 
    ungroup() %>% 
    gather(key = "country", value = "production_gw", china:row) 

df
  
# Export formatted data to "data" folder:
write_csv(df, here::here('data', 'formattedData.csv'))
