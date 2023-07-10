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
	- Code for training models
	- Test images
	- Images and code for testing Class Activation Maps (CAM)
	- PyTorch code for (CAM)
  	- Code for storing city addresses and images
   	- Code used to determine which image would be the best to use for evaluation
   	- Code for sorting images
  

+ WinVest:
  - Photo names and addresses from the WinVest project






   
To see more details about the content of each folder in the Housing repository, see the [folder content explanation file.]Housing/folder_contents.txt

## Presentation Blog

[Link to final presentation](https://morenikeope.github.io/Atejioye_Blog/posts/Report_Draft/Report_Draft.html).

## Links to Guides

+ Evaluating cities: https://gavinfishy.github.io/Gavin_DSPG_Blog/posts/Gavin-Fisher_guide_w7/full_guide.html
+ Mapping house quality of cities: https://1angelinaevans.github.io/AngelinaEvansBlog/posts/MappingHouseData/MappingHouseQuality.html

 
