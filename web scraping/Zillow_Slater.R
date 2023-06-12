library(rvest)
library(tidyverse)

#### Pulling recently SOLD houses ######
########################################

sold = "https://www.zillow.com/slater-ia/sold/?searchQueryState=%7B%22mapBounds%22%3A%7B%22north%22%3A41.930365556704984%2C%22east%22%3A-93.55027834838869%2C%22south%22%3A41.782563414617314%2C%22west%22%3A-93.76760165161134%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22rs%22%3A%7B%22value%22%3Atrue%7D%2C%22fsba%22%3A%7B%22value%22%3Afalse%7D%2C%22fsbo%22%3A%7B%22value%22%3Afalse%7D%2C%22nc%22%3A%7B%22value%22%3Afalse%7D%2C%22cmsn%22%3A%7B%22value%22%3Afalse%7D%2C%22auc%22%3A%7B%22value%22%3Afalse%7D%2C%22fore%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A12%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A20522%2C%22regionType%22%3A6%7D%5D%2C%22pagination%22%3A%7B%7D%7D"
ss = read_html(sold)

housesold <- read_html(sold) %>% html_elements("article")

# I don't understand why it is only pulling 9 addresses. The xpaths didn't change between sold and for sale
res_ss <- tibble(
      address= ss %>% html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>% html_text(),
      price = ss %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div/div/span') %>% html_text(),
      bedrooms = ss %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[1]/b') %>% 
        html_text(),
      bathrooms = ss %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[2]/b') %>% 
        html_text(),
      sqft = ss %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[3]/b') %>% 
        html_text()
    ) 

    
##### Pulling FOR SALE houses #####
######################################
sale = "https://www.zillow.com/slater-ia/?searchQueryState=%7B%22mapBounds%22%3A%7B%22north%22%3A41.930365556704984%2C%22east%22%3A-93.55027834838869%2C%22south%22%3A41.782563414617314%2C%22west%22%3A-93.76760165161134%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sche%22%3A%7B%22value%22%3Afalse%7D%2C%22schm%22%3A%7B%22value%22%3Afalse%7D%2C%22schh%22%3A%7B%22value%22%3Afalse%7D%2C%22schp%22%3A%7B%22value%22%3Afalse%7D%2C%22schr%22%3A%7B%22value%22%3Afalse%7D%2C%22schc%22%3A%7B%22value%22%3Afalse%7D%2C%22schu%22%3A%7B%22value%22%3Afalse%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A12%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A20522%2C%22regionType%22%3A6%7D%5D%2C%22pagination%22%3A%7B%7D%7D"
pg = read_html(sale)

# get list of houses for sale that appears on the page
# each property card is called an article when you inspect the webpage
housesale <- read_html(sale)%>%html_elements("article")

res_pg <- tibble(
  address= pg %>% html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div[1]/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>% html_text(),
  price = pg %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div/div/span') %>% html_text(),
  bedrooms = pg %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[1]/b') %>% 
    html_text(),
  bathrooms = pg %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[2]/b') %>% 
    html_text(),
  sqft = pg %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[3]/b') %>% 
    html_text()
) 

# combine recently SOLD and FOR SALE houses in one data frame
results <- res_pg %>% bind_rows(res_ss)

# export the data frame out as a csv or excel file

write.csv(results, "C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/web scraping/Week_Four_Zillow.csv", row.names = FALSE)
view(results)



###### Pulling IMAGES #######
#############################

# ss = houses that SOLD
# pg = houses that are FOR SALE

install.packages(c("readr", "magrittr", "xml2", "RSelenium"))
library(readr)
library(rvest)
library(magrittr)
library(xml2)
library(RSelenium)


pg_address <- pg %>%
  html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div[1]/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>%
  html_text()
print(pg_address)


# gathers image links. Similar method as above
pg_image_urls <- pg %>%
  html_nodes(xpath = '//*[@id="swipeable"]/div[1]/a/div/img') %>%
  html_attr("src")

print(pg_image_urls)

# this only downloaded 2 of 10 image urls
## changed something. try it again !!!
dir.create("images_slater_sale_addresses")
for (j in seq_along(pg_image_urls)) {
  p_address <- pg_address[j]
  file_name <- paste0("Z_S_", p_address, "_.png")
  file_path <- file.path("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/Web Scraping/images_slater_sale_addresses", file_name)
  download.file(pg_image_urls[j], file_path, mode = "wb")
  print(file_path)
}


ss_address <- ss %>% html_elements(xpath = "/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>% html_text()
print(ss_address)


ss_image_urls <- ss %>% html_nodes(xpath = "//article//img") %>% 
  html_attr("src")
print(ss_image_urls)


# WHAT WAS WRONG: YOU KEEP OVERWRITING YOUR ADDRESSES !!!!
## try it again !!!
for (j in seq_along(ss_image_urls)) {
  s_address <- ss_address[j]
  file_name <- paste0("Z_S_", s_address, "_.png")
  file_path <- file.path("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/Web Scraping/images_slater_sale_addresses", file_name)
  download.file(ss_image_urls[j], file_path, mode = "wb")
  print(file_path)
}
