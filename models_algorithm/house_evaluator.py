# This file was made by the DSPG AI Housing team summer of 2023
# House images can be fed into this script and evaluated to return characteristics about the house (multiple pics from one house)
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan


# note to self: when installing these in terminal I had to say py instead of python
import cv2
import os
import sys
import csv

# access to the folder with images that must be evaluated
# currently only a single houses images can be evaluated
image_folder = "single_house_image_inputs"

# creates a list of the images in the folder and only grabs png jpg jpeg files
image_files = [os.path.join(image_folder, file) for file in os.listdir(image_folder) if file.endswith(('png', 'jpg', 'jpeg'))]

# initialize source image variables. These can be changed
google_img = None
zillow_img = None
vanguard_img = None
beacon_img = None
other_img = None
# once images evaluated this variable is used for the one image selected
clear_image_evaluate = None
# if multiple quality images remain we will randomly choose which one to evaluate 
# BUT this will be added to attributes so that if an image was selected randomly we can verify that it had multiple good images manually
randomly_selected_image = False
# boolean variables: vegetation is true when vegetation is present, siding is true when it is good quality, same with gutters
# if we add more options to these variables such as poor, medium, good they could be used as strings
vegetation = None
siding = None
gutter = None

# based on the source letter at the beginning of the name the image is assigned to a variable
for file in image_files:
    image_name = os.path.splitext(os.path.basename(file))[0]
    image = cv2.imread(file)

    if image_name.startswith('G'):
        google_img = image
    elif image_name.startswith('Z'):
        zillow_img = image
    elif image_name.startswith('V'):
        vanguard_img = image
    elif image_name.startswith('B'):
        beacon_img = image
    else:
        other_img = image

# remove images from list as it runs through first few evaluator models
img_list = [google_img, zillow_img, vanguard_img, beacon_img, other_img]


#TEST: this exports the images to a new folder to make sure they saved to variables correctly
# new_folder = os.path.join(image_folder, 'new_folder_test')
# os.makedirs(new_folder, exist_ok = True)
# if google_img is not None:
#     cv2.imwrite(os.path.join(new_folder, 'google_img.png'), google_img)
# if zillow_img is not None:
#     cv2.imwrite(os.path.join(new_folder, 'zillow_img.png'), zillow_img)
# if vanguard_img is not None:
#     cv2.imwrite(os.path.join(new_folder, 'vanguard_img.png'), vanguard_img)
# if beacon_img is not None:
#     cv2.imwrite(os.path.join(new_folder, 'beacon_img.png'), beacon_img)
# if other_img is not None:
#     cv2.imwrite(os.path.join(new_folder, 'other_img.png'), other_img)
# print('Images exported to:', new_folder)


# only delete todos when you finish the algorithm or if it mostly works
# the first three house picture quality models should have one image remaining after running(house present, clear image, and multiple houses)
# when an image does not pass our evaluations it should be removed from the list for example img_list.remove(google_img)
### TODO is house present model
# Is house present in image? Images not of houses and blurry images should be removed

### TODO clear image model
# can you see the house well? very poorly obstructed houses should be removed. very small images may be removed as well

### TODO multiple house model
# are there multiple houses in the image? if other images exist remove these

### TODO date/random picker
# if more than 1 image is remaining meaning they were good images we must choose one
# first look at the dates if available for all images if one is newer choose it
# if not randomly pick one of the images and set randomly_selected_image to true

# assuming one image is remaining
# either set to clear_image_evaluate to be ran through other models or returns program asking for better images
# if we want to run a file of multiple houses images this will need to set a variable instead of exiting
if (img_list is None or len(img_list) == 0):
    sys.exit("No images provided or poor images provided")
else:
    clear_image_evaluate = img_list[0]


### TODO Vegetation model
# is there vegetation present

### TODO siding model
# is there good siding

### TODO gutter model
# is there a good gutter



### TODO write information to a csv file after evaluating
# return whether there was a clear image to use, if image was selected randomly, vegetation, siding, gutter, address(?), image(?) 
# TEST: pushes to the house_attributes_test csv
clear_image = True
rand_select = False
vegetation = True
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_file_path = os.path.join(script_dir, 'house_attributes_test.csv')
csv_exists = os.path.isfile(csv_file_path)
with open(csv_file_path, 'a', newline='') as file:
    writer = csv.writer(file)
    if not csv_exists:
        writer.writerow(['clear_image', 'rand_select', 'vegetation'])
    writer.writerow([clear_image, rand_select, vegetation])
