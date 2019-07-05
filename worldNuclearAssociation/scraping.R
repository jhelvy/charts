# Scraping data for nuclear power from http://www.world-nuclear.org

library(tidyverse)
library(here)
library(rvest)
source(here('functions.R'))

paths <- list(
    pages = paste(here('data', 'nuclear', 'pages'), '/', sep=''),
    urlsDf = here('data', 'nuclear', 'urlsDf.csv'),
    allDfs = here('data', 'nuclear', 'allDfs.csv'),
    nuclearDf = here('data', 'nuclear', 'nuclearDf.csv')
)

# ----------------------------------------------------------------------------
# Create df of urls and dates

startUrl <- 'http://www.world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx'
htmlTree <- read_html(startUrl)
nodes <- htmlTree %>% html_nodes('p')
links <- nodes[which(str_detect(html_text(nodes), 'Earlier tables'))] %>%
    html_nodes('a')
dates <- html_text(links)
urls <- html_attr(links, 'href')
for (i in 1:length(urls)) {
    if (! str_detect(urls[i], 'http://world-nuclear.org')) {
        urls[i] <- paste('http://www.world-nuclear.org', urls[i], sep='')
    }
}
urlsDf <- data.frame(
    date = c('June 2019', dates),
    url  = c(startUrl, urls)) %>%
    separate(date, c('monthName', 'year')) %>%
    left_join(data.frame(
        monthName = month.name,
        month = seq(12))) %>%
    select(year, month, url)
write_csv(urlsDf, paths$urlsDf)

# ----------------------------------------------------------------------------
# Save all the pages

urlsDf <- read_csv(paths$urlsDf)
for (i in 1:nrow(urlsDf)) {
    print(paste('saving', i))
    row = urlsDf[i,]
    saveHtmlPage(row, paths)
}

# ----------------------------------------------------------------------------
# Parse all the pages

urlsDf <- read_csv(paths$urlsDf)
allDfs <- list()
for (i in 1:nrow(urlsDf)) {
    print(i)
    row = urlsDf[i,]
    df <- parsePageData(row)
    allDfs[[i]] <- df
}
saveRDS(allDfs, paths$allDfs)

# Format into one data frame
allDfs <- readRDS(paths$allDfs)
nuclearDf <- do.call(rbind, allDfs)
write_csv(nuclearDf, paths$nuclearDf)
