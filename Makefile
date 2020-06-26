PORT := /dev/cu.usbserial-01DFA28F
BIN_PATH := ./output/mp.bin
BINARY := esp32-idf4-20191220-v1.12.bin


all: clean setup getbin erase flash repl

clean:
	rm -rf ./output

setup:
	pip3 install esptool
	mkdir ./output

getbin:
	curl -k -o ${BIN_PATH} https://micropython.org/resources/firmware/${BINARY}

erase:
	esptool.py --chip esp32 --port ${PORT} erase_flash

flash:
	esptool.py --chip esp32 --port ${PORT} write_flash -z 0x1000 ${BIN_PATH}

repl:
	rshell -a --buffer-size=30 --port=${PORT}