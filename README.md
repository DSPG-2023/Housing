# AI-Driven Housing Evaluation for Rural Community Development


## Project Members
+ Project Interns: Angelina Evans, Gavin Fisher, Kailyn Hogan
+ Grad Fellow: Morenike Atejioye
+ AI Fellow: Mohammad Sadat
+ Project Leads: Leisl Ethington, Christopher Seeger


## About the Project

In rural Midwestern communities, the presence of high-quality and affordable housing plays a crucial role in preserving a good quality of life and fostering the vitality of the region, particularly for individuals involved in agriculture. However, measuring the condition of housing in rural communities can be a complex and subjective task. To address these challenges, there is a pressing need for an Artificial Intelligence (AI) driven approach that can provide a more accurate and objective evaluation of housing quality, identify financing gaps, and optimize the allocation of local, state, and federal funds to maximize community benefits.

Utilizing web scraping techniques to collect images of houses from various assessor websites, an AI model can be developed to analyze and categorize housing features into good or poor quality. This can enable targeted investment strategies. It allows for the identification of houses in need of improvement and determines the areas where financial resources should be directed. By leveraging AI technology in this manner, the project seeks to streamline the housing evaluation process, eliminate subjective biases, and facilitate informed decision-making for housing investment and development initiatives in rural communities.

The goal of the project is to investigate the condition of existing housing stock in rural Midwestern communities and develop a thorough and objective evaluation of housing quality using AI.


## Housing Repository Folders

+ Web Scraping:
   - R code for scraping Zillow.com
   - Beacon sort (python image grabber)
   - Scraped Addresses
   - Scraped images
   - City address raw data
	- Files used to clean data for _complete links folder_
   - Complete links for Des Moines, Elkhart, Grundy, Independence, New Hampton, Ogden, and Slater Google API image collection
 
	- _We are only able to scrape _: This folder needs to be helped quite a bit. There are multiple R files which are able to scrape parts of Zillow but we were having issues that may only be fixed by building a spider to scrape. This is the only folder I would recommend reading through the code (it's not a lot or complex) or to try and redo this section in future DSPG tasks. Also contains images and info that we were able to scrape some of. GAVIN MAYBE TAKE THE IMAGES TAKEN SUCCESFULLY AND PUT INTO PROGRAM

winvest_sort:
	first there are the 3 csv files from the winvest project which have photo name and address columns. After downloading the images rename_winvest.py is able to read these csv files and rename each of the images to our naming convention of source_city_address_

+ Housing Databases
   - Attributes of addresses including predictions made by the AI models.
   - City sample files used for testing small amounts of data
  
+ Demographic Analysis:
	- Community profile datasets
	- Community summaries (Grundy Center, Independence, Hampton, and state of Iowa)
	- Profile plots


+ AI Models:
	folders that begin with model have an .h5 file which is a trained AI model plus the .ipynb file which is the code to train the model which can be opened in Google Colab.
	single_house_image_inputs and clear_images are test images.
	panda_data is images of pandas to test the class_activation_maps.py file. This file makes CAM images which shows what looks like a heatmap over an image to display what areas influence the AI's prediction most.
	PyTorch:
		.py code and .pth model which uses pytorch to try and replicate what is done in the class activation maps but with our own models and house images.
	cam_houses.py is my first attempt to do what is in the PyTorch folder, it does not work but may be helpful to look at while learning about these models.
	single_house_evaluator is the original python script to run all of the models, it has since been updated and split into city_evaluator.py and house_evaluator.py GAVIN DELETE THIS FILE IF WE HAVE ALL INFO
	city_evaluator.py will take a folder that stores city folders, inside the city folders are the addresses in that city as folders, inside of address folders are the images for that address which we collected. city_eval will then call house_evaluator.py which is explained next, house_eval returns each address assessed on the quality of gutter, vegetation, siding, and roofing according to our models. city_evaluator then prints all of these results to a csv on the correct address.
	house_evaluator.py takes an address folder as input. First it uses the models house_present, clear_image, and multiple_houses to try and select the best address for a house to be evaluated. If there is no good picture it will return with all the models as FALSE and 0% confidence. If there are multiple good images one will be randomly selected. The image is then assessed by our vegetation, gutter, roof, and siding models. house_evaluator returns all of the evaluations plus percent confidence on each evaluation.
	image_folder_sorter.py will take a folder of images with the naming convention of source_city_address_ and sort each image into the parent folder of images sorted by city then by address. This is neccesary for running city_evaluator.
	house_addributes_test.csv is simply just a testing csv file so that new features can be tested before used on one of the city databases.

test_images:
	there is a .txt file explaining what should be in this folder named test_cases but essentially this will contain multiple images to test various features of the program from functionality to model accuracy.

web scraping:
	This folder needs to be helped quite a bit. There are multiple R files which are able to scrape parts of Zillow but we were having issues that may only be fixed by building a spider to scrape. This is the only folder I would recommend reading through the code (it's not a lot or complex) or to try and redo this section in future DSPG tasks. Also contains images and info that we were able to scrape some of. GAVIN MAYBE TAKE THE IMAGES TAKEN SUCCESFULLY AND PUT INTO PROGRAM

winvest_sort:
	first there are the 3 csv files from the winvest project which have photo name and address columns. After downloading the images rename_winvest.py is able to read these csv files and rename each of the images to our naming convention of source_city_address_





   
To see more details about the content of each folder in the Housing repository, see the [folder content explanation file.]Housing/folder_contents.txt

## Presentation Blog

[Link to final presentation](https://morenikeope.github.io/Atejioye_Blog/posts/Report_Draft/Report_Draft.html).

## Links to Guides

+ Evaluating cities: https://gavinfishy.github.io/Gavin_DSPG_Blog/posts/Gavin-Fisher_guide_w7/full_guide.html
+ Mapping house quality of cities: https://1angelinaevans.github.io/AngelinaEvansBlog/posts/MappingHouseData/MappingHouseQuality.html

 
