# Load functions and libraries and formatted data
source('formatData.R')

# Compute mean non-Tesla monthly BEV sales
nonTeslaMean <- pevSales %>%
    filter(type == "Non-Tesla") %>%
    filter(category == "bev") %>%
    group_by(year, month) %>%
    summarise(sales = sum(sales))
nonTeslaMean <- round(mean(nonTeslaMean$sales), 2)

# Plot settings
plotColors <- c('#1ECBE1', '#1E6AE1', 'grey72')
mainFont <- 'Roboto Condensed'
titleLabel <- 'U.S. Monthly Sales of Battery Electric Vehicles, 2014 - 2020'
subtitleLabel <- 'With the exception of Tesla, combined monthly BEV sales by all other automakers has been flat for the past six years'
captionLabel <- "Data sources: hybridcars.com ('14-'17) & insideEVs.com ('18-'19)"
annLabel <- paste0('Six-year mean (non-Tesla):\n',
                   scales::comma(10^3*nonTeslaMean), ' BEV sales per month')

bevMonthlySales <- pevSales %>%
    filter(category == "bev") %>%
    ggplot() +
    geom_col(aes(x = date, y = sales, fill = type)) +
    geom_hline(yintercept = nonTeslaMean, col = "black", linetype = "dashed",
               size = 0.75) +
    scale_x_date(
        limits = ymd(c('2014-01-01', '2019-12-31')),
        date_breaks = '1 year',
        date_labels = "%Y") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
    scale_fill_viridis(discrete = TRUE) +
    theme_minimal_hgrid(font_family = mainFont) +
    theme(
        legend.position = c(1, 1.15),
        legend.background = element_rect(
            fill = 'white', color = 'white', size = 3),
        legend.justification = c("right", "top"),
        plot.title.position = 'plot') +
    labs(x       = NULL,
         y       = 'Sales (Thousands)',
         title   = titleLabel,
         subtitle = subtitleLabel,
         fill    = 'Vehicle Model',
         caption = "Data sources: hybridcars.com ('14-'17) & insideEVs.com ('18-'19)") +
    geom_curve(
        aes(x = ymd('2014-07-01'), xend = ymd('2014-11-01'), y = 13, yend = 3.7),
        size = 0.2, curvature = 0.1,
        arrow = arrow(length = unit(0.02, "npc"), type = "closed")) +
    geom_label(aes(x = ymd('2014-03-01'), y = 15), label = annLabel,
        hjust = 0, lineheight = 1, family = mainFont, size = 4.5)

# Save as PDF and PNG files
ggsave(here::here('plots', 'bevMonthlySales.pdf'), bevMonthlySales,
       width = 10, height = 5, device = cairo_pdf)

ggsave(here::here('plots', 'bevMonthlySales.png'), bevMonthlySales,
       width = 10, height = 5)
