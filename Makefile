PORT := /dev/cu.usbserial-01DFA28F
ESPIDF_HASH := 4c81978a3e2220674a432a588292a4c860eef27b


all: clean setup erase flash deploy repl

clean:
	rm -rf ./output

setup:
	pip3 install esptool
	pip3 install rshell
	pip3 install adafruit-ampy
	mkdir ./output

repl:
	rshell -a --buffer-size=30 --port=${PORT}

undeploy:
	ampy -p ${PORT} rmdir /

deploy:
	ampy -p ${PORT} put ./src/upy /upy
	ampy -p ${PORT} put ./src/web /web
	ampy -p ${PORT} put ./src/webthing /webthing
	ampy -p ${PORT} put ./src/example /example
	ampy -p ${PORT} put ./src/config.py config.py
	ampy -p ${PORT} put ./src/connect.py connect.py
	ampy -p ${PORT} put ./src/start.py start.py

workflow: deploy repl

erase:
	#esptool.py --chip esp32 --port ${PORT} erase_flash
	cd ./output/micropython/ports/esp32/ \
	&& make erase PYTHON=python3 PORT=${PORT}

flash:
	#esptool.py --chip esp32 --port ${PORT} write_flash -z 0x1000 ${BIN_PATH}
	cd ./output/micropython/ports/esp32/ \
	&& make deploy PYTHON=python3 PORT=${PORT}

get.source: clean
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
