#!/usr/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: build.sh espidf_hash
    exit 1
fi

espidf_hash=$1

cd ../
rm -rf ./output
mkdir ./output
cd ./output
OUTPUT_DIR=$PWD

# download upy & esp idf
rm -rf micropython
git clone --depth 1 https://github.com/micropython/micropython.git
cd ./micropython/mpy-cross
make
cd ..
cd ./ports/esp32
ESP32_DIR=$PWD

export ESPIDF=$OUTPUT_DIR/esp-idf
mkdir -p $ESPIDF
cd $ESPIDF
git clone https://github.com/espressif/esp-idf.git $ESPIDF
git checkout $espidf_hash
git submodule update --init --recursive

# install dependencies
cd $ESPIDF
pip install --upgrade pip
pip install -r ./requirements.txt

# build toolchain
./install.sh
export IDF_PATH=$PWD
cd $ESP32_DIR
$ESPIDF/export.sh


git submodule update --init
make submodules PYTHON=python3
make PYTHON=python3