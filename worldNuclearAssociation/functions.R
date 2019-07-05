# ----------------------------------------------------------------------------
# Functions

saveHtmlPage <- function(row, paths) {
    html <- read_html(row$url)
    write_xml(html, file = makeSavePath(row, paths))
}

makeSavePath <- function(row, paths) {
    return(paste(paths$pages, row$year, '-', row$month, '.html', sep=''))
}

parsePageData <- function(row) {
    htmlTree <- read_html(makeSavePath(row, paths))
    table <- html_table(htmlTree, fill=T, header=F)[[1]]
    # Pull out data rows
    table[,1] <- str_to_title(cleanText(table[,1]))
    headFootRows <- getHeadFootRows(table)
    df <- table[setdiff(seq(nrow(table)), headFootRows),]
    # Make header
    header <- makeHeader(table, headFootRows)
    colnames(df) <- header
    # Parse numbers from data table
    for (j in 2:ncol(df)) {df[,j] <- parse_number(df[,j])}
    df <- harmonizeColumns(df, row)
    return(df)
}

# Removes strange characters that can cause problems in file paths or urls
cleanText <- function(text) {
    return(text %>%
               str_replace_all('†', '') %>%
               str_replace_all('‡', '') %>%
               str_replace_all('[*]', '') %>%
               str_replace_all('\r\n\r\n\t\t\t', ' ') %>%
               str_replace_all('\r', '') %>%
               str_replace_all('\n', '') %>%
               str_replace_all('\t', '') %>%
               str_trim()
    )
}

getHeadFootRows <- function(table) {
    headFootRows <- which(
        (tolower(table[,1]) == '') |
        (str_detect(tolower(table[,1]), 'country')) |
        (str_detect(tolower(table[,1]), 'click')))
    return(headFootRows)
}

makeHeader <- function(table, headFootRows){
    headFoot <- table[headFootRows,]
    header <- str_to_title(cleanText(headFoot[1,]))
    units <- headFoot[2,]
    header <- paste(header, units) %>%
        str_replace('Nuclear Electricity', '') %>%
        str_replace('Reactors', '') %>%
        str_trim()
    header[1] <- 'Country'
    return(header)
}

harmonizeColumns <- function(df, row) {
    colnames(df) <- c(
        'country', 'generation_tot', 'generation_per', 'operable_n',
        'operable_mw', 'construction_n', 'construction_mw', 'planned_n',
        'planned_mw', 'proposed_n', 'proposed_mw', 'uranium_tonnes'
    )
    df$year <- row$year
    df$month <- row$month
    return(df)
}
