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
source(here::here('scotus', 'formatData.R'))
plotColors <- c("blue", "red", "grey70")

# Create labels and compute metrics for labels
titleLabel <- "Nomination and Confirmation / Rejection of Every SCOTUS Justice"
subtitleLabel <- "Between 2016 and 2020, Senate Republicans took historically unprecedented and contradictory\nmeasures to confirm conservative justices on the Supreme Court."
barrettLabel <- "Senate Republicans rushed to confirm\nJudge Amy C. Barrett just 8 days before\nthe 2020 presidential election -- the closet\nconfirmation to an election in U.S. history"
# barrettLabel <- "Over 60 million Americans had already cast\ntheir ballot when Judge Amy C. Barrett was\nconfirmed -- the closet confirmation to a\npresidential election in U.S. history."
garlandLabel <- "In 2016, Senate Majority Leader\nMitch McConnell (R) blocked the\nconfirmation of Judge Merrick\nGarland by notoriously refusing\nto hold a vote on his nomination\nfor a record-breaking 293 days,\nclaiming it was unprecedented\nto confirm a justice during an\nelection year."
# garlandLabel <- 'In 2016, Senate Republicans\nblocked the confirmation of\nJudge Merrick Garland for a\nrecord-breaking 293 days,\nclaiming it was unprecedented\nto confirm a justice during\nan election year. Senate\nMajority Leader Mitch McConnell\nnotoriously withheld a floor vote\nto "give the people a voice" in\nfilling the vacancy left by the late\nJudge Antonin Scalia'
elecLineLabel <- "Judges nominated\nduring an election year"
threshold <- scotus %>%
  filter(nominatedInElectionYear == 1) %>%
  filter(daysNomTilNextElection == max(daysNomTilNextElection))
elecLine <- nrow(scotus) - which(scotus$nominee == threshold$nominee) + 0.5

# Create legend data frame
legend_df <- data.frame(
  daysNomTilNextElection = rep(600, 3),
  daysResTilNextElection = rep(300, 3),
  y = c(35, 30, 25),
  presidentParty = c("D", "R", "Other")
)

# Create main chart
scotus_dumbbell <- scotus %>%
  mutate(nominee = case_when(
    result == "rejected" ~ paste0(nominee, "  *"),
    result == "no action" ~ paste0(nominee, "  †"),
    TRUE ~ paste0(nominee, "   ")),
    nominee = fct_reorder(nominee, -daysNomTilNextElection)) %>%
  ggplot() +
  geom_blank(aes(x = 0 , xend = daysNomTilNextElection, y = nominee)) +
  geom_hline(yintercept = elecLine) +
  annotate(geom = "rect", xmin = -100, xmax = 1500,
           ymin = elecLine, ymax = nrow(scotus) + 0.5, fill = "#8C8C8C",
           alpha = 0.15) +
  geom_segment(aes(x = daysNomTilNextElection, xend = daysResTilNextElection,
                   y = nominee, yend = nominee, color = presidentParty),
               size = 1.5) +
  geom_vline(xintercept = 0) +
  geom_point(aes(x = daysNomTilNextElection, y = nominee,
                 color = presidentParty), fill = "white",
             pch = 21, size = 3.7) +
  geom_point(aes(x = daysResTilNextElection, y = nominee,
                 color = presidentParty, shape = result),
             size = 3.7, fill = 'white') +
  scale_x_reverse(labels = scales::comma,
                  position = "top",
                  expand = expansion(mult = c(0, 0)),
                  breaks = seq(1500, 0, -500), limits = c(1500, -100)) +
  scale_shape_manual(values = c(19, 21, 21)) +
  scale_color_manual(values = plotColors) +
  scale_fill_manual(values = plotColors) +
  theme_minimal_vgrid(font_size = 20, font_family = 'Roboto Condensed') +
  theme(axis.line.y = element_blank(), # Remove y axis line
        legend.position = "none",
        axis.text.y = element_text(size = 10, family = "Georgia"),
        plot.caption.position =  "plot",
        plot.caption = element_text(hjust = 0, size = 12, family = "Georgia"),
        plot.title.position =  "plot",
        plot.margin = margin(0.3, 0.5, 0.3, 0.5, "cm")) +
  panel_border() +
  labs(x = "Days until next presidential election\n",
       y = "Justice nominee",
       title = titleLabel,
       subtitle = subtitleLabel,
       caption = "*Rejected\n†No action") +
  # Add barrettLabel annotation
  geom_curve(data = data.frame(x = 500, xend = 60, y = 125, yend = 134),
             mapping = aes(x = x, y = y, xend = xend, yend = yend),
             angle = 90, curvature = -0.2, arrow = arrow(30, unit(0.1, "inches"),
                                                         "last", "closed"), inherit.aes = FALSE) +
  annotate(geom = "label", x = 970, y = 127, label = barrettLabel,
           size = 5.5, hjust = 0, family = "Roboto Condensed") +
  # Add garlandLabel annotation
  geom_curve(data = data.frame(x = 250, xend = 50, y = 90, yend = 127.5),
             mapping = aes(x = x, y = y, xend = xend, yend = yend),
             angle = 90, curvature = 0.15, alpha = 1, inherit.aes = FALSE,
             arrow = arrow(30, unit(0.1, "inches"), "last", "closed")) +
  annotate(geom = "label", x = 470, y = 93, label = garlandLabel,
           size = 5.5, hjust = 0, family = "Roboto Condensed") +
  # Add elecLine annotation
  annotate(geom = "text", x = 1380, y = elecLine + 2.5, label = elecLineLabel,
           hjust = 0, size = 5, family = "Roboto Condensed") +
  geom_segment(aes(x = 1400, y = elecLine, xend = 1400,
                   yend = elecLine + 6), arrow = arrow(length = unit(0.5, "cm"))) +
  # Add custom legend
  annotate(geom = "rect", xmin = 100, xmax = 700, ymin = 20, ymax = 40,
           fill = "white", color = "black") +
  geom_segment(data = legend_df,
               aes(x = daysNomTilNextElection, xend = daysResTilNextElection,
                   y = y, yend = y, color = presidentParty), size = 1.5)


ggsave(here::here('scotus', 'plots', 'scotus_dumbbell.pdf'),
       scotus_dumbbell, width = 14, height = 20, device = cairo_pdf)
# ggsave(here::here('scotus', 'plots', 'scotus.png'),
#        scotus_dumbbell, width = 13, height = 20, dpi = 300, type = "cairo")
