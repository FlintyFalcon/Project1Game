FLEX_SDK = ~/flexsdk
ADL = $(FLEX_SDK)/bin/adl
AMXMLC = $(FLEX_SDK)/bin/amxmlc
SOURCES = src/*.hx assets/load.png

all: game.swf

game.swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 1280:800:60:ffffff \
	-main Startup \
	-swf game.swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/patch.txt')"

clean:
	rm -rf game.swf *~ src/*~

test: game.swf
	$(ADL) -profile tv game.xml
