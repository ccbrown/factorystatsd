all: factorystatsd.zip

factorystatsd.zip: info.json data.lua control.lua forwarder.py $(shell find graphics -name '*.png') $(shell find prototypes -name '*.lua') $(shell find locale -name '*.cfg')
	zip $@ $^
