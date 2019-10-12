# Author: John Paul Helveston
# Date: First written on Friday, October 11, 2019
#
# Description:
# Summary plots of the US solar industry, including total module deployment
# and job growth pre and post the Trump administration tariffs.
#
# Data sources:
# Jobs data from The Solar Foundation (2019 is forecasted)
# Copied from this article:
# https://www.bloomberg.com/news/articles/2019-02-12/trump-s-tariffs-took-a-bite-out-of-once-booming-solar-job-market
#
# PV Solar module data from the US EIA:
# https://www.eia.gov/renewable/monthly/solar_photo/

library(tidyverse)
library(cowplot)
library(readxl)
library(here)
library(jhelvyr)

# Read in jobs data
jobs <- read_csv(here('usSolarIndustry', 'data', 'jobs.csv'))

# Read in modules data
# Modules units:
# total_shipments = peak kilowatts
# value           = thousand dollars
# ave_value       = dollars per peak watt
df <- read_excel(here('usSolarIndustry', 'data', 'pv_table3.xlsx'), skip = 2)
colnames(df) <- c("year", "total_shipments", "value", "ave_value")
id17 <- which(df$year == '2017*')
id18 <- which(df$year == '2018*')
id19 <- which(df$year == '2019*')
modules <- df17 <- df[1:(id17-1),]
modules$year <- as.numeric(modules$year)
df17 <- df[(id17+1):(id18-1),]
df18 <- df[(id18+1):(id19-1),]
df19 <- df[(id19+1):(nrow(df)-2),]
dfTemp <- data.frame(
    year = c(2017, 2018, 2019),
    total_shipments = c(sum(df17$total_shipments), sum(df18$total_shipments),
                        sum(df19$total_shipments)),
    value = c(sum(df17$value), sum(df18$value), sum(df19$value)),
    ave_value = c(mean(df17$ave_value), mean(df18$ave_value),
                  mean(df19$ave_value))
)
modules <- bind_rows(modules, dfTemp)

# Make summary plots

moduleShipments <- modules %>%
    filter(year < 2019) %>%
    mutate(total_shipments = total_shipments / 10^3) %>%
    ggplot(aes(x=year, y=total_shipments)) +
    geom_point() +
    scale_x_continuous(breaks=seq(2006, 2018, 2)) +
    geom_vline(xintercept = 2018, color = 'red') +
    theme_cowplot() +
    labs(
        x = 'Year',
        y = 'Total Shipments (in Peak Megawatts)',
        title = 'U.S. Solar Photovoltaic Module Shipments',
        caption = 'Data Source: U.S. EIA, https://www.eia.gov/renewable/monthly/solar_photo/'
    )

jobsPlot <- jobs %>%
    filter(year < 2019) %>%
    ggplot(aes(x=year, y=jobs)) +
    geom_point() +
    scale_x_continuous(breaks=seq(2006, 2018, 2)) +
    geom_vline(xintercept = 2018, color = 'red') +
    theme_cowplot() +
    labs(
        x = 'Year',
        y = 'Jobs in U.S. Solar Industry (Thousands)',
        title = 'U.S. Solar Photovoltaic Jobs (Thousands)',
        caption = 'Data Source: The Solar Foundation'
    )

ggsave(here('usSolarIndustry', 'plots', 'moduleShipments.pdf'),
        moduleShipments, width=7, height=5, dpi=150)

ggsave(here('usSolarIndustry', 'plots', 'jobsPlot.pdf'),
        jobsPlot, width=7, height=5, dpi=150)
