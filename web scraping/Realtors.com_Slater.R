library(rvest)
library(tidyverse)

#### Pulling recently SOLD houses ######
########################################

# full xpath for Realtor.com images: /html/body/div[1]/div[4]/section[1]/div/ul/li//div/div[2]/div[1]/a/picture/img

ForSale = "https://www.realtor.com/realestateandhomes-search/Slater_IA"
FSpage = read_html(ForSale)

# tried full xpath, tried xpath
FSaddress <- FSpage %>% html_elements(xpath = "/html/body/div[1]/div[4]/section[1]/div/ul/li//div/div[2]/div[5]/div[2]/div/div[3]//div/") %>% 
  html_text2()
print(FSaddress) # getting character(0) don't know how to fix

FS_image_urls <- FSpage %>% html_nodes(xpath = "/html/body/div[1]/div[4]/section[1]/div/ul/li//div/div[2]/div[1]/a/picture/img" ) %>% 
  html_attr("src")
print(FS_image_urls)

for (j in seq_along(FS_image_urls)) {
  address <- FSaddress[j]
  file_name <- paste0("R_S_", address, "_.png")
  file_path <- file.path("C:/Users/Kailyn Hogan/OneDrive - Iowa State University/Documents/GitHub/Housing/web scraping/images_slater_addresses", file_name)
  download.file(FS_image_urls[j], file_path, mode = "wb")
  print(file_path)
}