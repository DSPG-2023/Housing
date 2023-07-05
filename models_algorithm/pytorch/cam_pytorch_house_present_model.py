import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import models, transforms, datasets
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import os
import sklearn
from sklearn.model_selection import train_test_split


torch.manual_seed(42)

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

data_path = os.path.expanduser("~/Documents/present_data")
dataset = datasets.ImageFolder(root=data_path, transform=transform)
train_ratio = 0.8  
val_ratio = 0.1    
test_ratio = 0.1   
train_data, test_data = train_test_split(dataset, test_size=test_ratio, random_state=42)
train_data, val_data = train_test_split(train_data, test_size=val_ratio/(1-test_ratio), random_state=42)

batch_size = 32
train_loader = DataLoader(train_data, batch_size=batch_size, shuffle=True)
val_loader = DataLoader(val_data, batch_size=batch_size)
test_loader = DataLoader(test_data, batch_size=batch_size)

class HousePresenceModel(nn.Module):
    def __init__(self):
        super(HousePresenceModel, self).__init__()
        
        self.conv_layers = nn.Sequential(
            nn.Conv2d(3, 16, kernel_size=3, stride=1, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(16, 32, kernel_size=3, stride=1, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Conv2d(32, 64, kernel_size=3, stride=1, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )
        
        self.fc_layers = nn.Sequential(
            nn.Linear(64 * 28 * 28, 128),
            nn.ReLU(),
            nn.Linear(128, 1),
            nn.Sigmoid()
        )
        
    def forward(self, x):
        x = self.conv_layers(x)
        x = x.view(x.size(0), -1)
        x = self.fc_layers(x)
        return x

model = HousePresenceModel().to(device)
criterion = nn.BCELoss()
optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

num_epochs = 10

for epoch in range(num_epochs):
    # Training
    model.train()
    train_loss = 0.0
    
    for images, labels in train_loader:
        images = images.to(device)
        labels = labels.float().unsqueeze(1).to(device)
        
        optimizer.zero_grad()
        
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        
        train_loss += loss.item() * images.size(0)
    
    # Validation
    model.eval()
    val_loss = 0.0
    correct = 0
    
    with torch.no_grad():
        for images, labels in val_loader:
            images = images.to(device)
            labels = labels.float().unsqueeze(1).to(device)
            
            outputs = model(images)
            val_loss += criterion(outputs, labels).item() * images.size(0)
            
            predictions = torch.round(outputs)
            correct += (predictions == labels).sum().item()
    
    # avg loss and accuracy
    train_loss /= len(train_data)
    val_loss /= len(val_data)
    accuracy = correct / len(val_data)
    
    print(f'Epoch {epoch+1}/{num_epochs}')
    print(f'Training Loss: {train_loss:.4f}')
    print(f'Validation Loss: {val_loss:.4f}')
    print(f'Validation Accuracy: {accuracy:.4f}')
    print('-' * 20)

model.eval()
test_loss = 0.0
correct = 0

with torch.no_grad():
    for images, labels in test_loader:
        images = images.to(device)
        labels = labels.float().unsqueeze(1).to(device)

        outputs = model(images)
        test_loss += criterion(outputs, labels).item() * images.size(0)

        predictions = torch.round(outputs)
        correct += (predictions == labels).sum().item()

test_loss /= len(test_data)
accuracy = correct / len(test_data)

print(f'Test Loss: {test_loss:.4f}')
print(f'Test Accuracy: {accuracy:.4f}')

torch.save(model.state_dict(), 'cam_house_presence_model.pth')





# CAM

model = HousePresenceModel()
model.load_state_dict(torch.load('cam_house_presence_model.pth'))
model.to(device)
model.eval()

class HousePresenceModelWithCAM(nn.Module):
    def __init__(self, model):
        super(HousePresenceModelWithCAM, self).__init__()
        self.conv_layers = model.conv_layers
        self.fc_layers = model.fc_layers
        
        self.feature_maps = None
        self.gradients = None
        
    def forward(self, x):
        x = self.conv_layers(x)
        
        self.feature_maps = x.clone().detach() 
        x.register_hook(self.save_gradients)  
        
        x = x.view(x.size(0), -1)
        x = self.fc_layers(x)
        
        return x
    
    def save_gradients(self, grad):
        self.gradients = grad.clone().detach()  

model_with_cam = HousePresenceModelWithCAM(model)
model_with_cam.to(device)
model_with_cam.eval()

image_path = os.path.expanduser('~/Documents/test_images/G_D_40 10TH ST NE_.png')
# image_path = os.path.expanduser('~/Documents/test_images/G_OG_119 E SYCAMORE ST_.png')

image = Image.open(image_path).convert('RGB')
image_tensor = transform(image).unsqueeze(0).to(device)
output = model_with_cam(image_tensor)

one_hot = torch.zeros_like(output)
one_hot[:, 0] = 1  
one_hot = one_hot.to(device)

model_with_cam.zero_grad()
output.backward(gradient=one_hot, retain_graph=True)

cam = torch.mean(model_with_cam.gradients, dim=1, keepdim=True)
cam = torch.relu(cam)

cam = F.interpolate(cam, size=image.size, mode='bilinear', align_corners=False)
cam = cam - cam.min()
cam = cam / cam.max()
cam = cam.squeeze().cpu().numpy()


_, predicted_class = torch.max(output, 1)
predicted_label = 'house_present' if predicted_class.item() == 0 else 'no_house_present'

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 5))
ax1.imshow(image)
ax1.axis('off')
ax1.set_title('Image')
ax2.imshow(image)
ax2.imshow(cam, cmap='jet', alpha=0.5)
ax2.axis('off')
ax2.set_title(f'{predicted_label}')
plt.tight_layout()
plt.show()








