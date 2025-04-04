# Load required libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(quantmod)
library(scales)
library(ggrepel)

# Define presidential election dates (one day before election)
elections <- data.frame(
    president = c("Obama (2013)", "Trump (2017)", "Biden (2021)", "Trump (2025)"),
    election_date = as.Date(c("2012-11-05", "2016-11-07", "2020-11-02", "2024-11-04")),
    end_date = as.Date(c("2013-04-30", "2017-04-30", "2021-04-30", "2025-04-04"))  # Current date for Trump 2025
)

# Function to get S&P 500 data for a president
get_sp500_data <- function(president_row) {
    president_name <- president_row$president
    from_date <- president_row$election_date - days(5)  # Get data from a few days before election
    to_date <- president_row$end_date + days(5)      # Get data until end date
    
    cat(paste("Fetching data for", president_name, "from", from_date, "to", to_date, "\n"))
    
    # Download S&P 500 data using quantmod
    getSymbols("^GSPC", from = from_date, to = to_date, src = "yahoo")
    
    # Convert xts object to data frame
    sp500_df <- data.frame(
        date = index(GSPC),
        value = as.numeric(GSPC$GSPC.Adjusted),
        stringsAsFactors = FALSE
    )
    
    # Find the closest trading day to election
    closest_election_date <- sp500_df %>%
        filter(date >= president_row$election_date) %>%
        arrange(date) %>%
        slice(1) %>%
        pull(date)
    
    # Calculate days since election
    sp500_df <- sp500_df %>%
        filter(date >= closest_election_date) %>%
        mutate(
            president = president_name,
            day = as.numeric(difftime(date, closest_election_date, units = "days")),
            reference_value = first(value),
            percent_change = (value / first(value) - 1) * 100
        )
    return(sp500_df)
}

# Get data for each president
all_data <- data.frame()

for (i in 1:nrow(elections)) {
    president_data <- get_sp500_data(elections[i,])
    all_data <- rbind(all_data, president_data)
}

# Calculate the max days for Trump 2025 (current)
max_days <- all_data %>%
    filter(president == "Trump (2025)") %>%
    pull(day) %>%
    max()

# Create the plot
ggplot(all_data, aes(x = day, y = percent_change, color = president, group = president)) +
    geom_line(size = 1) +
    geom_point(size = 2, alpha = 0.6) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    # Direct labels at the end of lines instead of a legend
    geom_text_repel(
        data = all_data %>% 
            group_by(president) %>% 
            filter(day == max(day)),
        aes(label = president), 
        hjust = -0.5, 
        vjust = 0,
        size = 4,
        fontface = "bold", 
        family = 'Roboto Condensed',
        direction = 'y'
    ) +
    # Values at the end of lines
    geom_text_repel(
        data = all_data %>% 
            group_by(president) %>% 
            filter(day == max(day)),
        aes(label = paste0(round(percent_change, 2), "%")), 
        hjust = -0.5, 
        vjust = 1.3,
        size = 4, 
        family = 'Roboto Condensed', 
        direction = 'y'
    ) +
    labs(
        title = "S&P 500 Performance Since Election",
        subtitle = "Normalized to One Day Before Election (0% = S&P 500 value on day 0)",
        x = "Days Since Election",
        y = "Percent Change (%)", 
        caption = "Data source: Yahoo Finance via {quantmod} R package\nSource at https://github.com/jhelvy/charts"
    ) +
    scale_color_manual(values = c("Obama (2013)" = "blue", "Trump (2017)" = "darkred", "Biden (2021)" = "darkblue", "Trump (2025)" = "red")) +
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    scale_x_continuous(breaks = seq(0, max_days + 30, by = 30)) +
    # Add extra space on the right for labels
    coord_cartesian(xlim = c(0, max_days + 60)) +
    theme_minimal(base_family = 'Roboto Condensed') +
    theme(
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank(),
        # Remove the legend
        legend.position = "none", 
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA)
    )

ggsave(
    here::here('plots', 'electionToNowSP500.png'), 
    width = 10, height = 6
)

# Print summary statistics
cat("\nSummary of S&P 500 performance since election:\n")
all_data %>%
    group_by(president) %>%
    summarize(
        start_value = first(value),
        latest_value = last(value),
        percent_change = last(percent_change),
        days_tracked = max(day)
    ) %>%
    arrange(desc(percent_change)) %>%
    print()