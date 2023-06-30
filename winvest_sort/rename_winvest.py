# This file was made by the DSPG AI Housing team summer of 2023
# photos taken from winvest are renamed in this file to be our conventional name (source_city_address_)
# made by Gavin

import os
import shutil
import csv


address_full_column = None
photos_column = None

img_loc = os.path.expanduser("~/Documents/downloaded_winvest_images/winvest_hampton")
csv_loc = os.path.expanduser('~/Documents/GitHub/Housing/winvest_sort/winvest_new_hampton_2023.csv')
named_img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_hampton')
image_files = [os.path.join(img_loc, file) for file in os.listdir(img_loc) if file.endswith(('png', 'jpg', 'jpeg'))]




for file in image_files:
    image_name = os.path.splitext(os.path.basename(file))[0]
    with open(csv_loc, 'r') as column:
        reader = csv.DictReader(column)
        for row in reader:
            photos = row['photos']
            address_combined = row['address_combined']
            if photos == image_name:
                rename = f'W_H_{address_combined}_'
                if rename == 'W_H_ _':
                    break
                new_name = rename + os.path.splitext(file)[1]
                new_folder = os.path.join(named_img_loc, new_name)
                shutil.copy2(file, new_folder)
                
                
    
