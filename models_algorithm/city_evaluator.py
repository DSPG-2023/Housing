# This file was made by the DSPG AI Housing team summer of 2023
# Contributers: Angelina Evans, Gavin Fisher, and Kailyn Hogan, Mohammad Sadat
# will read in a parent folder with children folders labeled by address which have one or more images of that address
# calls house_evaluator to evaluate with AI models
# prints to csv file

import os
import pandas as pd
import house_evaluator
import sys 


# this number can be replaced to choose which city is being evaluated (same accross all files that need directories)
# This is to prevent commenting and uncommenting lines of code while choosing to redo cities
# 0 = test file
# 1 = New Hampton
# 2 = Independence
# 3 = Grundy Center
# 4 = Slater
# 5 = Ogden
city_being_evaluated = 5


if city_being_evaluated == 0:
    # main_folder = 'house_image_inputs_test'
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/address_folder_test")
elif city_being_evaluated == 1:
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/hampton_address_image")
elif city_being_evaluated == 2:
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/independence_address_image")
elif city_being_evaluated == 3:
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/grundy_address_image")
elif city_being_evaluated == 4:
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/slater_address_image")
elif city_being_evaluated == 5:
    main_folder = os.path.expanduser("~/Documents/parent_folder_holder/ogden_address_image")
else:
    print("Please enter a valid number from above")
    sys.exit()


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
        img_used = attributes.get("img_used")
        test_failed = attributes.get("test_failed")
        rand_select = attributes.get("rand_select")
        vegetation = attributes.get("vegetation")
        vegetation_confidence = attributes.get("vegetation_confidence")
        siding = attributes.get("siding")
        siding_confidence = attributes.get("siding_confidence")
        gutter = attributes.get("gutter")
        gutter_confidence = attributes.get("gutter_confidence")
        roof = attributes.get("roof")
        roof_confidence = attributes.get("roof_confidence")

        

        # print("city_eval values BELOW")
        # print(clear_image, rand_select, vegetation, vegetation_confidence, siding, siding_confidence, gutter, gutter_confidence)


        # load csv file
        if city_being_evaluated == 0:
            df = pd.read_csv('house_attributes_test.csv')
        elif city_being_evaluated == 1:
            df = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/New_Hampton_database.csv'))
        elif city_being_evaluated == 2:
            df = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Independence_database.csv'))
        elif city_being_evaluated == 3:
            df = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Grundy_Center_database.csv'))
        elif city_being_evaluated == 4:
            df = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Slater_database.csv'))
        elif city_being_evaluated == 5:
            df = pd.read_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/ogden_database.csv'))



        # check if the columns exist
        if ('clear_image' in list(df.columns)):
           pass
        else:
            df['clear_image'] = None

        if ('img_used' in list(df.columns)):
            pass
        else:
            df['img_used' in list(df.columns)] = None 

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

        if ('roof' in list(df.columns)):
            pass
        else:
            df['roof'] = None

        if ('roof_confidence' in list(df.columns)):
            pass
        else:
            df['roof_confidence'] = None


            

        text_split = image_folder_address[folder_address_num].split(os.sep)
        address = text_split[-1]
        print(address)

        # Locate the target row for the address and insert the attribute
        if (sum(df['address'] == address) != 0):
            idx = df.index[df['address'] == address].tolist()
            for i in idx:
                df.at[i,'clear_image'] = clear_image
                df.at[i, 'img_used'] = img_used
                df.at[i, 'test_failed'] = test_failed
                df.at[i, 'rand_select'] = rand_select
                df.at[i, 'vegetation'] = vegetation
                df.at[i, 'vegetation_confidence'] = vegetation_confidence
                df.at[i, 'siding'] = siding
                df.at[i, 'siding_confidence'] = siding_confidence
                df.at[i, 'gutter'] = gutter
                df.at[i, 'gutter_confidence'] = gutter_confidence
                df.at[i, 'roof'] = roof
                df.at[i, 'roof_confidence'] = roof_confidence

            # Write the Dataframe the CSV file
            if city_being_evaluated == 0:
                df.to_csv('house_attributes_test.csv', index = False)
            elif city_being_evaluated == 1:
                df.to_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/New_Hampton_database.csv'), index = False)           
            elif city_being_evaluated == 2:
                df.to_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Independence_database.csv'), index = False)
            elif city_being_evaluated == 3:
                df.to_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Grundy_Center_database.csv'), index = False)
            elif city_being_evaluated == 4:
                df.to_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/Slater_database.csv'), index = False)
            elif city_being_evaluated == 5:
                df.to_csv(os.path.expanduser('~/Documents/GitHub/Housing/Housing Databases/ogden_database.csv'), index = False)


        folder_address_num += 1





