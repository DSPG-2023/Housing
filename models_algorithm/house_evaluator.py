# note: when installing these in terminal I had to say py instead of python
import cv2
import os

image_folder = "~/Housing/models_algorithm/single_house_image_inputs"

image_files = [os.path.join(image_folder, file) for file in os.listdir(image_folder) if file.endswith('png', 'jpg', 'jpeg')]

google_img = None
zillow_img = None
vanguard_img = None
beacon_img = None
other_img = None

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


