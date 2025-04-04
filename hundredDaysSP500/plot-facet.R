# Load required libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(quantmod)
library(scales)

# Define presidential inauguration dates going back to S&P 500 start (1957)
inaugurations <- data.frame(
    president = c(
        "Eisenhower (1957)", "Kennedy (1961)", "Johnson (1963)", "Nixon (1969)", 
        "Nixon (1973)", "Ford (1974)", "Carter (1977)", "Reagan (1981)",
        "Reagan (1985)", "Bush Sr. (1989)", "Clinton (1993)", "Clinton (1997)",
        "Bush Jr. (2001)", "Bush Jr. (2005)", "Obama (2009)", "Obama (2013)",
        "Trump (2017)", "Biden (2021)", "Trump (2025)"
    ),
    start_date = as.Date(c(
        "1957-01-20", "1961-01-20", "1963-11-22", "1969-01-20",
        "1973-01-20", "1974-08-09", "1977-01-20", "1981-01-20",
        "1985-01-20", "1989-01-20", "1993-01-20", "1997-01-20",
        "2001-01-20", "2005-01-20", "2009-01-20", "2013-01-20",
        "2017-01-20", "2021-01-20", "2025-01-20"
    )),
    party = c(
        "Republican", "Democratic", "Democratic", "Republican",
        "Republican", "Republican", "Democratic", "Republican",
        "Republican", "Republican", "Democratic", "Democratic",
        "Republican", "Republican", "Democratic", "Democratic",
        "Republican", "Democratic", "Republican"
    )
)

# Calculate end dates (either 100 days after inauguration or current date for the last president)
inaugurations <- inaugurations %>%
    mutate(end_date = pmin(start_date + days(100), today()))

# Function to get S&P 500 data for a president
get_sp500_data <- function(president_row) {
    president_name <- president_row$president
    party <- president_row$party
    from_date <- president_row$start_date - days(5)  # Get data from a few days before inauguration
    to_date <- president_row$end_date + days(5)      # Get data until a few days after 100 days or current date
    
    cat(paste("Fetching data for", president_name, "from", from_date, "to", to_date, "\n"))
    
    # Handle potential errors during data retrieval
    tryCatch({
        # Download S&P 500 data using quantmod
        getSymbols("^GSPC", from = from_date, to = to_date, src = "yahoo")
        
        # Convert xts object to data frame
        sp500_df <- data.frame(
            date = index(GSPC),
            value = as.numeric(GSPC$GSPC.Adjusted),
            stringsAsFactors = FALSE
        )
        
        # Find the closest trading day to inauguration
        closest_inaug_date <- sp500_df %>%
            filter(date >= president_row$start_date) %>%
            arrange(date) %>%
            slice(1) %>%
            pull(date)
        
        # Calculate days since inauguration
        sp500_df <- sp500_df %>%
            filter(date >= closest_inaug_date) %>%
            mutate(
                president = president_name,
                party = party,
                day = as.numeric(difftime(date, closest_inaug_date, units = "days")),
                reference_value = first(value),
                percent_change = (value / first(value) - 1) * 100
            ) %>%
            filter(day <= 100)  # Limit to first 100 days
        
        return(sp500_df)
    }, error = function(e) {
        cat(paste("Error fetching data for", president_name, ":", e$message, "\n"))
        return(NULL)
    })
}

# Get data for each president
all_data <- data.frame()

for (i in 1:nrow(inaugurations)) {
    president_data <- get_sp500_data(inaugurations[i,])
    if (!is.null(president_data)) {
        all_data <- rbind(all_data, president_data)
    }
}

# Prepare data for plotting
# Convert president to a factor with chronological order
all_data$president <- factor(all_data$president, 
                             levels = c(
                                 "Eisenhower (1957)", "Kennedy (1961)", "Johnson (1963)", "Nixon (1969)", 
                                 "Nixon (1973)", "Ford (1974)", "Carter (1977)", "Reagan (1981)",
                                 "Reagan (1985)", "Bush Sr. (1989)", "Clinton (1993)", "Clinton (1997)",
                                 "Bush Jr. (2001)", "Bush Jr. (2005)", "Obama (2009)", "Obama (2013)",
                                 "Trump (2017)", "Biden (2021)", "Trump (2025)"
                             ))

# Create a complete dataset with all presidents' data for each facet
facet_data <- all_data %>%
    # Create a complete president list for each day
    group_by(day) %>%
    # Add a column to identify which president is the "current" one in each facet
    mutate(is_current_president = TRUE)

# Create a background dataset with all lines for each facet
background_data <- all_data %>%
    select(president, party, day, percent_change) %>%
    tidyr::crossing(facet_president = factor(unique(all_data$president), 
                                             levels = levels(all_data$president))) %>%
    mutate(is_current_president = (president == facet_president))

# Create the faceted plot
ggplot() +
    # Background gray lines for all other presidents
    geom_line(data = background_data %>% filter(!is_current_president),
              aes(x = day, y = percent_change, group = president),
              color = "gray80", size = 0.5, alpha = 0.6) +
    # Highlighted line for the current president in the facet
    geom_line(data = background_data %>% filter(is_current_president),
              aes(x = day, y = percent_change, color = party),
              size = 1.2) +
    geom_point(data = background_data %>% filter(is_current_president) %>%
                   group_by(facet_president) %>%
                   filter(day == max(day)),
               aes(x = day, y = percent_change, color = party),
               size = 3) +
    # Add value labels at the end of the current president's line
    geom_text(
        data = background_data %>% 
            filter(is_current_president) %>%
            group_by(facet_president) %>%
            filter(day == max(day)),
        aes(
            x = day, y = percent_change, 
            label = paste0(round(percent_change, 1), "%")
        ),
        hjust = -0.3, vjust = 0.5, size = 3
    ) +
    # Zero reference line
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    # Facet by president
    facet_wrap(~ facet_president, ncol = 4) +
    # Use political party colors
    scale_color_manual(values = c("Democratic" = "blue", "Republican" = "red")) +
    # Formatting
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    scale_x_continuous(breaks = seq(0, 100, by = 25)) +
    # Add extra space on the right for labels
    coord_cartesian(xlim = c(0, 115)) +
    labs(
        title = "S&P 500 Performance During First 100 Days in Office by President",
        subtitle = "Each panel shows one president (colored) against all others (gray)",
        x = "Days Since Inauguration",
        y = "Percent Change (%)",
        caption = "Data source: Yahoo Finance via {quantmod} R package"
    ) +
    theme_minimal() +
    theme(
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank(),
        legend.position = "none",
        strip.text = element_text(face = "bold"),
        panel.spacing = unit(1, "lines"), 
        panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA)
    )

# Save the plot with appropriate dimensions for the faceted design
ggsave(
    'faceted_presidential_sp500.png', width = 12, height = 10
)

# Print summary statistics
cat("\nSummary of S&P 500 performance in first 100 days:\n")
all_data %>%
    group_by(president, party) %>%
    summarize(
        days_available = max(day),
        start_value = first(value),
        end_value = last(value),
        percent_change = last(percent_change),
        .groups = "drop"
    ) %>%
    arrange(desc(percent_change)) %>%
    print()
        