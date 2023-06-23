# This file was made by the DSPG AI Housing team summer of 2023
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan, Mohammad Sadat
# Will contain models to evaluate a house and return attributes


import cv2
import os
import sys
import csv
import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout
from tensorflow.keras.models import load_model
import random
import pandas as pd

image_folder = sys.argv[1]
# print(f"Evaluating house images in folder: {image_folder}")



# access to the folder with images that must be evaluated
# currently only a single houses images can be evaluated
# image_folder = "single_house_image_inputs"
# creates a list of the images in the folder and only grabs png jpg jpeg files
image_files = [os.path.join(image_folder, file) for file in os.listdir(image_folder) if file.endswith(('png', 'jpg', 'jpeg'))]
# initialize source image variables.
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


# the first three house picture quality models should have one image remaining after running(house present, clear image, and multiple houses)
# TODO check the first 3 houses checkers return the correct picture meaning check the binary values returned are the ones we want
# is house present model
temp_img_list = []
for image in img_list:    
    resize = tf.image.resize(image, (256,256)) 

    new_model = load_model(os.path.join('model_house_present', 'house_present_classifier.h5'))
    
    yhat = new_model.predict(np.expand_dims(resize/255, 0))
    # house present
    if yhat < 0.5: 
        temp_img_list.append(image)
        print("passed house present model")
    # else no house present
    else:
        print("Did not pass house present model")
    
if len(temp_img_list) < len(img_list):
    img_list = temp_img_list

# clear image model
if len(img_list) > 1:
    temp_img_list = []
    for image in img_list:    
        resize = tf.image.resize(image, (180,180)) 

        new_model = load_model(os.path.join('model_clear_images', 'clear_image_classifier.h5'))
        
        yhat = new_model.predict(np.expand_dims(resize/180, 0))
        guess_index = np.argmax(yhat)
        # TODO clear image has 3 characteristics so non obstructed and partially need to pass while obstructed does not
        # ['Not Obstructed', 'Obstructed', 'Partially Obstructed']
        if guess_index == 0 or guess_index == 2:
            temp_img_list.append(image)
            print("passed clear image model")
        else:
            print("did not pass clear image model")
        
        
        
        
    if len(temp_img_list) < len(img_list) & len(temp_img_list) != 0:
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
            print("passed single house model")
        # else multiple houses?
        else: 
            print("failed multiple houses classifier")
        
    if len(temp_img_list) < len(img_list) & len(temp_img_list) != 0:
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


# new vegetation model
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
