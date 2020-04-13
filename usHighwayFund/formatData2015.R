library(tidyverse)

# Import data
data <- read_csv(file.path('usHighwayFund', 'data', 'rawData2015.csv')) %>%
    filter(year >= 1980)

# Format the data, which is in real dollars
plotData <- data %>%
    group_by(year) %>%
    # Summarize the data by revenue type, merging together highway and transit
    # accounts. Convert result to $ billions
    summarise(fuelRev=sum(gasoline, gasohol, diesel)/10^6,
              nonFuelRev=sum(tires, innerTubes, treadRubber,
              trucksBusesTrailers, use, lubricatingOil, partsAccessories,
              misc)/10^6,
              expenditures=sum(expenditures)/10^6,
              transfers=sum(netTransfers)/10^6,
              closingBalance=sum(closingBalance)/10^6) %>%
    select(year, fuelRev, nonFuelRev, transfers, expenditures, closingBalance)

# Save formatted data for plotting
write_csv(plotData, file.path('usHighwayFund', 'data', 'plotData2015.csv'))
