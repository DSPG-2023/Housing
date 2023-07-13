# AI-Driven Housing Evaluation for Rural Community Development


<img src="Housing_Cover_Photo.jpg" alt="Housing cover photo" style="width:800px;" class="center"/>



## About the Project

Crucial to Midwestern rural vitality is a supply of good quality housing for residents of all ages and income levels. Crucial to effective rural housing policy development is a supply of good quality data describing local housing conditions.

Ideally, communities would have ready access to information about their local housing stock to identify needs, set priorities, and optimize allocation of resources and investments. Unfortunately, many small communities lack the capacity to systematically evaluate their housing stock.

City and county property assessors' offices seem a logical source for obtaining local housing data; however, tapping into these assessor databases poses some challenges. Access to a community's full database may be restricted, as most city and county assessors now outsource data management to private firms. Even when accessible, the database may not be amenable to custom tabulations and targeted queries about specific housing conditions. In addition, the subjectivity of the assessment process introduces biases and inconsistences into the data themselves.

Data science approaches including Artificial Intelligence (AI) models offer great potential for addressing these and other housing data challenges encountered by rural communities and researchers who study them. For example, image classification models could be used to rate the condition of selected exterior housing features, such as roof and siding, or to detect the presence of problems such as missing or damaged gutters or an overgrown landscape. Leveraging AI technology in this manner could streamline the housing evaluation process, eliminate subjective biases, and facilitate informed decision-making for housing investment and development initiatives in rural communities.

The goal of this project is to investigate methods for conducting a thorough and objective evaluation of a community's housing stock using AI, and also to explore how such methods could be adapted for multi-community analysis of relationships between housing quality and other local attributes in rural areas.


## Presentation Blog

[Link to final presentation](https://morenikeope.github.io/Atejioye_Blog/posts/Report_Draft/Report_Draft.html).

## Links to Guides


+ Evaluating cities: https://gavinfishy.github.io/Gavin_DSPG_Blog/posts/Gavin-Fisher_guide_w7/full_guide.html
+ Mapping house quality of cities: https://1angelinaevans.github.io/AngelinaEvansBlog/posts/MappingHouseData/MappingHouseQuality.html
+ Guide to AI models: https://gavinfishy.github.io/Gavin_DSPG_Blog/posts/Gavin-Fisher_AI_guide_w9/AI_guide.html



## Folders in Housing Repository

Listed below are some of the main contents from the housing repository. To see more details about the content of each folder in the Housing repository, see the [folder content explanation file.](folder_contents.txt)

+ Web Scraping:
   - R code for scraping Zillow.com
   - Beacon sort (python image grabber)
   - Scraped Addresses
   - Scraped images
   - City address raw data
	- Files used to clean data for _complete links folder_
   - Complete links for Des Moines, Elkhart, Grundy, Independence, New Hampton, Ogden, and Slater Google API image collection

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

 
