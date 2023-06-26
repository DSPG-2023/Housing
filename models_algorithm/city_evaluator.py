# This file was made by the DSPG AI Housing team summer of 2023
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan, Mohammad Sadat
# will read in a parent folder with children folders labeled by address which have one or more images of that address
# calls house_evaluator to evaluate with AI models
# prints to csv file

import os
import pandas as pd
import house_evaluator
import sys 

# main_folder = 'house_image_inputs_test'
main_folder = os.path.expanduser("~/Documents/parent_folder_holder/address_folder_test")

image_folder_address = [i.path for i in os.scandir(main_folder) if i.is_dir()]
folder_address_num = 0
# ['house_image_inputs_test\\1203 COMPUTER DR', 'house_image_inputs_test\\2594 LINDSY CIR', 'house_image_inputs_test\\3997 LINCOLN ST']
# print(image_folder_address)
# sys.exit()



for folder_name in os.listdir(main_folder):
    if os.path.isdir(os.path.join(main_folder, folder_name)):
        address_folder_path = os.path.join(main_folder, folder_name)
        attributes = house_evaluator.evaluate_houses(address_folder_path)

        clear_image = attributes.get("clear_image")
        test_failed = attributes.get("test_failed")
        rand_select = attributes.get("rand_select")
        vegetation = attributes.get("vegetation")
        vegetation_confidence = attributes.get("vegetation_confidence")
        siding = attributes.get("siding")
        siding_confidence = attributes.get("siding_confidence")
        gutter = attributes.get("gutter")
        gutter_confidence = attributes.get("gutter_confidence")

        # print("city_eval values BELOW")
        # print(clear_image, rand_select, vegetation, vegetation_confidence, siding, siding_confidence, gutter, gutter_confidence)


        # load csv file
        df = pd.read_csv('house_attributes_test.csv')

        # check if the columns exist
        if ('clear_image' in list(df.columns)):
           pass
        else:
            df['clear_image'] = None

        if ('test_failed' in list(df.columns)):
            pass
        else:
            df['test_failed'] = None

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


            

        text_split = image_folder_address[folder_address_num].split(os.sep)
        address = text_split[-1]
        print(address)

        ## Locate the target row for the address and insert the attribute
        if (sum(df['address'] == address) != 0):
            idx = df.index[df['address'] == address].tolist()
            for i in idx:
                df.at[i,'clear_image'] = clear_image
                df.at[i, 'test_failed'] = test_failed
                df.at[i, 'rand_select'] = rand_select
                df.at[i, 'vegetation'] = vegetation
                df.at[i, 'vegetation_confidence'] = vegetation_confidence
                df.at[i, 'siding'] = siding
                df.at[i, 'siding_confidence'] = siding_confidence
                df.at[i, 'gutter'] = gutter
                df.at[i, 'gutter_confidence'] = gutter_confidence

            ##Write the Dataframe the CSV file
            df.to_csv('house_attributes_test.csv', index=False)
        folder_address_num += 1





