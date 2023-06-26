import numpy as np
import tensorflow as tf
import cv2
import matplotlib.pyplot as plt
import os
from keras.models import load_model

# Load the trained model
model = load_model(os.path.join('model_house_present', 'house_present_classifier.h5'))

# Get the last convolutional layer
last_conv_layer = model.get_layer('conv2d_2')

# Extract the weights from the final dense layer
weights = model.get_layer('dense_1').get_weights()[0].reshape((-1))

# Create a new model without the final dense layer
cam_model = tf.keras.models.Model(inputs=model.input, outputs=(last_conv_layer.output, model.output))

# Load and preprocess the image
image_path = 'no_veg_test.png'
image = tf.keras.preprocessing.image.load_img(image_path, target_size=(256, 256))
input_image = tf.keras.preprocessing.image.img_to_array(image)
input_image = np.expand_dims(input_image, axis=0)
input_image = input_image / 255.0  # Normalize the image

# Generate the class activation map
features, results = cam_model.predict(input_image)
class_idx = np.argmax(results[0])
weights_for_class = weights[:, class_idx]

# Flatten the last convolutional layer's output
flatten_features = np.reshape(features, (features.shape[0], -1))

# Calculate the class activation map
cam = np.dot(flatten_features, weights_for_class.T)

# Reshape the CAM to match the original image size
reshaped_cam = np.reshape(cam, (image.height, image.width))
normalized_cam = (reshaped_cam - np.min(reshaped_cam)) / (np.max(reshaped_cam) - np.min(reshaped_cam))

# Apply colormap to the CAM
heatmap = cv2.applyColorMap(np.uint8(255 * normalized_cam), cv2.COLORMAP_JET)

# Overlay the heatmap on the original image
overlayed_image = cv2.cvtColor(cv2.imread(image_path), cv2.COLOR_BGR2RGB)
overlayed_image = cv2.addWeighted(overlayed_image, 0.7, heatmap, 0.3, 0)

# Display the CAM and overlayed image
plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.imshow(normalized_cam, cmap='jet')
plt.title('Class Activation Map')
plt.subplot(1, 2, 2)
plt.imshow(overlayed_image)
plt.title('Original Image with CAM Overlay')
plt.tight_layout()
plt.show()