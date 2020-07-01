PORT := /dev/cu.usbserial-01DFA28F
BIN_PATH := ./output/mp.bin
BINARY := esp32-idf4-20200625-unstable-v1.12-576-g76faeed09.bin
# esp32-idf4-20191220-v1.12.bin
ESPIDF_HASH := 4c81978a3e2220674a432a588292a4c860eef27b
MAKE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

all: clean setup getbin erase flash deploy repl

clean:
	rm -rf ./output

setup:
	pip3 install esptool
	pip3 install rshell
	pip3 install adafruit-ampy
	mkdir ./output

getbin:
	curl -k -o ${BIN_PATH} https://micropython.org/resources/firmware/${BINARY}

erase:
	esptool.py --chip esp32 --port ${PORT} erase_flash

flash:
	esptool.py --chip esp32 --port ${PORT} write_flash -z 0x1000 ${BIN_PATH}

repl:
	rshell -a --buffer-size=30 --port=${PORT}

undeploy:
	ampy -p ${PORT} rmdir /

deploy:
	ampy -p ${PORT} put ./src /
	ampy -p ${PORT} put ./src/config.py /config.py
	ampy -p ${PORT} put ./src/connect.py /connect.py
	ampy -p ${PORT} put ./src/start.py /start.py

workflow: deploy repl

try:
	cd ./scripts \
	&& source ./build.sh 4c81978a3e2220674a432a588292a4c860eef27b

get.source:
	rm -rf ./output \
	&& mkdir ./output \
	&& cd ./output \
	&& git clone --depth 1 https://github.com/micropython/micropython.git \
	&& cd ./micropython/mpy-cross \
	&& make \
	&& cd .. \
	&& cd ./ports/esp32 \
	&& git submodule update --init \
	&& cd ../../../ \
	&& git clone https://github.com/espressif/esp-idf.git \
	&& cd ./esp-idf \
	&& git checkout ${ESPIDF_HASH} \
	&& git submodule update --init --recursive




