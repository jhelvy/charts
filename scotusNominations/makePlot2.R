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
source(here::here("scotus", "formatData2.R"))
plotColors <- c("blue", "red", "grey70")
annFont <- "Roboto Condensed"
annColor <- "grey33"
annFace <- "italic"

# Create labels and compute metrics for labels
titleLabel <- "Time from Nomination to Result of Every US Supreme Court Justice"
subtitleLabel <- "Only 15 justice nominations have occured during an election year; during the two most recent (2016 & 2020), Senate Republicans\nused unprecedented measures (with contradicting justifications) to confirm more conservative justices to the court."
captionLabel <- paste0("*Rejected", str_dup(" ", 221), "Data from Wikipedia, List of nominations to SCOTUS\n", "†Declined", str_dup(" ", 263), "Chart by John Paul Helveston\n", "‡No Action\n", "CJ = Chief Justice")
barrettLabel <- "Senate Republicans rushed to confirm\nJudge Amy C. Barrett just 7 days before\nthe 2020 presidential election -- the closet\nconfirmation to an election in U.S. history.\nOver 60 million Americans had already\nvoted by the day of her confirmation."
garlandLabel <- 'In 2016, Senate Majority Leader\nMitch McConnell (R) blocked the\nconfirmation of Obama-nominated\nJudge Merrick Garland by\nrefusing to hold a confirmation\nvote for a record-breaking\n293 days to, “Let the American\npeople decide” who should\nfill the seat left by the late\nJustice Antonin Scalia.'
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
    color = presidentParty, shape = result
  ),
  size = 3.7, fill = "white", show.legend = FALSE
  ) +
  scale_x_reverse(
    labels = scales::comma,
    position = "top",
    expand = expansion(mult = c(0, 0)),
    breaks = seq(1500, 0, -500), limits = c(1500, -100)
  ) +
  scale_shape_manual(values = c(19, 21, 21, 21), guide = FALSE) +
  scale_color_manual(values = plotColors) +
  scale_fill_manual(values = plotColors, guide = FALSE) +
  theme_minimal_vgrid(font_size = 20, font_family = "Roboto Condensed") +
  theme(
    axis.line.y = element_blank(), # Remove y axis line
    legend.position = c(0.626, 0.044),
    legend.background = element_rect(
      fill = "white", color = "black", size = 0.2
    ),
    legend.margin = margin(6, 6, 6, 6),
    axis.text.y = element_text(size = 10, family = "Georgia"),
    plot.caption.position = "plot",
    plot.caption = element_text(
      hjust = 0, size = 12, family = "Georgia", face = "italic"
    ),
    plot.title.position = "plot",
    plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")
  ) +
  panel_border() +
  labs(
    x = "Days until the next presidential election\n",
    y = "Justice nominee",
    color = "Party of nominating president",
    title = titleLabel,
    subtitle = subtitleLabel,
    caption = captionLabel
  ) +
  # Add barrettLabel annotation
  geom_curve(
    data = data.frame(x = 500, xend = 60, y = 133, yend = 140),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    angle = 90, curvature = -0.17, arrow = arrow(
      30, unit(0.1, "inches"),
      "last", "closed"
    ), inherit.aes = FALSE
  ) +
  annotate(
    geom = "label", x = 970, y = 129, label = barrettLabel,
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
    geom = "label", x = 470, y = 93, label = garlandLabel,
    size = 5.5, hjust = 0, family = "Roboto Condensed", color = annColor,
    fontface = annFace
  ) +
  # Add inauguralLabel annotation
  geom_segment(
    data = data.frame(
      x    = c(1110, 1110, 1075, 1075),
      xend = c(1075, 1075, 1075, 800),
      y    = c(40.3, 35.5, 35.5, 37.5),
      yend = c(40.3, 35.5, 40.3, 37.5)
    ),
    aes(x = x, xend = xend, y = y, yend = yend)
  ) +
  annotate(
    geom = "label", x = 900, y = 37, label = inauguralLabel,
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

ggsave(here::here("scotus", "plots", "scotus_nominations.pdf"),
  scotus_nominations,
  width = 14, height = 20, device = cairo_pdf
)
ggsave(here::here('scotus', 'plots', 'scotus_nominations.png'),
       scotus_nominations, width = 14, height = 20, dpi = 300, type = "cairo")
