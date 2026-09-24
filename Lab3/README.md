# ECE 3300L — Lab 3: Combinational-Circuit Building Blocks

## Overview

This lab implements and integrates four reusable combinational building blocks — a priority encoder, a hex-to-seven-segment converter, a decoder, and a multiplexer — on the Nexys A7-100T FPGA. The lab is divided into three parts, each building on the previous.

---

## Provided Modules

| Module | Description |
|---|---|
| `priority_encoder_generic.v` | Parameterized N-input priority encoder; outputs binary index of highest active input |
| `hex2sseg.v` | Converts a 4-bit hex value (0–F) to a 7-bit active-low segment pattern (gfedcba) |
| `mux_4x1_nbit.v` | Parameterized N-bit wide 4×1 multiplexer |
| `decoder_generic.v` | Parameterized N-to-2ⁿ binary decoder with enable |

---

## Part 1 — Priority Encoder Display

**Top-level:** `prior_encoder_test.v`

Reads 16 switches through a 16-input priority encoder and displays the binary index of the highest active switch on a single seven-segment digit.

### Design Hierarchy
prior_encoder_test
├── priority_encoder_generic  (N=16)
└── hex2sseg

### IO Specification

| Signal | Board I/O |
|---|---|
| SW15–SW0 | 16 encoder inputs (SW15 = highest priority) |
| sseg | Seven-segment cathodes (digit 0) |
| AN | Digit 0 active (`8'b11111110`) |
| DP | Off |

### Expected Behavior
Flip any switch — the display shows the hex index of the highest active switch. For example, if SW12 is the highest active switch, the display shows `C`.

---

## Part 2 — Rudimentary Seven-Segment Display Driver

**Modules:** `first_sseg_driver.v`, `first_sseg_driver_test.v`

A reusable driver module that combines `decoder_generic` and `hex2sseg` to activate any one of the eight seven-segment digits and display a 4-bit value on it.

### `first_sseg_driver` Interface

| Port | Direction | Description |
|---|---|---|
| `active_digit[2:0]` | Input | Selects which of 8 digits to activate (0–7) |
| `num[3:0]` | Input | Hex value to display |
| `DP_ctrl` | Input | Decimal point on/off |
| `sseg[6:0]` | Output | Segment cathodes (active-low) |
| `AN[7:0]` | Output | Anode select (active-low) |
| `DP` | Output | Decimal point (active-low) |

### Design Hierarchy
first_sseg_driver_test
└── first_sseg_driver
    ├── decoder_generic  (N=3, selects digit)
    └── hex2sseg         (drives segments)

### Test System IO

| Signal | Board I/O |
|---|---|
| X[2:0] | SW2–SW0 |
| sseg, AN, DP | Seven-segment display |

### Expected Behavior
As SW2–SW0 increments from 0 to 7, each digit activates in sequence and shows its own position number.

---

## Part 3 — Simple Calculator with BCD Display

**Top-level:** `simple_calc_first_sseg.v`

Integrates the Lab 1/2 calculator with the seven-segment driver to display the BCD result across three digits.

### Design Hierarchy
simple_calc_first_sseg
├── simple_calc       (4-bit add/subtract/multiply)
├── bin2bcd           (8-bit binary → 12-bit BCD)
├── mux_4x1_nbit      (N=4, selects one BCD digit)
└── first_sseg_driver (drives selected digit)

### IO Specification

| Signal | Board I/O | Description |
|---|---|---|
| X[3:0] | SW3–SW0 | Operand X |
| Y[3:0] | SW7–SW4 | Operand Y |
| digit_sel[1:0] | SW9–SW8 | Selects which BCD digit to view |
| op_sel[1:0] | SW15–SW14 | Operation select |
| sseg, AN, DP | Seven-Segment 4–6 | BCD result display |
| carry_out | LED14 | Carry/borrow output |
| overflow | LED15 | Overflow flag |

### Operation Select

| op_sel | Operation |
|---|---|
| 2'b00 | Add |
| 2'b01 | Subtract |
| 2'b1x | Multiply |

### Digit Select

| SW9–SW8 | Digit | BCD Field |
|---|---|---|
| 00 | 4 | Hundreds |
| 01 | 5 | Tens |
| 10 | 6 | Ones |
| 11 | 7 | Blank |

### Expected Behavior
Set X and Y with the switches and select an operation. Use SW9–SW8 to scroll through the hundreds, tens, and ones digits of the BCD result displayed on the seven-segment display.

---

## Board

Digilent Nexys A7-100T