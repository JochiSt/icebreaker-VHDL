
PROJECT=PLLtest
CONSTRAINT=../icebreaker.pcf

TOP_MODULE=PLLtest

OBJECT_FILES=PLLtest.o LEDblink.o

GHDL_OPTIONS=--latches

###############################################################################

.PHONY: all prog clean total_clean postsim sim

.SECONDARY: $(PROJECT).bin $(PROJECT)_tb

all: $(PROJECT).rpt $(PROJECT).bin

# Program FPGA
prog: $(PROJECT).bin
	iceprog $<

###############################################################################
# CLEANING
clean:
	rm -f *.o *.cf

total_clean: clean
	rm $(PROJECT).{asc,bin,rpt,json}

###############################################################################
# Synthesis

$(PROJECT).json: $(OBJECT_FILES)
	yosys -m ghdl -p 'ghdl $(GHDL_OPTIONS) $(TOP_MODULE); synth_ice40 -json $@'

# Place and Route
$(PROJECT).asc: $(PROJECT).json $(CONSTRAINT)
	nextpnr-ice40 --up5k --package sg48 --pcf $(CONSTRAINT) --freq 12 --asc $@ \
		--json $< --placed-svg $(PROJECT)_placed.svg --routed-svg $(PROJECT)_routed.svg \
		--report $(PROJECT)_report.json

$(PROJECT).bin: $(PROJECT).asc
	icepack $< $@

$(PROJECT).rpt: $(PROJECT).asc
	icetime -d up5k -c 12 -mtr $@ $<

###############################################################################

sim: $(PROJECT)_tb.vcd

#%_tb: %_tb.v %.v
#	iverilog -o $@ $^
#
#%_tb.vcd: %_tb
#	vvp -N $< +vcd=$@

%_tb.cpp: %_tb.v $(OBJECT_FILES)
	yosys -m ghdl -p "read_verilog -sv $<; \
			ghdl $(GHDL_OPTIONS) $(TOP_MODULE); \
			hierarchy -check -top testbench; \
			write_cxxrtl -header $@"
	sed -i '1s/^/#include <iostream>\n/' $@

%_tb: %_tb.cpp %_tb_main.cpp
	g++-9 -g -O3 -I`yosys-config --datdir`/include -DEXAMPLE_TOP=\"$<\" -std=c++14 $^ -o $@

%_tb.vcd: %_tb
	./$< 2 $@

# POST synthesis simulation
# inspired and adapted
# 		from https://github.com/YosysHQ/icestorm/blob/master/examples/icestick/
postsim: $(PROJECT)_syntb.vcd

# create VERILOG file from synthesized JSON design file
%_syn.v: %.json
	yosys -p 'read_json $^; write_verilog $@'
# create syntb using iverilog
%_syntb: %_tb.v %_syn.v
	iverilog -g2012 -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`
# simulate the design
%_syntb.vcd: %_syntb
	vvp -v -n $< +vcd=$@

###############################################################################
# 'compile' VHDL files

%.o: %.vhdl
	ghdl -a $<

