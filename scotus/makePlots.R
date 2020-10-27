# Author: John Paul Helveston
# Date: First written on Tuesday, October 27, 2020
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Lollipop chart of SCOTUS nominees

library(tidyverse)
library(lubridate)
library(cowplot)
options(dplyr.width = Inf)

# Load data
source(here::here('scotus', 'formatData.R'))

# Create left chart: Days from nomination to next election
electionYearThreshold <- scotus %>% 
  filter(nominatedInElectionYear == 1) %>% 
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
barrettLabel <- "In 2020, Senate Republications\nrushed to confirm Amy C. Barrett\njust 7 days before the 2020\npresidential election."
daysTilNextElection <- ggplot(scotus) +
    geom_segment(aes(x = nominee, xend = nominee,
                     y = 0 , yend = daysNomTilNextElection), color = "grey50") +
    geom_point(aes(x = nominee, y = daysNomTilNextElection,
                   color = presidentParty), size = 2.5) +
    coord_flip() +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                       labels = scales::comma) +
    scale_color_manual(values = c("blue", "red", "gray")) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Georgia') +
    theme(legend.position = "none",
          axis.text.y = element_text(size = 11),
          axis.title.x = element_text(vjust = -5),
          plot.caption = element_text(hjust = 0, face = "italic", vjust = -10),
          plot.caption.position =  "plot") +
    labs(y = "Days from nomination to next election",
         x = "Justice nominee",
         caption = "*Nomination rejected") + 
    # Add annotations
    geom_curve(data = data.frame(
      x = 5, y = 800, xend = 1, yend = 60),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 90, curvature = -0.15, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), alpha = 1, inherit.aes = FALSE) + 
    annotate(geom = "label", x = 8, y = 600, label = barrettLabel, 
             size = 5, hjust = 0, family = "Georgia")

# Create right chart: Days from nomination to result
garlandLabel <- "In 2016, Senate Republications\nblocked the confirmation of\nMerrick Garland for a\nrecord-breaking 293 days,\nclaiming that it was unprecedented\nto confirm a justice during an\nelection year."
daysTilResult <- ggplot(scotus) +
    geom_segment(aes(x = nominee, xend = nominee,
                     y = 0 , yend = daysUntilResult), color = "grey") +
    geom_point(aes(x = nominee, y = daysUntilResult,
                   color = presidentParty), size = 2.5) +
    coord_flip() +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                       labels = scales::comma) +
    scale_color_manual(values = c("blue", "red", "gray")) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Georgia') +
    theme(legend.position = c(0.7, 0.94),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.caption = element_text(hjust = 1, face = "italic")) +
    labs(y = "Days from nomination to result",
         x = NULL,
         color = "President\nParty",
         caption = "Data: Wikipedia, List of nominations to SCOTUS") + 
    # Add annotations
    geom_curve(data = data.frame(
      x = 17, y = 270, xend = 8, yend = 293),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 80, curvature = -0.2, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), alpha = 1, inherit.aes = FALSE) + 
    annotate(geom = "label", x = 22, y = 125, label = garlandLabel, 
             size = 5, hjust = 0, family = "Georgia")

# Create the title
titleLabel <- "Senate Republicans have taken the SCOTUS nomination process to new extremes\nto pack the court with conservative justices"
title <- ggdraw() +
  draw_label(titleLabel, fontface = 'bold', x = 0, hjust = 0, size = 18) +
  theme(plot.margin = margin(8, 0, 0, 7))

# Combine into single chart
scotus_plot <- plot_grid(daysTilNextElection, daysTilResult,
                    labels = c('', ''), rel_widths = c(1.4, 1))
# Add title
scotus_plot <- plot_grid(title, scotus_plot, ncol = 1, rel_heights = c(0.025, 1))

ggsave(here::here('scotus', 'plots', 'scotus.pdf'),
       scotus_plot, width = 15, height = 20, device = cairo_pdf)
