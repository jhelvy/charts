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
plotColors <- c("blue", "red", "grey60")

# Create left chart: Days from nomination to next election
electionYearThreshold <- scotus %>% 
  filter(nominatedInElectionYear == 1) %>% 
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
barrettLabel <- "In 2020, Senate Republications\nrushed to confirm Judge Amy C.\nBarrett just 7 days before the 2020\npresidential election."
daysTilNextElection <- ggplot(scotus) +
    geom_segment(aes(x = 0 , xend = daysNomTilNextElection,
                     y = nominee, yend = nominee), color = "grey") +
    geom_point(aes(x = daysNomTilNextElection, y = nominee,
                   color = presidentParty), size = 2.5) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.05)),
                       labels = scales::comma, 
                       position = "top") +
    scale_color_manual(values = plotColors) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Roboto Condensed') +
    theme(legend.position = "none",
          axis.text.y = element_text(size = 10, family = "Georgia"),
          plot.caption = element_text(hjust = 0, face = "italic"),
          plot.caption.position =  "plot") +
    panel_border() +
    labs(x = "Days from nomination to next election",
         y = "Justice nominee",
         caption = "*Nomination rejected") + 
    # Add annotations
    geom_curve(data = data.frame(x = 900, xend = 60, y = 125, yend = 134),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 90, curvature = 0.2, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), alpha = 1, inherit.aes = FALSE) + 
    annotate(geom = "label", x = 450, y = 123, label = barrettLabel, 
             size = 6, hjust = 0, family = "Roboto Condensed")

# Create right chart: Days from nomination to result
garlandLabel <- "In 2016, Senate Republications\nblocked the confirmation of\nJudge Merrick Garland for a\nrecord-breaking 293 days,\nclaiming it was unprecedented\nto confirm a justice during\nan election year."
daysTilResult <- ggplot(scotus) +
    geom_segment(aes(x = 0 , xend = daysUntilResult,
                     y = nominee, yend = nominee), color = "grey") +
    geom_point(aes(x = daysUntilResult, y = nominee,
                   color = presidentParty), size = 2.5) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.05)),
                       labels = scales::comma,
                       position = "top") +
    scale_color_manual(values = plotColors) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Roboto Condensed') +
    theme(legend.position = "none",
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.caption = element_text(hjust = 1, face = "italic")) +
    panel_border() +
    labs(y = NULL,
         x = "Days from nomination to result",
         color = "President\nParty",
         caption = "Data: Wikipedia, List of nominations to SCOTUS") + 
    # Add annotations
    geom_curve(data = data.frame(x = 250, xend = 292, y = 120, yend = 127),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 90, curvature = 0.2, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), alpha = 1, inherit.aes = FALSE) + 
    annotate(geom = "label", x = 121, y = 112, label = garlandLabel, 
             size = 6, hjust = 0, family = "Roboto Condensed")

# Create the titles
titleLabel <- "Senate Republicans have taken extreme measures\nto pack the SCOTUS with conservative justices"
title <- ggdraw() +
  draw_label(titleLabel, fontface = "bold", fontfamily = "Roboto Condensed", 
             x = 0, hjust = 0, size = 20) +
  theme(plot.margin = margin(2, 0, 0, 7))

# Create the legend
legend <- get_legend(daysTilResult +
    guides(color = guide_legend(nrow = 1)) +
    theme(legend.position = "top"))

# Combine into single chart
scotus_plot <- plot_grid(daysTilNextElection, daysTilResult,
                    labels = c('', ''), rel_widths = c(1.4, 1))
header <- plot_grid(title, legend, labels = c('', ''), rel_widths = c(2, 1))
scotus_plot <- plot_grid(header, scotus_plot, ncol = 1, 
                         rel_heights = c(0.05, 1))

ggsave(here::here('scotus', 'plots', 'scotus.pdf'),
       scotus_plot, width = 15, height = 20, device = cairo_pdf)
