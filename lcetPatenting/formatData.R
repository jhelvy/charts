# Data Sources: See "data_sources.txt" for details
# 
# Patenting in clean energy technologies from 2018 U.S. National Science 
# Foundation Science & Engineering Indicators:
# https://www.nsf.gov/statistics/2018/nsb20181/report/sections/industry-technology-and-the-global-marketplace/global-trends-in-sustainable-energy-research-and-technologies

library(tidyverse)
library(here)
library(readxl)

# Read in and format data
mainDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-45.xlsx')
chinaDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-46.xlsx')
df <- read_excel(mainDfDataPath, skip = 3)
chinaDf <- read_excel(chinaDfDataPath, skip = 3) %>%
    select(-Year) 
df <- df %>% 
    bind_cols(chinaDf) %>% 
    mutate(
        USA = `United States`,
        ROW  = ROW - China + `South Korea`, 
        year = as.numeric(Year)) %>% 
    select(-c(`United States`, Taiwan, India, `South Korea`, Year)) %>% 
    gather(country, numPatents, Japan:USA) 

# Export formatted data to "data" folder:
write_csv(df, here::here('lcetPatenting', 'data', 'formattedData.csv'))