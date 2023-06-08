install.packages("readxl")
library(readxl)
library(stringr)
library(rvest)
library(xml2)
library(magrittr)

#gathers urls
slater_data <- read.csv("~/GitHub/Housing/complete links/Slater_urls.csv")
urls_start <- slater_data[, 1]
urls_full <- paste(urls_start, "&key=", sep = "")
urls_full_api_key <- paste(urls_full, api_key, sep = "")


# creates folder and downloads all images
dir.create("slater_google_images_folder")
for(i in seq_along(urls_full_api_key)) {
  file_path <- file.path("slater_google_images_folder", paste0("image_", i, ".png"))
  download.file(urls_full_api_key[i], file_path, mode = "wb")
  print(file_path)
}

# IMPORTANT!!! DELETE KEY BEFORE PUSHING TO GITHUB
# this is a temporary solution we need a safer key we can set up later
api_key <- ""


