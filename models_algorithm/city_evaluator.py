# This file was made by the DSPG AI Housing team summer of 2023
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan, Mohammad Sadat
# will read in a parent folder with children folders labeled by address which have one or more images of that address
# calls house_evaluator to evaluate with AI models
# prints to csv file

import os
import subprocess

main_folder = 'house_image_inputs_test'

for folder_name in os.listdir(main_folder):
    if os.path.isdir(os.path.join(main_folder, folder_name)):
        address_folder_path = os.path.join(main_folder, folder_name)
        subprocess.call(["python", "house_evaluator.py", address_folder_path])





