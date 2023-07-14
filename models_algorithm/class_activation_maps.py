# CAM just made for testing the concept

from __future__ import print_function, division
from builtins import range, input
from keras.models import Model
from keras.applications.resnet import ResNet50, preprocess_input, decode_predictions
from keras.preprocessing import image
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
from glob import glob
from PIL import Image

# image_files = glob('../models_algorithm/panda_data/*')
image_files = glob('../models_algorithm/single_house_image_inputs/*')

# print(len(image_files))

# keras.preprocessing image does not seem do be loading in so I used PIL instead
plt.imshow(Image.open(np.random.choice(image_files)))
plt.show()

# prebuilt model using imagenet dataset
resnet = ResNet50(input_shape = (224, 224, 3), weights = 'imagenet', include_top = True)
resnet.summary()
# last activation layer
activation_layer = resnet.get_layer('conv5_block3_out') 
model = Model(inputs = resnet.input, outputs = activation_layer.output)
# last dense layer
final_dense = resnet.get_layer('predictions') 
W = final_dense.get_weights()[0]

while True:
    img = np.array(Image.open(np.random.choice(image_files)).resize((224, 224)))
    x  = preprocess_input(np.expand_dims(img, 0))
    fmaps = model.predict(x)[0]

    probs = resnet.predict(x)
    classnames = decode_predictions(probs)[0]
    print(classnames)
    classname = classnames[0][1]
    pred = np.argmax(probs[0])

    w = W[:, pred]

    cam = fmaps.dot(w)

    cam = sp.ndimage.zoom(cam, (32, 32), order = 1)

    plt.subplot(1, 2, 1)
    plt.imshow(img, alpha = 0.8)
    plt.imshow(cam, cmap = 'jet', alpha = 0.5)
    plt.subplot(1, 2, 2)
    plt.imshow(img)
    plt.title(classname)
    plt.show()

    ans = input("Continue? (Y/n)")
    if ans and ans[0].lower() == 'n':
        break
