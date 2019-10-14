# Author: John Paul Helveston
# Date: First written on Thursday, July 4, 2019
#
# Description:
# Barplots of clean energy investment by country and type

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(ggrepel)

# Read in and format data
source(here('newEnergyInvestment', 'formatData.R'))

countrySummaryDf <- df %>% 
    group_by(year, country) %>% 
    summarise(investment = sum(investment))
countryLinePlot <- countrySummaryDf %>% 
    ggplot(aes(x = year, y = investment)) + 
    geom_line(aes(color = country), size = 0.8) +
    geom_text_repel(aes(label = country, color = country),
        data          = subset(countrySummaryDf, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2004, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 150), breaks=seq(0, 150, 50)) +
    scale_color_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    labs(x       = 'Year',
         y       = 'Billions of U.S. Dollars',
         title   = 'New Annual Investment in Clean Energy Industries',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance') +
    background_grid(major = "y", minor = "none") +
    theme(legend.position = 'none')

# Plot of solar, wind, and other investments
facetPlot <- ggplot(df,
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    facet_wrap(~ type) +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance') +
    theme(
        legend.position   = c(0.81, 0.8),
        legend.background = element_rect(
            fill = 'white', size = 0.5, linetype = 'solid', colour = 'black'))

solarPlot <- ggplot(df %>% filter(type == 'Solar'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Solar Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

windPlot <- ggplot(df %>% filter(type == 'Wind'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Wind Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

otherPlot <- ggplot(df %>% filter(type == 'Other'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    background_grid(major = "xy", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Other Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('newEnergyInvestment', 'plots', 'countryLinePlot.pdf'),
       countryLinePlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'facetPlot.pdf'),
       facetPlot, width=11, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'solarPlot.pdf'),
       solarPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'windPlot.pdf'),
       windPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'otherPlot.pdf'),
       otherPlot, width=7, height=5, dpi=150)

ggsave(here('newEnergyInvestment', 'plots', 'countryLinePlot.png'),
       countryLinePlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'facetPlot.png'),
       facetPlot, width=11, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'solarPlot.png'),
       solarPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'windPlot.png'),
       windPlot, width=7, height=5, dpi=150)
ggsave(here('newEnergyInvestment', 'plots', 'otherPlot.png'),
       otherPlot, width=7, height=5, dpi=150)
