# This file was made by the DSPG AI Housing team summer of 2023
# takes an input and ouput folder to move images around so that city_evaluator can sort through images properly
# created by Gavin

import os
import shutil
import sys


# this number can be replaced to choose which city is being evaluated (same accross all files that need directories)
# This is to prevent commenting and uncommenting lines of code while choosing to redo cities
# 0 = test file
# 1 = New Hampton
# 2 = Independence
# 3 = Grundy Center
# 4 = Slater
# 5 = Ogden
city_being_evaluated = 1

# Sources sorting from
# 0 = test
# 1 = Google
# 2 = Winvest
# 3 = Zillow
# 4 = Vanguard
# 5 = Beacon
image_source = 1

# if the source is not yet collected (as of right now zillow vanguard beacon) will return with these lines.
def source_not_available():
    print("The selected source is not available for the selected city.")
    print("Please select a different source for this city.")
    sys.exit()

if city_being_evaluated == 0:
    # test image graber sorter thingymagig 
    # raw image file
    img_loc = os.path.expanduser("~/Documents/image_sort_test")
    # folder that is storing all city address image folders
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    # folder for address folder to be added with image
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/address_folder_test")

    files = os.listdir(img_loc)

    for img in files:
        # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
        # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
        address = img.split("_")[2]
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

elif city_being_evaluated == 1:
    # raw image file
    if image_source == 0:
        source_not_available()
    elif image_source == 1:
        img_loc = os.path.expanduser("~/Documents/downloaded google images/new_hampton_google_images_folder_new")
    elif image_source == 2:
        img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_hampton')
    elif image_source == 3:
        source_not_available()
    elif image_source == 4:
        source_not_available()
    elif image_source == 5:
        source_not_available()
    else:
        print("Please enter a valid number from above")
        sys.exit()

    # folder that is storing all city address image folders
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    # folder for address folder to be added with image
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/hampton_address_image")

    files = os.listdir(img_loc)

    for img in files:
        # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
        # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
        address = img.split("_")[2]
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

elif city_being_evaluated == 2:
    # raw image file
    if image_source == 0:
        source_not_available()
    elif image_source == 1:
        img_loc = os.path.expanduser("~/Documents/downloaded google images/independence_google_images_folder_new")
    elif image_source == 2:
        img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_ind')
    elif image_source == 3:
        source_not_available()
    elif image_source == 4:
        source_not_available()
    elif image_source == 5:
        source_not_available()
    else:
        print("Please enter a valid number from above")
        sys.exit()
    
    # folder that is storing all city address image folders
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    # folder for address folder to be added with image
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/independence_address_image")

    files = os.listdir(img_loc)

    for img in files:
        # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
        # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_       
        address = img.split("_")[2]
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

elif city_being_evaluated == 3:
    # raw image file
    if image_source == 0:
        source_not_available()
    elif image_source == 1:
        img_loc = os.path.expanduser("~/Documents/downloaded google images/grundy_google_images_folder")
    elif image_source == 2:
        img_loc = os.path.expanduser('~/Documents/winvest_images_renamed/win_re_grundy')
    elif image_source == 3:
        source_not_available()
    elif image_source == 4:
        source_not_available()
    elif image_source == 5:
        source_not_available()
    else:
        print("Please enter a valid number from above")
        sys.exit()
    
    # folder that is storing all city address image folders
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    # folder for address folder to be added with image
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/grundy_address_image")

    files = os.listdir(img_loc)

    for img in files:
        # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
        # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
        address = img.split("_")[2]
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

elif city_being_evaluated == 4:
    # raw image file
    if image_source == 0:
        source_not_available()
    elif image_source == 1:
        img_loc = os.path.expanduser("~/Documents/downloaded google images/slater_google_images_folder")
    elif image_source == 2:
        source_not_available()
    elif image_source == 3:
        source_not_available()
    elif image_source == 4:
        source_not_available()
    elif image_source == 5:
        source_not_available()
    else:
        print("Please enter a valid number from above")
        sys.exit()

    # folder that is storing all city address image folders
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    # folder for address folder to be added with image
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/slater_address_image")

    files = os.listdir(img_loc)

    for img in files:
        # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
        # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
        # added .strip because my images had spaces around address
        address = img.split("_")[2].strip()
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

elif city_being_evaluated == 5:
    if image_source == 0:
        source_not_available()
    elif image_source == 1:
        img_loc = os.path.expanduser("~/Documents/downloaded google images/ogden_google_images_folder")
    elif image_source == 2:
        source_not_available()
    elif image_source == 3:
        source_not_available()
    elif image_source == 4:
        source_not_available()
    elif image_source == 5:
        source_not_available()
    else:
        print("Please enter a valid number from above")
        sys.exit()
    
    parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
    address_folders = os.path.expanduser("~/Documents/parent_folder_holder/ogden_address_image")

    files = os.listdir(img_loc)

    for img in files:
        address = img.split("_")[2].strip()
        new_address_folder = os.path.join(parent_folder, address_folders, address)
        os.makedirs(new_address_folder, exist_ok=True)
        source_path = os.path.join(img_loc, img)
        destination_path = os.path.join(new_address_folder, img)
        shutil.copyfile(source_path, destination_path)

else:
    print("Please enter a valid number from above")
    sys.exit()


