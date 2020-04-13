# Author: John Paul Helveston
# Date: First written on Monday, August 28, 2017
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Federal highway fund revenues and expenditures in real dollars from 
# 1980 to 2015.

# For details on data sources, see the "data_source.txt" file

library(tidyverse)
library(cowplot)

# --------------------------------------------------------------------------

# Import data for plotting
plotData <- read_csv(file.path('usHighwayFund', 'data', 'plotData2015.csv'))
revenueData <- plotData %>%
    gather(type, revenue, fuelRev:transfers) %>%
    select(year, type, revenue) %>% 
    mutate(
        type = fct_relevel(type, 
        c('transfers', 'nonFuelRev', 'fuelRev')),
        type = fct_recode(type, 
        "Fuel tax revenue" = "fuelRev", 
        "Non-fuel tax revenue" = "nonFuelRev",
        "Transfers from general fund" = "transfers"))
expenditureData <- plotData[c('year', 'expenditures')]

# Set plot colors
plotColors <- c('#faa74b', '#979797', '#5f645d')

# Make the plot
usHighwayFund <- ggplot(revenueData,
    aes(x = year, y = revenue)) +
    geom_col(aes(fill = type)) +
    geom_line(data = expenditureData, aes(x=year, y=expenditures),
        color = '#f16523') +
    annotate(geom = 'text', x = 2003, y = 43, color = '#f16523', 
             label = 'Expenditures') + 
    scale_fill_manual(values = plotColors) +
    scale_x_continuous(breaks = seq(1980, 2015, 5)) +
    scale_y_continuous(
        breaks = seq(0, 60, 10), labels = scales::dollar,
        expand = expand_scale(mult = c(0, 0.05))) +
    theme_minimal_hgrid() +
    theme(legend.position = c(0.15, 0.8),
          legend.background = element_rect(
          fill = 'white', color = 'white', size = 3),
          legend.text = element_text(size = 10),
          legend.title = element_text(size = 12), 
          plot.caption = element_text(size = 8)) +
    labs(x = 'Year', 
         y = '$ Billions', 
         fill = 'Funding',
         caption = 'Source: Federal Highway Administration, "Status of the Federal Highway Trust Fund, Fiscal Years 1957-2015."') 

ggsave(file.path('usHighwayFund', 'plots', 'usHighwayFund2015.pdf'),
       usHighwayFund, width=7, height=5)

ggsave(file.path('usHighwayFund', 'plots', 'usHighwayFund2015.png'),
       usHighwayFund, width=7, height=5)
