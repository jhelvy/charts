library(dplyr)
library(here)

# Formatting clean energy investment plot data

# Read in data
path <- here::here('scienceCommentary2019', 'data', 'newEnergyInvestment.csv')
investmentDf <- read_csv(path)

# Create country summary data
countrySummaryDf <- investmentDf %>%
    group_by(year, country) %>%
    summarise(investment = sum(investment))

# Save formatted data
write_csv(countrySummaryDf, here::here(
    'scienceCommentary2019', 'data', 'countryEnergyInvestment.csv'))