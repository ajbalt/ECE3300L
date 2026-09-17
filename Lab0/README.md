# ECE3200L Lab 0 — Switches, LEDs, and Multiplexers

**Board**: Nexys A7-100T | **Tool**: Vivado | **Language**: Verilog

---

## Objective

Describe a 2x1 multiplexer in Verilog three different ways, widen it to 3 bits by reusing it, then reuse that 3-bit module to build a 3-bit 4x1 multiplexer — running the full Vivado flow for the first time: code → synthesize → implement → bitstream → program the board.

---

## File List

| File | Description |
|------|-------------|
| `mux_2x1_struct.v` | 1-bit 2x1 MUX — structural style using gate primitives |
| `mux_2x1_simple.v` | 1-bit 2x1 MUX — dataflow style using a single assign |
| `mux_2x1_behav.v` | 1-bit 2x1 MUX — behavioral style using always/if-else |
| `mux_2x1_3bit.v` | 3-bit 2x1 MUX — three instances of mux_2x1_simple (Part 1 top) |
| `mux_4x1_3bit.v` | 3-bit 4x1 MUX — three instances of mux_2x1_3bit (Part 2 top) |
| `lab0.xdc` | Pin constraints for Nexys A7-100T |

---

## Part 1 — 1-bit 2x1 MUX Three Ways, Then 3 Bits Wide

### The three modeling styles

The same 2x1 MUX — output `m` follows input `x` when `s=0`, and input `y` when `s=1` — is described three ways to demonstrate that Verilog supports multiple levels of abstraction:

- **Structural** (`mux_2x1_struct`): wires together NOT, AND, and OR gate primitives explicitly, mirroring the gate-level schematic. Most verbose; most control over gate topology.
- **Dataflow** (`mux_2x1_simple`): a single `assign` statement using the conditional `?:` operator. The synthesizer chooses the gates.
- **Behavioral** (`mux_2x1_behav`): an `always @(*)` block with `if/else`. Describes what the output should be under each condition. The output must be declared `output reg` because it is assigned inside `always`.

All three synthesize to identical hardware — a single lookup table on the FPGA. The parent module only sees the ports; it does not care which style built them.

### Widening to 3 bits

`mux_2x1_3bit` wraps three instances of `mux_2x1_simple`, one per bit, all sharing the same select signal `s`. A single `assign sLED = s` mirrors the select to an LED. This demonstrates hierarchical design: a 1-bit module reused three times to produce a 3-bit module without duplicating any logic.

### Part 1 pin constraints

| Signal | Board I/O | Notes |
|--------|-----------|-------|
| `x[2:0]` | SW2–SW0 | |
| `y[2:0]` | SW5–SW3 | |
| `s` | SW15 | Switch up selects Y |
| `m[2:0]` | LED2–LED0 | Output |
| `sLED` | LED15 | Mirrors select switch |

### Board test

Set different patterns on SW2–SW0 (X) and SW5–SW3 (Y), then flip SW15. LED2–LED0 should show X when SW15 is down and Y when it is up; LED15 mirrors SW15. Swap the instance inside `mux_2x1_3bit` to `mux_2x1_struct` or `mux_2x1_behav`, regenerate the bitstream, and confirm the behavior is identical.

---

## Part 2 — 3-bit 4x1 MUX

### Design

`mux_4x1_3bit` is built from three instances of `mux_2x1_3bit` arranged in two stages:

- **Stage 1, instance M0**: selects between X and Y using `s0` → internal result `f`
- **Stage 1, instance M1**: selects between Z and W using `s0` → internal result `g`
- **Stage 2, instance M2**: selects between `f` and `g` using `s1` → final output `m`

The two internal buses `f` and `g` must be declared as `wire [2:0]` in the parent module before they are used — omitting the declaration causes Verilog to silently create 1-bit wires, and only `m[0]` would work correctly. The select-status LEDs are driven at the top level, so the inner `sLED` ports of M0 and M1 are left unconnected.

Following both selects through the tree: `S1S0 = 00 → X`, `01 → Y`, `10 → Z`, `11 → W`.

### Part 2 pin constraints

| Signal | Board I/O | Notes |
|--------|-----------|-------|
| `x[2:0]` | SW2–SW0 | |
| `y[2:0]` | SW5–SW3 | |
| `z[2:0]` | SW8–SW6 | SW8 uses LVCMOS18 — do not change |
| `w[2:0]` | SW11–SW9 | SW9 uses LVCMOS18 — do not change |
| `s0` | SW14 | |
| `s1` | SW15 | |
| `m[2:0]` | LED2–LED0 | Output |
| `s0LED` | LED14 | Mirrors S0 |
| `s1LED` | LED15 | Mirrors S1 |

> **Note**: SW8 and SW9 are wired to a 1.8 V bank on the FPGA. Their constraint lines must keep `IOSTANDARD LVCMOS18` exactly as written in the master XDC — do not change them to LVCMOS33.

### Board test

| S1 | S0 | Expected output on LED2–LED0 |
|----|----|------------------------------|
| 0  | 0  | X (SW2–SW0) |
| 0  | 1  | Y (SW5–SW3) |
| 1  | 0  | Z (SW8–SW6) |
| 1  | 1  | W (SW11–SW9) |

---

## Vivado Flow

1. Create RTL project, select part `xc7a100tcsg324-1`
2. Add all `.v` source files; set the top module (right-click → Set as Top)
3. Add `Nexys-A7-100T-Master.xdc` as a constraints file (tick *Copy into project*)
4. Click **Generate Bitstream** — Vivado runs synthesis and implementation first
5. Open **Hardware Manager → Auto Connect**, then **Program Device**
