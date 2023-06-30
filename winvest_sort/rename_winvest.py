# This file was made by the DSPG AI Housing team summer of 2023
# photos taken from winvest are renamed in this file to be our conventional name (source_city_address_)
# made by Gavin

import os
import shutil
import csv
import sys

# this number can be replaced to choose which city is being evaluated (same accross all files that need directories)
# This is to prevent commenting and uncommenting lines of code while choosing to redo cities
# DNE = Does Not Exist for this file
# DNE = test file

# 1 = New Hampton
# 2 = Independence
# 3 = Grundy Center

# DNE = Slater
# DNE = Ogden

city_being_evaluated = 1

if city_being_evaluated == 1:
    img_loc = os.path.expanduser("~/Documents/downloaded_winvest_images/winvest_hampton")
    csv_loc = os.path.expanduser('~/Documents/GitHub/Housing/winvest_sort/winvest_new_hampton_2023.csv')
    named_img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_hampton')    
elif city_being_evaluated == 2: 
    img_loc = os.path.expanduser("~/Documents/downloaded_winvest_images/winvest_independence")
    csv_loc = os.path.expanduser('~/Documents/GitHub/Housing/winvest_sort/winvest_indep_2023.csv')
    named_img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_ind')
elif city_being_evaluated == 3:
    img_loc = os.path.expanduser("~/Documents/downloaded_winvest_images/winvest_grundy")
    csv_loc = os.path.expanduser('~/Documents/GitHub/Housing/winvest_sort/winvest_grundy_2023.csv')
    named_img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_grundy')
else:
    print("Please enter a valid number from above")
    sys.exit()

image_files = [os.path.join(img_loc, file) for file in os.listdir(img_loc) if file.endswith(('png', 'jpg', 'jpeg'))]




for file in image_files:
    image_name = os.path.splitext(os.path.basename(file))[0]
    with open(csv_loc, 'r') as column:
        reader = csv.DictReader(column)
        for row in reader:
            photos = row['photos']
            address_combined = row['address_combined']
            address_combined = address_combined.upper()
            
            if photos == image_name:
                # Hampton
                # rename = f'W_H_{address_combined}_'
                # if rename == 'W_H_ _':
                #     break

                # Grundy
                # rename = f'W_G_{address_combined}_'
                # if rename == 'W_G_ _':
                #     break

                # independence
                rename = f'W_D_{address_combined}_'
                if rename == 'W_D_ _':
                    break

                new_name = rename + os.path.splitext(file)[1]
                new_folder = os.path.join(named_img_loc, new_name)
                shutil.copy2(file, new_folder)
                
                
    
