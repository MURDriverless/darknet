#!/bin/bash

# This script downloads the required training dataset and pretrained weights
# for training a traffic cone detector
#
# Assume to have:
#   /work/darknet
#   /work/dataset/YoloColorParse_Data/
#   /work/dataset/YOLO_Dataset.zip (which will be unzipped)
# Then the image labels will be moved into the 
# same directory as the images

echo "Starting dataset setup..."

cd /work/
mkdir -p /work/dataset

# clone image labels
git clone https://github.com/MURDriverless/YoloColorParse_Data ./dataset/YoloColorParse_Data

# remove false positive image labels from text files
git clone https://github.com/MURDriverless/perception-scripts ./dataset/perception-scripts
python3 ./dataset/perception-scripts/training_scripts/dataset_cleanup.py ./dataset/YoloColorParse_Data/frames/

# download image data
gsutil cp -n -p gs://mit-driverless-open-source/YOLO_Dataset.zip ./dataset/

# unzip the image data
unzip ./dataset/YOLO_Dataset.zip -d ./dataset/

# move image labels to image data location
cp ./dataset/YoloColorParse_Data/frames/*.txt ./dataset/YOLO_Dataset

# download pretrained weights for yolov3 and yolov4
mkdir -p /work/darknet/weights
cd /work/darknet/weights

wget -N https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137
wget -N https://pjreddie.com/media/files/darknet53.conv.74

echo "Finished dataset and pretrained weights setup."