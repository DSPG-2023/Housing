# This file was made by the DSPG AI Housing team summer of 2023
# photos taken from winvest are renamed in this file to be our conventional name (source_city_address_)
# made by Gavin

import os
import pandas as pd
import shutil
import csv


img_loc = os.path.expanduser("~/Documents/downloaded_winvest_images/winvest_hampton")
csv_loc = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/winvest_sort/winvest_new_hampton_2023.csv'))
named_img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_hampton')

with open(csv_loc, 'r') as csv_file:
    reader = csv.reader(csv_file)
    header = next(reader)

    # search for image name and address

    for row in reader:
        image_name = row[0]
        address = row[1]

        image_path = os.path.join(img_loc, image_name)

        if os.path.isfile(image_path):
            rename = os.path.join(named_img_loc, address + '.jpg')

            shutil.copy2(image_path, rename)

