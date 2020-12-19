# Load functions and libraries
library(tidyverse)
library(lubridate)
library(cowplot)
library(viridis)

# Read in sales data
allSales <- read_csv(here::here('data', 'usVehicleSales.csv')) %>% 
    gather(key = "month", value = "sales", Jan:Dec) %>% 
    rename(year = Month) %>% 
    filter(year >= 2013, year <= 2019) %>% 
    mutate(totalSales = sales / 10^3) %>% 
    left_join(data.frame(
        month = month.abb, 
        month_num = seq(length(month.abb))
    )) %>% 
    select(-month, -sales) %>% 
    rename(month = month_num)

pevSales <- read_csv(here::here('data', 'pevSales.csv')) %>%
    mutate(type = fct_relevel(type,
           'Tesla Model 3', 'Tesla Model S & X', 'Non-Tesla')) %>% 
    group_by(type, date, category) %>% 
    summarise(sales = sum(sales)) %>% 
    ungroup() %>% 
    mutate(year = year(date), month = month(date)) %>%
    select(date, year, month, type, category, sales)

# Compute annual PEV market share ---------------------------------------------

annualSummary <- pevSales %>%
    group_by(year) %>%
    summarise(pevSales = sum(sales)) %>%
    left_join(
        allSales %>% 
            group_by(year) %>% 
            summarise(totalSales = sum(totalSales)), 
        by = 'year') %>% 
    mutate(pevShare = scales::percent(pevSales / totalSales))

# 2013  0.627%  
# 2014  0.723%  
# 2015  0.654%  
# 2016  0.912%  
# 2017  1.135%  
# 2018  2.086%  
# 2019  1.936%  
