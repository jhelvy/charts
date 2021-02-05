# Author: John Paul Helveston
# First written on Friday, October 30, 2020
# Last updated on Friday, October 30, 2020
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Dumbbell chart of SCOTUS nominees

library(tidyverse)
library(lubridate)
library(cowplot)
options(dplyr.width = Inf)

# Load data
source("formatData2.R")
plotColors <- c("blue", "red", "grey70")
annFont <- "Fira Sans Condensed"
annColor <- "grey33"
annFace <- "italic"

# Create labels and compute metrics for labels
titleLabel <- "Time from Nomination to Result of Every US Supreme Court Justice"
subtitleLabel <- "Only 15 justice nominations have occured during an election year; during the two most recent (2016 & 2020), Senate Republicans\nused unprecedented measures (with contradicting justifications) to confirm more conservative justices to the court."
captionLabel <- paste0("*Rejected", str_dup(" ", 222), "Data from Wikipedia, List of nominations to SCOTUS\n", "†Declined", str_dup(" ", 263), "Chart by John Paul Helveston\n", "‡No Action\n", "CJ = Chief Justice")
barrettLabel <- "Senate Republicans rushed to confirm\nJudge Amy C. Barrett just 7 days before\nthe 2020 presidential election -- the closest\nconfirmation to an election in U.S. history.\nOver 60 million Americans had already\nvoted by the day of her confirmation."
garlandLabel <- 'In 2016, Senate Majority Leader\nMitch McConnell (R) blocked the\nconfirmation of Obama-nominated\nJudge Merrick Garland by refusing\nto hold a confirmation vote for a\nrecord-breaking 293 days to,\n“Let the American people decide”\nwho should fill the seat left by\nthe late Justice Antonin Scalia.'
inauguralLabel <- "The first five inaugural justices were\nnominated on September 24, 1789\nby President George Washington."
# Election year line & label
elecLineLabel <- "Judges nominated\nduring an election year"
threshold <- scotus %>%
  filter(nominatedInElectionYear == 1) %>%
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
elecLine <- nrow(scotus) - which(scotus$nominee == threshold$nominee) + 0.5

# Create main chart
scotus_nominations <- ggplot(scotus) +
  geom_blank(aes(x = 0, xend = daysNomTilNextElection, y = nominee)) +
  geom_hline(yintercept = elecLine) +
  annotate(
    geom = "rect", xmin = -100, xmax = 1500,
    ymin = elecLine, ymax = nrow(scotus) + 0.5, fill = "#8C8C8C",
    alpha = 0.15
  ) +
  geom_segment(aes(
    x = daysNomTilNextElection, xend = daysResTilNextElection,
    y = nominee, yend = nominee, color = presidentParty
  ),
  size = 1.5
  ) +
  geom_vline(xintercept = 0) +
  geom_point(aes(
    x = daysNomTilNextElection, y = nominee,
    color = presidentParty
  ),
  fill = "white",
  pch = 21, size = 3.7, show.legend = FALSE
  ) +
  geom_point(aes(
    x = daysResTilNextElection, y = nominee,
    color = presidentParty, shape = result),
    size = 3.7, fill = "white", show.legend = FALSE) +
  scale_x_reverse(
    labels = scales::comma,
    position = "top",
    expand = expansion(mult = c(0, 0)),
    breaks = seq(1500, 0, -500), limits = c(1500, -100)
  ) +
  scale_shape_manual(values = c(19, 21, 21, 21), guide = FALSE) +
  scale_color_manual(values = plotColors) +
  scale_fill_manual(values = plotColors, guide = FALSE) +
  theme_minimal_vgrid(font_size = 20, font_family = "Fira Sans Condensed") +
  theme(
    axis.line.y = element_blank(), # Remove y axis line
    legend.position = c(0.64, 0.037),
    legend.background = element_rect(
      fill = "white", color = "black", size = 0.2
    ),
    legend.margin = margin(6, 8, 8, 6),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    plot.caption.position = "plot",
    plot.caption = element_text(
      hjust = 0, size = 12, family = "Fira Sans Condensed", face = "italic"
    ),
    plot.title.position = "plot",
    plot.margin = margin(0.3, 0.5, 0.3, 2.5, "cm")
  ) +
  geom_text(aes(x = daysNomTilNextElection + 15, y = nominee, label = nominee),
            hjust = 1, nudge_y = 0.1, family = "Fira Sans Condensed ExtraLight") +
  coord_cartesian(clip = "off") +
  labs(
    x = "Days until the next presidential election\n",
    y = NULL,
    color = "Party of nominating president",
    title = titleLabel,
    subtitle = subtitleLabel,
    caption = captionLabel
  ) +
  # Add barrettLabel annotation
  geom_curve(
    data = data.frame(x = 550, xend = 200, y = 135, yend = 140),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = -0.17, arrow = arrow(
      30, unit(0.1, "inches"),
      "last", "closed"
    ), inherit.aes = FALSE
  ) +
  annotate(
    geom = "label", x = 993, y = 133, label = barrettLabel,
    size = 5.5, hjust = 0, family = annFont, color = annColor,
    fontface = annFace
  ) +
  # Add garlandLabel annotation
  geom_curve(
    data = data.frame(x = 250, xend = 50, y = 96, yend = 133.5),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = 0.15, alpha = 1, inherit.aes = FALSE,
    arrow = arrow(30, unit(0.1, "inches"), "last", "closed")
  ) +
  annotate(
    geom = "label", x = 450, y = 95, label = garlandLabel,
    size = 5.5, hjust = 0, family = annFont, color = annColor,
    fontface = annFace
  ) +
  # Add inauguralLabel annotation
  geom_segment(
    data = data.frame(
      x    = c(1110, 1110, 1075, 1075),
      xend = c(1075, 1075, 1075, 800),
      y    = c(40.3, 35.5, 35.5, 37.9),
      yend = c(40.3, 35.5, 40.3, 37.9)
    ),
    aes(x = x, xend = xend, y = y, yend = yend)
  ) +
  annotate(
    geom = "label", x = 900, y = 37.9, label = inauguralLabel,
    size = 5.5, hjust = 0, family = annFont, color = annColor,
    fontface = annFace
  ) +
  # Add elecLine annotation
  annotate(
    geom = "text", x = 1380, y = elecLine + 2.5, label = elecLineLabel,
    hjust = 0, size = 5, family = annFont, fontface = annFace, color = annColor
  ) +
  geom_segment(aes(
    x = 1400, y = elecLine, xend = 1400,
    yend = elecLine + 6
  ), color = annColor, arrow = arrow(length = unit(0.5, "cm")))

ggsave(here::here("plots", "scotus_nominations_3.pdf"),
  scotus_nominations, width = 14, height = 24, device = cairo_pdf)
ggsave(here::here("plots", "scotus_nominations_3.png"),
  scotus_nominations, width = 14, height = 24, dpi = 300)
