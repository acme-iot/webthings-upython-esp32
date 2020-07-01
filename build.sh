#!/usr/bin/bash

cd ./output
OUTPUT_DIR=$PWD
ESP32_DIR=$PWD/micropython/ports/esp32
IDF_PATH=$PWD/esp-idf

# install dependencies
cd $IDF_PATH
pip install -r ./requirements.txt

# build toolchain
./install.sh

export IDF_PATH=$IDF_PATH
echo $IDF_PATH

cd $ESP32_DIR
source $IDF_PATH/export.sh

#git submodule update --init
make submodules PYTHON=python3
make PYTHON=python3

#cd $OUTPUT_DIR/..