# Author: John Paul Helveston
# Date: First written on Friday, October 11, 2019
#
# Description:
# Summary plots of the US solar industry, including total module deployment
# and job growth pre and post the Trump administration tariffs.

library(tidyverse)
library(cowplot)
library(readxl)
library(here)
library(jhelvyr)

# Read in data data
jobs <- read_csv(here::here('usSolarIndustry', 'data', 'jobs.csv'))
modules <- read_csv(here::here('usSolarIndustry', 'data', 'modules.csv'))

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
        caption = 'Data Source: U.S. EIA, https://www.eia.gov/renewable/monthly/solar_photo/')

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
        caption = 'Data Source: The Solar Foundation')

ggsave(here('usSolarIndustry', 'plots', 'moduleShipments.pdf'),
        moduleShipments, width=7, height=5, dpi=150)
ggsave(here('usSolarIndustry', 'plots', 'moduleShipments.png'),
       moduleShipments, width=7, height=5, dpi=150)

ggsave(here('usSolarIndustry', 'plots', 'jobsPlot.pdf'),
        jobsPlot, width=7, height=5, dpi=150)
ggsave(here('usSolarIndustry', 'plots', 'jobsPlot.png'),
       jobsPlot, width=7, height=5, dpi=150)
