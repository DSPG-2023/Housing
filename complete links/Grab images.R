install.packages("readxl")
library(readxl)
library(stringr)
library(rvest)
library(xml2)
library(magrittr)



# Ogden
og_data <- read.csv("~/GitHub/Housing/complete links/ogden_urls.csv")
urls_start <- og_data[, 1]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("ogden_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("ogden_google_images_folder", paste0("G_OG_", og_data[i,6], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}


# Des Moines
dm_data <- read.csv("~/GitHub/Housing/complete links/des_moines_supp_urls.csv")
urls_start <- dm_data[, 1]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("des_moines_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("des_moines_google_images_folder", paste0("G_DM_", dm_data[i,14], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}


# Des Moines Poor only
dm_data <- read.csv("~/GitHub/Housing/complete links/des_moines_supp_urls.csv")
urls_start <- dm_data[, 26]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("des_moines_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  if (urls_start[i] != ""){
    file_path <- file.path("des_moines_poor_google_images_folder", paste0("G_DM_", dm_data[i,14], "_.png"))
    download.file(urls_full_api_key[i], file_path, mode = "wb")
    print(file_path)
  }
  print(i)
}



# GRUNDY CENTER
grundy_data <- read.csv("~/GitHub/Housing/complete links/Grundy_Center_urls.csv")
urls_start <- grundy_data[, 1]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("grundy_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("grundy_google_images_folder", paste0("G_G_", grundy_data[i,3], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}


# INDEPENDENCE
independence_data <- read.csv("~/GitHub/Housing/complete links/Independence_urls.csv")
urls_start <- independence_data[, 9]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("independence_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("independence_google_images_folder", paste0("G_D_", independence_data[i,3], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}


# NEW HAMPTON
hampton_data <- read.csv("~/GitHub/Housing/complete links/New_Hampton_urls.csv")
urls_start <- hampton_data[, 12]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("new_hampton_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("new_hampton_google_images_folder", paste0("G_H_", hampton_data[i,6], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}


# SLATER
#gathers urls
slater_data <- read.csv("~/GitHub/Housing/complete links/Slater_urls.csv")
urls_start <- slater_data[, 1]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")
# creates folder and downloads all images
dir.create("slater_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("slater_google_images_folder", paste0("G_S_", slater_data[i,3], "_.png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
  print(i)
}

# IMPORTANT!!! DELETE KEY BEFORE PUSHING TO GITHUB
# this is a temporary solution we need a safer key we can set up later
# also if you run this line with the API key once it will stay in Rstudio until you reset storage
api_key <- ""
# Sources: Z (Zillow) G (Google) V (Vanguard) B (Beacon) :: Cities: S (Slater) H (New Hampton) D (Independence) G (Grundy Center)
# (source_city_address_) 

