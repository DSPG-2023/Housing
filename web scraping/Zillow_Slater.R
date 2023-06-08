library(rvest)
library(tidyverse)

#####trying Zillow for Slater, IA#####
######################################
url = "https://www.zillow.com/slater-ia/?searchQueryState=%7B%22mapBounds%22%3A%7B%22north%22%3A41.930365556704984%2C%22east%22%3A-93.55027834838869%2C%22south%22%3A41.782563414617314%2C%22west%22%3A-93.76760165161134%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sche%22%3A%7B%22value%22%3Afalse%7D%2C%22schm%22%3A%7B%22value%22%3Afalse%7D%2C%22schh%22%3A%7B%22value%22%3Afalse%7D%2C%22schp%22%3A%7B%22value%22%3Afalse%7D%2C%22schr%22%3A%7B%22value%22%3Afalse%7D%2C%22schc%22%3A%7B%22value%22%3Afalse%7D%2C%22schu%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A12%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A20522%2C%22regionType%22%3A6%7D%5D%2C%22pagination%22%3A%7B%7D%7D"
url2 = "https://www.zillow.com/slater-ia/?searchQueryState=%7B%22mapBounds%22%3A%7B%22north%22%3A41.930365556704984%2C%22east%22%3A-93.55027834838869%2C%22south%22%3A41.782563414617314%2C%22west%22%3A-93.76760165161134%7D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sche%22%3A%7B%22value%22%3Afalse%7D%2C%22schm%22%3A%7B%22value%22%3Afalse%7D%2C%22schh%22%3A%7B%22value%22%3Afalse%7D%2C%22schp%22%3A%7B%22value%22%3Afalse%7D%2C%22schr%22%3A%7B%22value%22%3Afalse%7D%2C%22schc%22%3A%7B%22value%22%3Afalse%7D%2C%22schu%22%3A%7B%22value%22%3Afalse%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A12%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A20522%2C%22regionType%22%3A6%7D%5D%2C%22pagination%22%3A%7B%7D%7D"
pg = read_html(url2)

# get list of houses for sale that appears on the page
# each property card is called an article when you inspect the webpage
houselist <- read_html(url2)%>%html_elements("article")

# pulls the image urls
image_urls <- pg %>%
  html_nodes(xpath = '//*[@id="swipeable"]/div[1]/a/div/img') %>%
  html_attr("src")



# pulls house address
address <- pg %>% html_elements(xpath = "/html/body/div[1]/div[5]/div/div/div[1]/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>% html_text()
# pulls price for all houses on page
price <- pg %>% html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div/div/span') %>% html_text()
# pulls number of bedrooms
bedrooms <- pg %>% html_elements(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[1]/b') %>% html_text()
#pulls number of bathrooms
bathrooms <- pg %>% html_elements(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[2]/b') %>% html_text()
# pulls square footage of house
sqft <- pg %>% html_elements(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/div[3]/ul/li[3]/b') %>% html_text()


#puts the address, price, bedrooms, bathrooms, and square footage in a data frame
res_pg <- tibble(address, price, bedrooms, bathrooms, sqft)
