# FPGA Tuner for iCEBreaker

## Overview
This project implements a real-time tuner on the iCEBreaker FPGA board and a GUI dispaly of the input frequency (A4-G4). It processes audio input, extracts frequency components, and provides tuning feedback. The design is optimized for efficient DSP utilization and the reduction of long logical paths.


## Hardware Requirements
- **iCEBreaker FPGA Board**
- **Electret microphone module** (or external audio input)
- **PC for synthesis and programming**
- **USB to UART adapter** (optional, for debugging)

## Toolchain
- **Yosys** (for synthesis)
- **nextpnr-ice40** (for place-and-route)
- **icestorm** (for bitstream generation)
- **Verilog** (hardware description)

## Usage
- **make bitstream** (to generate the .bit file)
- **make program** (to program the FPGA)
- **make application** (to start the GUI)
