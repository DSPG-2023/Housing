#Gathering data for Independence, IA on Zillow

#install packages and load libraries
install.packages(c("readr", "rvest", "magrittr", "xml2", "RSelenium"))
library(readr)
library(rvest)
library(magrittr)
library(xml2)
library(RSelenium)


# webpage to scrape. This link is for Independence houses FOR SALE
zillow_url_inde <- "https://www.zillow.com/independence-ia/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22mapBounds%22%3A%7B%22north%22%3A42.88681926308871%2C%22east%22%3A-91.15901076171875%2C%22south%22%3A42.12347499742446%2C%22west%22%3A-92.61469923828125%7D%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A12037%2C%22regionType%22%3A6%7D%5D%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22schm%22%3A%7B%22value%22%3Afalse%7D%2C%22schh%22%3A%7B%22value%22%3Afalse%7D%2C%22schu%22%3A%7B%22value%22%3Afalse%7D%2C%22schp%22%3A%7B%22value%22%3Afalse%7D%2C%22schr%22%3A%7B%22value%22%3Afalse%7D%2C%22sche%22%3A%7B%22value%22%3Afalse%7D%2C%22schc%22%3A%7B%22value%22%3Afalse%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A9%7D"
webpage_inde <- read_html(zillow_url_inde)

# gathers addresses. This xpath can be obtained by right clicking on the address you want and clicking inspect.
# you then must navigate to the html section that contains the text. right click again and go to copy -> full xpath
# to gather all addresses on page the full xpath must be altered for example this xpath below has li// which signifies select all children where the original xpath would just have li/...
addresses <- webpage_inde %>%
  html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>%
  html_text()
print(addresses)


# gathers image links. Similar method as above
image_urls <- webpage_inde %>%
  html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[2]/div[2]/div/div[2]/div/div[1]/a/div/img') %>%
  html_attr("src")

print(image_urls)

#creates folder for images scraped then names them based on address they were scraped with
# same as above except for how the images are named. for each image the address grabbed earlier is printed as the name.
# this returns (image_ 123 main st) for example
# you can alter this to return our naming convention (source_city_address_) by replacing "image_" with the source and city
# for example if you are pulling slater images from zillow it will be paste0("Z_S_", address, "_.png") which will print the titles of images as Z_S_123 main st_.png
# Z (Zillow) G (Google) V (Vanguard) B (Beacon) :: S (Slater) H (New Hampton) D (Independence) G (Grundy Center)
dir.create("images_independence_addresses")
for (j in seq_along(image_urls)) {
  address <- addresses[j]
  file_name <- paste0("Z_D_", address, ".png")
  file_path <- file.path("C:/Users/babyn/OneDrive/Desktop/Summer DPSG/DSPG2023/Housing/HousingDatabase/web scraping/images_independence_sale_addresses", file_name)
  download.file(image_urls[j], file_path, mode = "wb")
  print(file_path)
}


#HOUSES NOT FOR SALE--------------------------------

library(readr)
library(rvest)
library(magrittr)
library(xml2)
library(RSelenium)

# webpage to scrape. This link is for Independence houses for sale
zillow_url_inde <- "https://www.zillow.com/independence-ia/sold/10_p/?searchQueryState=%7B%22pagination%22%3A%7B%22currentPage%22%3A10%7D%2C%22mapBounds%22%3A%7B%22north%22%3A42.642538%2C%22south%22%3A42.369789%2C%22east%22%3A-91.740217%2C%22west%22%3A-92.033493%7D%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A12037%2C%22regionType%22%3A6%7D%5D%2C%22isMapVisible%22%3Afalse%2C%22filterState%22%3A%7B%22fore%22%3A%7B%22value%22%3Afalse%7D%2C%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%2C%22auc%22%3A%7B%22value%22%3Afalse%7D%2C%22nc%22%3A%7B%22value%22%3Afalse%7D%2C%22rs%22%3A%7B%22value%22%3Atrue%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%2C%22fsbo%22%3A%7B%22value%22%3Afalse%7D%2C%22cmsn%22%3A%7B%22value%22%3Afalse%7D%2C%22fsba%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%7D"
webpage_inde <- read_html(zillow_url_inde)

# gathers addresses. This xpath can be obtained by right clicking on the address you want and clicking inspect.
# you then must navigate to the html section that contains the text. right click again and go to copy -> full xpath
# to gather all addresses on page the full xpath must be altered for example this xpath below has li// which signifies select all children where the original xpath would just have li/...
addresses <- webpage_inde %>%
  html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[1]/a") %>%
  html_text()
print(addresses)


# gathers image links. Similar method as above
image_urls <- webpage_inde %>%
  html_nodes(xpath = '/html/body/div[1]/div[5]/div/div/div/div[1]/ul/li//div/div/article/div/div[2]/div[2]/a/div/img') %>%
  html_attr("src")

print(image_urls)

#creates folder for images scraped then names them based on address they were scraped with
# same as above except for how the images are named. for each image the address grabbed earlier is printed as the name.
# this returns (image_ 123 main st) for example
# you can alter this to return our naming convention (source_city_address_) by replacing "image_" with the source and city
# for example if you are pulling slater images from zillow it will be paste0("Z_S_", address, "_.png") which will print the titles of images as Z_S_123 main st_.png
# Z (Zillow) G (Google) V (Vanguard) B (Beacon) :: S (Slater) H (New Hampton) D (Independence) G (Grundy Center)
#dir.create("images_independence_sold_addresses")
for (j in seq_along(image_urls)) {
  address <- addresses[j]
  file_name <- paste0("Z_D_", address, ".png")
  file_path <- file.path("C:/Users/babyn/OneDrive/Desktop/Summer DPSG/DSPG2023/Housing/HousingDatabase/web scraping/images_independence_sale_addresses", file_name)
  download.file(image_urls[j], file_path, mode = "wb")
  print(file_path)
}




#IGNORE EVERYTHING BELOW

# reads in csv data. 
sample_addresses <- read.csv("sample_addresses_as_csv.csv")
#print(addresses)


#This was my attempt to use the search bar on the homepage
install.packages("wdman")
library(wdman)
driver <- rsDriver(browser = "chrome", chromever = "114.0.5735.90", port = 4444L, chromedriver = "C:/Users/BlueD/Documents/chromedriver_win32/chromedriver.exe")

driver <- rsDriver(browser = "chrome")
remote_driver <- driver[["client"]]
remote_driver$navigate("https://www.zillow.com/")
searchInput <- remDr$findElement(using = "css selector", value = "#search-box-input")
searchInput$clearElement()
address <- "New Hampton IA"
searchInput$sendKeysToElement(list(address, key = "enter"))
Sys.sleep(5)
searchResults <- remDr$findElements(using = "css selector", value = ".list-card")
print(length(searchResults))
remDr$close()
rD$server$stop()




zillow_url <- "https://www.zillow.com/"
zillow_webpage <- read_html(zillow_url)
searchbar_input_select <- "input#search-box-input"
searchbar_input <- html_nodes(zillow_webpage, searchbar_input_select)
location <- "New Hampton IA"
searchbar_input <- html_attr(searchbar_input, location)
zillow_search <- html_form(zillow_webpage)[[1]]
zillow_search <- set_values(zillow_search, "input#search-box-input" = location)
zillow_webpage <- submit_form(zillow_webpage, zillow_search)
search_results_link <- html_nodes(zillow_webpage, "a.list-card-link")
search_links <- html_attr(search_results_link, "href")
print(search_links)
zillow_webpage <- close(zillow_webpage)




