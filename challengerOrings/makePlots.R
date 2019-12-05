# Author: John Paul Helveston
# Date: First written on Thursday, December 5, 2019
#
# To generate the plots in the "plots" folder, go back and follow the
# instructions in the "README.md" file in the parent directory.
#
# Description:
# Scatterplot of rocket o-ring damage vs. launch temperature
# Designed to replicate original figure in Tufte (1997)
#
# Original figure in:
# Tufte, E. R. 1997. Visual Explanations. Graphics Press, Cheshire, Connecticut, U.S.A.

library(ggplot2)
library(here)
library(DAAG)

annotation <- paste("26°-29°:", "Range of forecasted temperatures", 
                    "for Jan. 28, 1986 Challenger launch", sep = "\n")
challengerOrings <- ggplot(orings, aes(x=Temperature, y=Total)) +
    geom_point(size = 1.5) +
    scale_x_continuous(limits = c(25, 85), breaks = seq(25, 85, 5)) +
    scale_y_continuous(limits = c(-0.15, 8), breaks = seq(0, 8, 2)) +
    annotate("rect", xmin = 26, xmax = 29,  ymin=-0.15, ymax=0.15,
             alpha = 0.6, fill = "grey60") +
    annotate("text", x = 26, y = 1.4, label = annotation, hjust = 0) +
    labs(x = 'Temperature (°F) of field joints at time of launch', 
         y = 'Total o-ring damage') +
    theme_bw() +
    theme(panel.grid.minor = element_blank()) 
    

# Save using laptop screen aspect ratio (2560 X 1600)
ggsave(here::here('challengerOrings', 'plots', 'challengerOrings.pdf'),
       challengerOrings, width=8, height=3, dpi=150)
ggsave(here::here('challengerOrings', 'plots', 'challengerOrings.png'),
       challengerOrings, width=8, height=3, dpi=150)
