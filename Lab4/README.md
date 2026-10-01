# ECE 3300L — Lab 4: Registers

## Overview

This lab introduces two practical register-based circuits: a generic register file and an accumulator. Both are implemented in Verilog and tested on a Nexys A7-100T FPGA board.

## Part 1 — Register File

A parameterized dual-port register file (`reg_file`) with parameters `N` (address width) and `BITS` (word width), containing 2^N registers of BITS bits each.

- **Write port** — addressed via `decoder_generic.v`; write enable (`WE`) feeds the decoder's enable pin directly
- **Read port** — addressed via a second `decoder_generic.v`; selected register drives output through a tri-state bus (synthesized as a MUX tree on FPGA)

### FPGA Application — `reg_file_application`

Instantiates a 128 × 4-bit register file (N=7, BITS=4).

| Board Signal | Function |
|---|---|
| SW3–SW0 | Write data (`data_w`) |
| SW10–SW4 | Shared address bus (demuxed by SW15) |
| SW15 | 0 = write address on SW10–SW4 / 1 = read address on SW10–SW4 |
| Down pushbutton (BTND) | Write enable (`WE`), debounced to a single-cycle pulse |
| 7-segment digit 0 | Read data output (`data_r`) |

> **Note**: SW8 and SW9 are on voltage bank 34 and require `LVCMOS18` in the constraints file. All other I/O uses `LVCMOS33`.

## Part 2 — Accumulator

A 4-bit accumulator (`accumulator`) that stores a running total. On each `load` pulse:

Q ← Q + X    (SW15 = 0)
Q ← Q − X    (SW15 = 1)

Built structurally using the provided `adder_subtractor.v`. Uses a two-always-block register style with separate `Q_reg`/`Q_next` signals.

### FPGA Application — `accumulator_application`

| Board Signal | Function |
|---|---|
| SW3–SW0 | Operand X |
| SW15 | 0 = add / 1 = subtract |
| Down pushbutton (BTND) | Load pulse (debounced through `button.v`) |
| CPU_RESETN | Synchronous reset — clears Q to 0 (active-low, hold to stay in reset) |
| 7-segment digit 0 | Accumulator output Q |

> **Note**: `CPU_RESETN` is connected directly (bypasses `button.v`) because the Nexys A7 board hardware-debounces that button, and reset must be level-sensitive rather than edge-triggered.

## Provided Modules Used

| File | Purpose |
|---|---|
| `simple_register_load.v` | Single register with synchronous load enable |
| `decoder_generic.v` | Parameterized N-to-2^N binary decoder |
| `adder_subtractor.v` | N-bit adder/subtractor (port: `add_n`, 0=add, 1=subtract) |
| `button.v` | Synchronizer + debouncer + edge detector → single-cycle pulse |
| `hex2sseg.v` | Hex digit to 7-segment encoding |

## Vivado Notes

- When switching between Part 1 and Part 2, right-click the correct top-level module in the Sources panel and select **Set as Top** before running synthesis. Forgetting this causes a misleading `set_property expects at least one object` error on the first switch constraint line.
- Port names in the XDC constraints file are case-sensitive and must exactly match the Verilog port names (e.g., `output DP` requires `[get_ports { DP }]`).

## Hardware

- **Board**: Digilent Nexys A7-100T
- **FPGA**: Xilinx Artix-7 XC7A100T
- **Clock**: 100 MHz system clock (E3, LVCMOS33)