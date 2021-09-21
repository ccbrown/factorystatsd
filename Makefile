all: factorystatsd.zip

.PHONY: clean

clean:
	rm -f factorystatsd.zip

factorystatsd.zip: thumbnail.png info.json data.lua control.lua forwarder.py $(shell find graphics -name '*.png') $(shell find prototypes -name '*.lua') $(shell find locale -name '*.cfg')
	rm -rf factorystatsd
	mkdir factorystatsd
	rsync -R $^ factorystatsd
	zip -r $@ factorystatsd
	rm -r factorystatsd
