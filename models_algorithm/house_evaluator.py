# This file was made by the DSPG AI Housing team summer of 2023
# House images can be fed into this script and evaluated to return characteristics about the house (multiple pics from one house)
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan, Mohammad Sadat


# note to self: when installing some of these in terminal I had to say py instead of python
# py -m pip install matplotlib as an example
# not all of these are needed but I grabbed every import used for the AI model in case something needs to be edited here
import cv2
import os
import sys
import csv
import matplotlib.pyplot as plt
import imghdr
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras.models import load_model
import random
import pandas as pd

image_folder_parent = "house_image_inputs_test"
image_folder_address = [i.path for i in os.scandir(image_folder_parent) if i.is_dir()]

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
# list of images
img_list = []
# address needed from images to write to csv correctly
address = None
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
# if there is not a clear image to use variable remains and returns false into the csv
clear_image_available = False
# confidence of AI guesses
vegetation_confidence = 0
siding_confidence = 0
gutter_confidence = 0

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
temp_list = [google_img, zillow_img, vanguard_img, beacon_img, other_img]
for image in temp_list:
    if image is not None:
        img_list.append(image)

# TEST: this exports the images to a new folder to make sure they saved to variables correctly
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
# TODO check the first 3 houses checkers return the correct picture meaning check the binary values returned are the ones we want
# is house present model
# Is house present in image? Images not of houses and blurry images should be removed
temp_img_list = []
for image in img_list:    
    resize = tf.image.resize(image, (256,256)) 

    new_model = load_model(os.path.join('model_house_present', 'house_present_classifier.h5'))
    
    yhat = new_model.predict(np.expand_dims(resize/255, 0))
    # house present
    if yhat > 0.5: 
        temp_img_list.append(image)
    # else no house present
    
if len(temp_img_list) < len(img_list):
    img_list = temp_img_list
# test if removing properly
# print(img_list)
# print(len(img_list))
# sys.exit()

# clear image model
# can you see the house well? very poorly obstructed houses should be removed. very small images may be removed as well
if len(img_list) > 1:
    temp_img_list = []
    for image in img_list:    
        resize = tf.image.resize(image, (256,256)) 

        new_model = load_model(os.path.join('model_clear_images', 'clear_image_classifier.h5'))
        
        yhat = new_model.predict(np.expand_dims(resize/255, 0))
        # TODO clear image has 3 characteristics so non obstructed and partially need to pass while obstructed does not
        # ['Not Obstructed', 'Obstructed', 'Partially Obstructed']
        # clear image
        if yhat < 0.5: 
            temp_img_list.append(image)
        # else not clear
        
    if len(temp_img_list) < len(img_list):
        img_list = temp_img_list

# multiple house model
# are there multiple houses in the image? if other images exist remove these
if len(img_list) > 1:
    temp_img_list = []
    for image in img_list:    
        resize = tf.image.resize(image, (256,256)) 

        new_model = load_model(os.path.join('model_multiple_houses', 'multiple_houses_classifier.h5'))
        
        yhat = new_model.predict(np.expand_dims(resize/255, 0))
        # one house?
        if yhat > 0.5: 
            temp_img_list.append(image)
        # else multiple houses?
        
    if len(temp_img_list) < len(img_list):
        img_list = temp_img_list


# if more than 1 image is remaining meaning they were good images we must choose one
# first look at the dates if available for all images if one is newer choose it
# if not randomly pick one of the images and set randomly_selected_image to true
# TODO INSERT DATE CHECKER HERE
if len(img_list) > 1 :
    random_index = random.randint(0, len(img_list) -1)
    random_item = img_list[random_index]
    #this will hold the name and image of the index in img_list
    img_list = [random_item]
    randomly_selected_image = True

# assuming one image is remaining
# either set to clear_image_evaluate to be ran through other models or returns program asking for better images
# if we want to run a file of multiple houses images this will need to set a variable instead of exiting
if (img_list is None or len(img_list) == 0):
    sys.exit("No images provided or poor images provided")
else:
    clear_image_evaluate = img_list[0]
    clear_image_available = True


### EXAMPLE Vegetation model example
# img = cv2.imread("no_veg_test.png")
# plt.imshow(img)
# #plt.show()
# resize = tf.image.resize(img, (256,256))
# plt.imshow(resize.numpy().astype(int))
# #plt.show()

# new_model = load_model(os.path.join('model_vegetation', 'vegetationclassifier.h5'))

# yhat = new_model.predict(np.expand_dims(resize/255, 0))
# yhat
# if yhat > 0.5: 
#     print(f'Predicted class is vegetation')
#     vegetation = True
# else:
#     print(f'Predicted class is non-vegetation')
#     vegetation = False



# new vegetation model
# img = cv2.imread("no_veg_test.png")
img = clear_image_evaluate
resize = tf.image.resize(img, (180,180))

new_model = load_model(os.path.join('model_new_vegetation', 'vegetation_quality_classifier.h5'))

img_array = tf.keras.utils.img_to_array(resize)
# tf.keras.preprocessing.image.array_to_img(img_array).show()
tf.keras.preprocessing.image.array_to_img(img_array)
img_array = tf.expand_dims(img_array, 0)

predictions = new_model.predict(img_array)
score = tf.nn.softmax(predictions[0])
class_names = ['garden_present', 'no_garden', 'overgrown']
print(
    "This image most likely belongs to {} with a {:.2f} percent confidence."
    .format(class_names[np.argmax(score)], 100 * np.max(score))
)
vegetation_confidence = round(100 * np.max(score), 2)
if (np.argmax(score) == 0):
    vegetation = class_names[0]
