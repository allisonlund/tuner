
yosys -import

read_verilog -sv synth/build/rtl.sv2v.v rtl/tuner/top.sv

synth_ice40 -top top -dsp

write_verilog -noexpr -noattr -simple-lhs synth/icestorm_icebreaker/build/synth.v
write_json synth/icestorm_icebreaker/build/synth.json
