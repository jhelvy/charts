# Author: John Paul Helveston
# Date: First written on Monday, October 14, 2019
#
# Description:
# Plots of patenting in clean energy technologies by country and over time

library(tidyverse)
library(cowplot)
library(here)
library(jhelvyr)
library(ggrepel)
library(readxl)

# New clean energy investment plots: 
source(here('newEnergyInvestment', 'formatData.R'))
countrySummaryDf <- df %>% 
    group_by(year, country) %>% 
    summarise(investment = sum(investment)) %>% 
    mutate(country = ifelse(country == 'Europe', 'EU', as.character(country)))
investmentPlot <- countrySummaryDf %>% 
    ggplot(aes(x = year, y = investment)) + 
    geom_line(aes(color = country), size = 0.8) +
    geom_text_repel(aes(label = country, color = country),
                    data          = subset(countrySummaryDf, year == max(year)),
                    size          = 5,
                    hjust         = 0,
                    nudge_x       = 0.5,
                    nudge_y       = 2,
                    segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 150), breaks=seq(0, 150, 50)) +
    scale_color_manual(
        values = jColors('extended', c('red', 'green', 'gray', 'blue'))) +
    theme_cowplot() +
    labs(x       = '',
         y       = 'New Investment in Clean Energy\n(Billions of U.S. Dollars)',
         fill    = 'Country / Region') +
    background_grid(major = "y", minor = "none", 
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.1)) +
    theme(legend.position = 'none')

# Clean energy patenting:
mainDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-45.xlsx')
chinaDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-46.xlsx')
df <- read_excel(mainDfDataPath, skip = 3)
chinaDf <- read_excel(chinaDfDataPath, skip = 3) %>%
    select(-Year) 
df <- df %>% 
    bind_cols(chinaDf) %>% 
    mutate(
        USA = `United States`,
        Other = ROW - China + `South Korea`, 
        year = as.numeric(Year)) %>% 
    select(-c(Taiwan, India, ROW, Year, `South Korea`, `United States`)) %>% 
    gather(country, numPatents, Japan:Other) 
patentPlot <- df %>% 
    ggplot(aes(x = year, y = numPatents, color = country)) +
    geom_line(size = 0.8) + 
    geom_text_repel(aes(label = country, color = country),
        data          = subset(df, year == max(year)),
        size          = 5,
        hjust         = 0,
        nudge_x       = 0.5,
        nudge_y       = 2,
        segment.color = NA) +
    scale_x_continuous(limits = c(2006, 2020), breaks = seq(2006, 2018, 4)) +
    scale_y_continuous(limits = c(0, 5100), breaks = seq(0, 5000, 2500)) +
    scale_color_manual(
    values = jColors('extended', c('red', 'green', 'yellow', 'gray', 'blue'))) +
    theme_cowplot() +
    labs(x       = 'Year',
         y       = 'Number of USPTO Patents \nin Clean Energy Technologies') +
    background_grid(major = "y", minor = "none", 
                    color.major = rgb(0.5, 0.5, 0.5, alpha = 0.1)) +
    theme(legend.position = 'none')

multiplot <- plot_grid(investmentPlot, patentPlot, labels = c('A', 'B'), label_size = 12, 
          nrow = 2)

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here('scienceCommentary2019', 'plots', 'multiplot.pdf'),
       multiplot, width=7, height=8, dpi=150)

ggsave(here('scienceCommentary2019', 'plots', 'multiplot.png'),
       multiplot, width=7, height=8, dpi=150)