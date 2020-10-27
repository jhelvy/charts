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
plotColors <- c("blue", "red", "grey70")

# Create labels and compute metrics for labels
titleLabel <- "Senate Republicans have taken unprecedented measures\nto pack the SCOTUS with conservative justices"
barrettLabel <- "In 2020, Senate Republicans rushed\nto confirm Judge Amy C. Barrett just\n7 days before the 2020 presidential\nelection, even as more than 60 million\nAmericans had already cast their ballot"
garlandLabel <- 'In 2016, Senate Republicans\nblocked the confirmation of\nJudge Merrick Garland for a\nrecord-breaking 293 days,\nclaiming it was unprecedented\nto confirm a justice during\nan election year. Senate\nMajority Leader Mitch McConnell\nnotoriously withheld a floor vote\nto "give the people a voice" in\nfilling the vacancy left by the late\nJudge Antonin Scalia'
elecLineLabel <- "Judges nominated\nduring an election year"
threshold <- scotus %>%
  filter(nominatedInElectionYear == 1) %>%
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
elecLine <- nrow(scotus) - which(scotus$nominee == threshold$nominee) + 0.5

# Create left chart: Days from nomination to next election
daysTilNextElection <- ggplot(scotus) +
    geom_blank(aes(x = 0 , xend = daysNomTilNextElection, y = nominee)) +
    geom_hline(yintercept = elecLine) +
    annotate(geom = "rect", xmin = 0, xmax = 1500,
             ymin = elecLine, ymax = nrow(scotus) + 0.5, fill = "#8C8C8C",
             alpha = 0.15) +
    geom_segment(aes(x = 0 , xend = daysNomTilNextElection,
                     y = nominee, yend = nominee), color = "grey") +
    geom_point(aes(x = daysNomTilNextElection, y = nominee,
                   fill = presidentParty), color = "white",
               pch=21, size = 3.7) +
    scale_x_continuous(expand = expansion(mult = c(0, 0)),
                       labels = scales::comma, position = "top",
                       breaks = seq(0, 1500, 500), limits = c(0, 1500)) +
    scale_fill_manual(values = plotColors) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Roboto Condensed') +
    theme(legend.position = "none",
          axis.text.y = element_text(size = 10, family = "Georgia"),
          plot.caption = element_text(hjust = 0, face = "italic", size = 12,
                                      family = "Georgia"),
          plot.caption.position =  "plot",
          plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")) +
    panel_border() +
    labs(x = "Days from nomination to next election\n",
         y = "Justice nominee",
         caption = "*Nomination rejected\n") +
    # Add annotations
    geom_curve(data = data.frame(x = 700, xend = 60, y = 115, yend = 134),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 90, curvature = 0.5, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), inherit.aes = FALSE) +
    annotate(geom = "label", x = 550, y = 112, label = barrettLabel,
             size = 5.5, hjust = 0, family = "Roboto Condensed") +
    annotate(geom = "text", x = 1020, y = elecLine + 2.5, label = elecLineLabel, 
             hjust = 0, size = 5, family = "Roboto Condensed") +
    geom_segment(aes(x = 1000, y = elecLine, xend = 1000, 
                     yend = elecLine + 6), arrow = arrow(
                       length = unit(0.5, "cm")))

# Create right chart: Days from nomination to result
daysTilResult <- ggplot(scotus) +
    geom_blank(aes(x = 0 , xend = daysUntilResult, y = nominee)) +
    geom_hline(yintercept = elecLine) +
    annotate(geom = "rect", xmin = 0, xmax = 300,
             ymin = elecLine, ymax = nrow(scotus) + 0.5, fill = "#8C8C8C",
             alpha = 0.15) +
    geom_segment(aes(x = 0 , xend = daysUntilResult,
                     y = nominee, yend = nominee), color = "grey") +
    geom_point(aes(x = daysUntilResult, y = nominee,
                   fill = presidentParty), color = "white",
               pch=21, size = 3.7) +
    geom_hline(yintercept = elecLine) +
    scale_x_continuous(expand = expansion(mult = c(0, 0)),
                       labels = scales::comma, position = "top",
                       breaks = seq(0, 300, 100), limits = c(0, 300)) +
    scale_fill_manual(values = plotColors) +
    theme_minimal_vgrid(font_size = 20, font_family = 'Roboto Condensed') +
    theme(legend.position = "none",
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.caption = element_text(hjust = 1, face = "italic", 
                                      size = 12, family = "Georgia"),
          plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")) +
    panel_border() +
    labs(y = NULL,
         x = "Days from nomination to result\n",
         fill = "President Party:",
         caption = "Data from Wikipedia, List of nominations to SCOTUS\nChart by John Paul Helveston") +
    # Add annotations
    geom_curve(data = data.frame(x = 250, xend = 292, y = 115, yend = 127),
      mapping = aes(x = x, y = y, xend = xend, yend = yend),
      angle = 90, curvature = 0.2, arrow = arrow(30, unit(0.1, "inches"),
      "last", "closed"), alpha = 1, inherit.aes = FALSE) +
    annotate(geom = "label", x = 134, y = 103.5, label = garlandLabel,
             size = 5.5, hjust = 0, family = "Roboto Condensed")
    
# Create the title & legend
title <- ggdraw() +
  draw_label(titleLabel, fontface = "bold", fontfamily = "Roboto Condensed",
             x = 0, hjust = 0, size = 22) + 
  theme(plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm"))
legend <- get_legend(
  daysTilResult +
    guides(color = guide_legend(nrow = 1)) +
    theme(legend.position = "top",
          legend.margin = margin(6, 6, 6, 6),
          legend.justification = "right", 
          legend.spacing.x = unit(0.1, 'cm'), 
          legend.title.align = 1))
      
# Combine into single chart
scotus_plot <- plot_grid(daysTilNextElection, daysTilResult,
                    labels = c('', ''), rel_widths = c(1.35, 1))
header <- plot_grid(title, legend,
                    labels = c('', ''), rel_widths = c(1, 1))
scotus_plot <- plot_grid(header, scotus_plot, ncol = 1,
                         rel_heights = c(0.05, 1))

ggsave(here::here('scotus', 'plots', 'scotus.pdf'),
       scotus_plot, width = 15, height = 20, device = cairo_pdf)
ggsave(here::here('scotus', 'plots', 'scotus.png'),
       scotus_plot, width = 15, height = 20, dpi = 300, type = "cairo")
