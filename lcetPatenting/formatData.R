# Read in and format data
mainDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-45.xlsx')
chinaDfDataPath <- here::here('lcetPatenting', 'data', 'fig06-46.xlsx')
df <- read_excel(mainDfDataPath, skip = 3)
chinaDf <- read_excel(chinaDfDataPath, skip = 3) %>%
    select(-Year) 
df <- df %>% 
    bind_cols(chinaDf) %>% 
    mutate(
        Other = ROW - China, 
        year = as.numeric(Year)) %>% 
    select(-c(Taiwan, India, ROW, Year)) %>% 
    gather(country, numPatents, `United States`:Other) 
