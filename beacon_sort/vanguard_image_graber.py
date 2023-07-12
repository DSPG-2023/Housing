# This file was made by the DSPG AI Housing team summer of 2023
# There is a scraper that exists that grabbed a bunch of info from Vanguard and threw it into a csv file (not sure where the scraper is)
# Given a file of urls of beacon images this program grabs those images and downloads them renamed
# made by Gavin

import os
import sys
import requests
import pandas as pd
from urllib.parse import urlparse

# this number can be replaced to choose which city is being evaluated (same accross all files that need directories)
# This is to prevent commenting and uncommenting lines of code while choosing to redo cities

# 2 = Independence



city_being_evaluated = 2

if city_being_evaluated == 2:
    csv_loc = os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/independence_beacon_links.csv')
    img_download_loc = os.path.expanduser('~/Documents/downloaded_vanguard_images/vanguard_independence')
else:
    print("Please enter a valid number from above")
    sys.exit()

df = pd.read_csv(csv_loc)
for index, row in df.iterrows():
    links = row["link"]
    address = row["address"]
    
    if pd.isna(address) or address == "INDEPENDENCE" or pd.isna(links) or address.startswith("SKIP"):
        continue

    parsed_url = urlparse(links)
    

    filename = os.path.basename(parsed_url.path)
    print(filename)
    
    _, extension = os.path.splitext(filename)
    
    
    address_min_town = address.split(",")[0].strip()

    rename = f"V_D_{address_min_town}_.jpeg"
    print(rename)
    
    save_image = os.path.join(img_download_loc, rename)

    csv_link = requests.get(links)
    with open(save_image, "wb") as file:
        file.write(csv_link.content)
    

    
    