elif (np.argmax(score) == 1):
    vegetation = class_names[1]
else:
    vegetation = class_names[2]


# siding model
# is there good siding
img = clear_image_evaluate
resize = tf.image.resize(img, (180,180))

new_model = load_model(os.path.join('model_siding', 'siding_quality_classifier.h5'))

img_array = tf.keras.utils.img_to_array(resize)
# tf.keras.preprocessing.image.array_to_img(img_array).show()
tf.keras.preprocessing.image.array_to_img(img_array)
img_array = tf.expand_dims(img_array, 0)

predictions = new_model.predict(img_array)
score = tf.nn.softmax(predictions[0])
class_names = ['chipped_paint', 'good_siding', 'poor_siding']
print(
    "This image most likely belongs to {} with a {:.2f} percent confidence."
    .format(class_names[np.argmax(score)], 100 * np.max(score))
)
siding_confidence = round(100 * np.max(score), 2)
if (np.argmax(score) == 0):
    siding = class_names[0]
elif (np.argmax(score) == 1):
    siding = class_names[1]
else:
    siding = class_names[2]

# TODO gutter model
# is there a good gutter
gutter = False

# TODO roof model
# I do not think 2023 will touch this...
# however people for next year, there was a decision in fulcrum to sort on roof quality (good, fair, poor) with no option of roof age
# will probably need two models, one that will assess age and one that will assess quality(meaning worn down or not for age and damaged or not)

# TODO window model
# identifies boarded up windows or broken windows


# write information to a csv file after evaluating
# return whether there was a clear image to use, if image was selected randomly, vegetation, siding, gutter, address(?), image(?) 
# This code will print values to an empty csv file. will not search for existing columns
# script_dir = os.path.dirname(os.path.abspath(__file__))
# csv_file_path = os.path.join(script_dir, 'house_attributes_test.csv')
# csv_exists = os.path.isfile(csv_file_path)
# with open(csv_file_path, 'a', newline='') as file:
#     writer = csv.writer(file)
#     if not csv_exists:
#         writer.writerow(['clear_image', 'rand_select', 'vegetation', 'siding', 'gutter'])
#     writer.writerow([clear_image_available, randomly_selected_image, vegetation, siding, gutter])


# will search for column names and print for every row
# def find_column(csv_file, column_name, attribute, address):
#     with open(csv_file, 'r') as file:
#         lines = list(csv.reader(file))
#         header = lines[0]
#         for index, column in enumerate(header):
#             if column == column_name:
#                 column_number = index
#                 for row in lines[1:]:
#                     row[column_number] = attribute
#                 with open(csv_file, 'w', newline='') as file:
#                     writer = csv.writer(file)
#                     writer.writerows(lines)
#                 return column_number + 1
#         return -1  

# csv_file = 'house_attributes_test.csv'
# address = '1225 LINCOLN WAY'
# column_name = 'clear_image'
# column_number = find_column(csv_file, column_name, clear_image_available, address)

# column_name = 'rand_select'
# column_number = find_column(csv_file, column_name, randomly_selected_image, address)

# column_name = 'vegetation'
# column_number = find_column(csv_file, column_name, vegetation, address)

# column_name = 'siding'
# column_number = find_column(csv_file, column_name, siding, address)

# column_name = 'gutter'
# column_number = find_column(csv_file, column_name, gutter, address)

# if column_number != -1:
#     print(f"The column '{column_name}' is located in column number {column_number}.")
# else:
#     print(f"The column '{column_name}' was not found in the CSV file.")



##loading the csv file
df = pd.read_csv('house_attributes_test.csv')

## check if the columns exist

if ('clear_image' in list(df.columns)):
   pass
else:
    df['clear_image'] = None

if ('rand_select' in list(df.columns)):
   pass
else:
    df['rand_select'] = None

if ('vegetation' in list(df.columns)):
   pass
else:
    df['vegetation'] = None

if ('vegetation_confidence' in list(df.columns)):
    pass
else:
    df['vegetation_confidence'] = None

if ('siding' in list(df.columns)):
    pass
else:
    df['siding'] = None

if ('siding_confidence' in list(df.columns)):
    pass
else:
    df['siding_confidence'] = None

if ('gutter' in list(df.columns)):
    pass
else:
    df['gutter'] = None

if ('gutter_confidence' in list(df.columns)):
    pass
else:
    df['gutter_confidence'] = None


## Assign the address that needs to be found
# address = '701 BENTON CIR'
text_split = image_folder_address[0].split("\\")
address = text_split[1]
print(text_split[1])

## Locate the target row for the address and insert the attribute
if (sum(df['address'] == address) != 0):
    idx = df.index[df['address'] == address].tolist()
    for i in idx:
        df.at[i,'clear_image'] = clear_image_available
        df.at[i, 'rand_select'] = randomly_selected_image
        df.at[i, 'vegetation'] = vegetation
        df.at[i, 'vegetation_confidence'] = vegetation_confidence
        df.at[i, 'siding'] = siding
        df.at[i, 'siding_confidence'] = siding_confidence
        df.at[i, 'gutter'] = gutter
        df.at[i, 'gutter_confidence'] = gutter_confidence

##Write the Dataframe the CSV file
df.to_csv('house_attributes_test.csv', index=False)




