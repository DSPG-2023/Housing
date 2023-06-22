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



# access to the folder with images that must be evaluated
# currently only a single houses images can be evaluated
image_folder = "single_house_image_inputs"
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


