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
dfPath <- here::here('newEnergyInvestment', 'data', 'formattedData.csv')
df <- read_csv(dfPath)

# Reorder factors for plotting
df$country <- factor(df$country, c('ROW', 'EU', 'USA', 'China'))
df$type <- factor(df$type, c('Solar', 'Wind', 'Other'))

# Summary line plot of investment by country 
countrySummaryDf <- df %>% 
    group_by(year, country) %>% 
    summarise(investment = sum(investment))
countryLines <- countrySummaryDf %>% 
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
countryTechBars <- ggplot(df,
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    facet_wrap(~ type) +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance') +
    theme(
        legend.position   = c(0.81, 0.8),
        legend.background = element_rect(
            fill = 'white', size = 0.5, linetype = 'solid', colour = 'black'))

countrySolarBars <- ggplot(df %>% filter(type == 'Solar'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Solar Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

countryWindBars <- ggplot(df %>% filter(type == 'Wind'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Wind Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

countryOtherBars <- ggplot(df %>% filter(type == 'Other'),
    aes(x = year, y = investment)) +
    geom_bar(aes(fill = country), position = 'stack', stat = 'identity') +
    scale_x_continuous(limits = c(2004, 2019), breaks = seq(2005, 2018, 4)) +
    scale_y_continuous(limits = c(0, 200), breaks=seq(0, 200, 50)) +
    scale_fill_manual(
        values = jColors('extended', c('gray', 'yellow', 'blue', 'red'))) +
    theme_cowplot() +
    background_grid(major = "y", minor = "none") +
    labs(x       = 'Year',
         y       = '$USD Billion',
         title   = 'New Investment in Other Clean Energy',
         fill    = 'Country / Region',
         caption = 'Data Source: Bloomberg New Energy Finance')

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryLines.pdf'),
       countryLines, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryTechBars.pdf'),
       countryTechBars, width=11, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countrySolarBars.pdf'),
       countrySolarBars, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryWindBars.pdf'),
       countryWindBars, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryOtherBars.pdf'),
       countryOtherBars, width=7, height=5, dpi=150)

ggsave(here::here('newEnergyInvestment', 'plots', 'countryLines.png'),
       countryLines, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryTechBars.png'),
       countryTechBars, width=11, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countrySolarBars.png'),
       countrySolarBars, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryWindBars.png'),
       countryWindBars, width=7, height=5, dpi=150)
ggsave(here::here('newEnergyInvestment', 'plots', 'countryOtherBars.png'),
       countryOtherBars, width=7, height=5, dpi=150)
