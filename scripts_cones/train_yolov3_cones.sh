#!/bin/bash
TRAINING_START=$(date +%Y%m%d_%H%M%S)
DARKNET_DIR=$PWD/..

# check if study name is provided
if [ "$1" != "" ]; then
    echo "Starting training for ${1}"
else
    echo "Missing input argument."
    echo "usage: ./train_yolov3_cones.sh study_name"
    exit 1
fi

mkdir -p /work/dataset/training_logs
cd /work/dataset/training_logs

# Define and create directory where the logs will be stored
LOG_NAME="${TRAINING_START}_yolov3_${1}"
LOG_ROOT="/work/dataset/training_logs"
LOG_DIR="${LOG_ROOT}/${LOG_NAME}"
mkdir $LOG_DIR

# ------ DEFINE AND CHANGE TRAINING INPUT HERE -------
CFG_FILE="${DARKNET_DIR}/cfg_cones/yolov3_cones.cfg"
DATA_FILE="${DARKNET_DIR}/data_cones/cones.data"
NAMES_FILE="${DARKNET_DIR}/data_cones/cones.names"
TRAIN_LIST="${DARKNET_DIR}/data_cones/train.txt"
VALID_LIST="${DARKNET_DIR}/data_cones/valid.txt"
WEIGHTS="${DARKNET_DIR}/weights/darknet53.conv.74"
# ----------------------------------------------------

# Copy over the files for logging and backup purposes
cp $CFG_FILE $LOG_DIR
cp $DATA_FILE $LOG_DIR
cp $NAMES_FILE $LOG_DIR
cp $TRAIN_LIST $LOG_DIR
cp $VALID_LIST $LOG_DIR

LOG_FILE="${LOG_DIR}/log.txt"

# Begin training
cd $DARKNET_DIR
./darknet detector train $DATA_FILE $CFG_FILE $WEIGHTS -map 2>&1 | tee $LOG_FILE