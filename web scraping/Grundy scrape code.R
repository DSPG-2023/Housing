
#I think first 4 are neccesary for reading one webpage Rselenium may be needed for using search bars
install.packages(c("readr", "rvest", "magrittr", "xml2", "RSelenium"))
library(readr)
library(rvest)
library(magrittr)
library(xml2)
library(RSelenium)



# reads in csv data
sample_addresses <- read.csv("sample_addresses_as_csv.csv")
#print(addresses)

# webpage to scrape
zillow_url_grundy <- "https://www.zillow.com/grundy-center-ia/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22usersSearchTerm%22%3A%22Grundy%20Center%2C%20IA%22%2C%22mapBounds%22%3A%7B%22west%22%3A-93.21166512207031%2C%22east%22%3A-92.40828987792969%2C%22south%22%3A42.153050722920995%2C%22north%22%3A42.55594363773797%7D%2C%22regionSelection%22%3A%5B%7B%22regionId%22%3A24980%2C%22regionType%22%3A6%7D%5D%2C%22isMapVisible%22%3Afalse%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22days%22%7D%2C%22ah%22%3A%7B%22value%22%3Atrue%7D%2C%22land%22%3A%7B%22value%22%3Afalse%7D%7D%2C%22isListVisible%22%3Atrue%2C%22mapZoom%22%3A11%7D"
webpage_grundy <- read_html(zillow_url_grundy)

# gathers addresses
addresses <- webpage_grundy %>%
  html_nodes(xpath = "/html/body/div[1]/div[5]/div/div/div[1]/div[1]/ul/li//div/div/article/div/div[1]/a/address") %>%
  html_text()
print(addresses)


# gathers image links. Similair method as above
image_urls <- webpage_grundy %>%
  html_nodes(xpath = '//*[@id="swipeable"]/div[1]/a/div/img') %>%
  html_attr("src")

print(image_urls)

#downloads first item
#download.file(image_urls[1], "image.png", mode = "wb")

# creates folder for images scraped then iterativly names each image (1-9 in this case)
dir.create("images_grundy_sale")
for (i in seq_along(image_urls)) {
  file_path <- file.path("images_grundy_sale", paste0("image_", i, ".png"))
  download.file(image_urls[i], file_path, mode = "wb")
  print(file_path)
}

#creates folder for images scraped then names them based on address they were scraped with
dir.create("images_grundy_sale_addresses")
for (j in seq_along(image_urls)) {
  address <- addresses[j]
  file_name <- paste0("image_", address, ".png")
  file_path <- file.path("images_grundy_sale_addresses", file_name)
  download.file(image_urls[j], file_path, mode = "wb")
  print(file_path)
}


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




