
PROJECT=PLLtest
CONSTRAINT=../icebreaker.pcf

TOP_MODULE=PLLtest

OBJECT_FILES=PLLtest.o LEDblink.o

GHDL_OPTIONS=--latches

###############################################################################

all: $(PROJECT).rpt $(PROJECT).bin

prog: $(PROJECT).bin
	iceprog $<

clean:
	rm -f *.o *.cf

total_clean: clean
	rm $(PROJECT).{asc,bin,rpt,json}

###############################################################################

$(PROJECT).json: $(OBJECT_FILES)
	yosys -m ghdl -p 'ghdl $(GHDL_OPTIONS) $(TOP_MODULE); synth_ice40 -json $@'

$(PROJECT).asc: $(PROJECT).json $(CONSTRAINT)
	nextpnr-ice40 --up5k --package sg48 --pcf $(CONSTRAINT) --freq 12 --asc $@ \
		--json $< --placed-svg $(PROJECT)_placed.svg --routed-svg $(PROJECT)_routed.svg \
		--report $(PROJECT)_report.json

$(PROJECT).bin: $(PROJECT).asc
	icepack $< $@

$(PROJECT).rpt: $(PROJECT).asc
	icetime -d up5k -c 12 -mtr $@ $<

###############################################################################

%.o: %.vhdl
	ghdl -a $<

