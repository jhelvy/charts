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
library(here)
library(jhelvyr)

# Read in and format data
jobs <- read_csv(here('usSolarIndustry', 'data', 'jobs.csv'))
# Modules units:
# total_shipments = peak kilowatts
# value           = thousand dollars
# ave_value       = dollars per peak watt
modules <- read_csv(here('usSolarIndustry', 'data', 'pv_table3.csv'))




library(readxl)
df <- read_excel(here('usSolarIndustry', 'data', 'pv_table3.xlsx'))


ggsave(here('usSolarIndustry', 'plots', 'plots.pdf'),
       jobs, width=7, height=5, dpi=150)
