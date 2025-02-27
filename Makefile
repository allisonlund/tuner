SV2V_ARGS := $(shell grep . rtl/rtl.f)

TOP := testbench

RTL := $(shell grep . rtl/rtl.f) #DO NOT ADD COMMENTS TO rtl.f


.PHONY: lint bitstream clean

# lint runs the Verilator linter on your code.
lint:
	verilator lint/verilator.vlt -f rtl/rtl.f --lint-only --top tuner

sim:
	verilator --trace-fst lint/verilator.vlt --Mdir ${TOP}_$@_dir -f rtl/rtl.f --binary -Wno-fatal --timescale 1ns/1ps --top ${TOP}
	./${TOP}_$@_dir/V${TOP} +verilator+rand+reset+2

program:
	iceprog synth/icestorm_icebreaker/build/icebreaker.bit


application:
	python3 util/application.py

bitstream: synth/icestorm_icebreaker/build/icebreaker.bit

# convert SystemVerilog to Verilog (sv2v)
synth/build/rtl.sv2v.v: ${RTL} rtl/rtl.f
	mkdir -p $(dir $@)
	sv2v ${SV2V_ARGS} -w $@ -DSYNTHESIS

# run Yosys synthesis and generate JSON netlist
synth/icestorm_icebreaker/build/synth.v synth/icestorm_icebreaker/build/synth.json: \
	synth/build/rtl.sv2v.v rtl/tuner/top.sv util/yosys.tcl
	mkdir -p $(dir $@)
	yosys -c util/yosys.tcl -l synth/icestorm_icebreaker/build/yosys.log

# place-and-route with nextpnr-ice40
synth/icestorm_icebreaker/build/icebreaker.asc: \
	synth/icestorm_icebreaker/build/synth.json rtl/tuner/icebreaker.pcf
	nextpnr-ice40 \
	 --json synth/icestorm_icebreaker/build/synth.json \
	 --up5k \
	 --package sg48 \
	 --pcf rtl/tuner/icebreaker.pcf \
	 --asc $@

# convert ASCII bitstream to binary format using icepack
synth/icestorm_icebreaker/build/icebreaker.bit: synth/icestorm_icebreaker/build/icebreaker.asc
	icepack $< $@


clean:
	 rm -rf \
	 *.memh *.memb \
	 *sim_dir *gls_dir \
	 dump.vcd dump.fst dump.fst.hier\
	 synth/build \
	 synth/yosys_generic/build 
