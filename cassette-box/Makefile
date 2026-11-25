OPENSCAD ?= openscad
SHELL := /bin/bash
CAMERA = 0,0,0,65,0,25,180

.PHONY: all
all: cassette-box.stl cassette-box-closed.stl cassette-box.jpg cassette-box-closed.jpg \
	cassette-box-example.stl cassette-box-example-closed.stl \
	cassette-box-example.jpg cassette-box-example-closed.jpg

cassette-box.stl cassette-box.jpg cassette-box-example.stl cassette-box-example.jpg: LAYOUT = flat
cassette-box-closed.stl cassette-box-closed.jpg cassette-box-example-closed.stl cassette-box-example-closed.jpg: LAYOUT = closed

cassette-box-example.stl cassette-box-example-closed.stl cassette-box-example.jpg cassette-box-example-closed.jpg: EXAMPLE = \
	-D 'front_text="fall 2026 mixy"' -D 'front_text_size=11.64' \
	-D 'back_text="3dwardsharp"' -D 'back_text_size=12.29' \
	-D 'spine_text="fall mixy"' -D 'spine_text_right="2026"' -D 'spine_text_size=6.44'
cassette-box-example.jpg: CAMERA = 0,0,0,245,0,25,180

%.stl: cassette-box.scad Makefile
	"$(OPENSCAD)" -D 'layout="$(LAYOUT)"' $(EXAMPLE) -o "$@" "$<"

%.jpg: cassette-box.scad Makefile
	set -o pipefail; "$(OPENSCAD)" --render --colorscheme=Starnight --imgsize=1600,1200 \
		--camera=$(CAMERA) --autocenter --viewall --projection=o \
		-D 'layout="$(LAYOUT)"' $(EXAMPLE) --export-format=png -o - "$<" | \
		magick png:- -colorspace gray -colorspace sRGB -channel G -evaluate set 0 +channel -quality 95 "$@"
