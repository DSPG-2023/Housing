# This file was made by the DSPG AI Housing team summer of 2023
# takes an input and ouput folder to move images around so that city_evaluator can sort through images properly
# created by Gavin

import os
import shutil
# just used for sys.exit() to test
import sys




# # test image graber sorter thingymagig 
# # raw image file
# img_loc = os.path.expanduser("~/Documents/image_sort_test")
# # folder that is storing all city address image folders
# parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
# # folder for address folder to be added with image
# address_folders = os.path.expanduser("~/Documents/parent_folder_holder/address_folder_test")

# files = os.listdir(img_loc)

# for img in files:
#     # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
#     # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
    
#     address = img.split("_")[2]
#     new_address_folder = os.path.join(parent_folder, address_folders, address)
#     os.makedirs(new_address_folder, exist_ok=True)
    
#     source_path = os.path.join(img_loc, img)
#     destination_path = os.path.join(new_address_folder, img)
#     shutil.copyfile(source_path, destination_path)





# Grundy Center graber

# # raw image file
# img_loc = os.path.expanduser("~/Documents/downloaded google images/grundy_google_images_folder")
# # folder that is storing all city address image folders
# parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
# # folder for address folder to be added with image
# address_folders = os.path.expanduser("~/Documents/parent_folder_holder/grundy_address_image")

# files = os.listdir(img_loc)

# for img in files:
#     # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
#     # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
    
#     address = img.split("_")[2]
#     new_address_folder = os.path.join(parent_folder, address_folders, address)
#     os.makedirs(new_address_folder, exist_ok=True)
    
#     source_path = os.path.join(img_loc, img)
#     destination_path = os.path.join(new_address_folder, img)
#     shutil.copyfile(source_path, destination_path)





# Independence graber
# # raw image file
# img_loc = os.path.expanduser("~/Documents/downloaded google images/independence_google_images_folder_new")
# # folder that is storing all city address image folders
# parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
# # folder for address folder to be added with image
# address_folders = os.path.expanduser("~/Documents/parent_folder_holder/independence_address_image")

# files = os.listdir(img_loc)

# for img in files:
#     # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
#     # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
    
#     address = img.split("_")[2]
#     new_address_folder = os.path.join(parent_folder, address_folders, address)
#     os.makedirs(new_address_folder, exist_ok=True)
    
#     source_path = os.path.join(img_loc, img)
#     destination_path = os.path.join(new_address_folder, img)
#     shutil.copyfile(source_path, destination_path)





# New Hampton graber
# # raw image file
# img_loc = os.path.expanduser("~/Documents/downloaded google images/new_hampton_google_images_folder_new")
# # folder that is storing all city address image folders
# parent_folder = os.path.expanduser("~/Documents/parent_folder_holder")
# # folder for address folder to be added with image
# address_folders = os.path.expanduser("~/Documents/parent_folder_holder/hampton_address_image")

# files = os.listdir(img_loc)

# for img in files:
#     # ignore source and city, take the thrid (2) element seperated by _ then replace space with _ for folder address name
#     # reminder naming convention is source_city_address_ for example image from google of 123 main st in new hampton is G_H_123 main st_
    
#     address = img.split("_")[2]
#     new_address_folder = os.path.join(parent_folder, address_folders, address)
#     os.makedirs(new_address_folder, exist_ok=True)
    
#     source_path = os.path.join(img_loc, img)
#     destination_path = os.path.join(new_address_folder, img)
#     shutil.copyfile(source_path, destination_path)




# Slater graber

# raw image file
img_loc = os.path.expanduser("~/Documents/downloaded google images/slater_google_images_folder")
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




