# Lab 1

# ECE3300L Lab 1 — 4-bit Multiplier and Simple Calculator

**Board**: Nexys A7-100T | **Tool**: Vivado | **Language**: Verilog

---

## Objective

Build a 4-bit carry-save array multiplier from full adders, verify it with a behavioral simulation testbench, then integrate it with the provided adder/subtractor behind a multiplexer to create a three-operation calculator on the board.

---

## File List

| File | Description |
|------|-------------|
| `mq_4bit.v` | Partial product generator — ANDs multiplicand with one multiplier bit |
| `csa_multiplier.v` | 4×4 carry-save array multiplier (4 mq_4bit + 12 full adders) |
| `csa_multiplier_tb.v` | Testbench — drives 5 required products, verifies output |
| `mux_2x1_8bit.v` | 8-bit 2:1 multiplexer — selects adder or multiplier output |
| `simple_calc.v` | Top-level calculator module |
| `simple_calc.xdc` | Pin constraints for Nexys A7-100T |
| `half_adder.v` | Starter code (provided) |
| `full_adder.v` | Starter code (provided) |
| `rca_nbit.v` | Starter code (provided) — parameterized ripple-carry adder |
| `adder_subtractor.v` | Starter code (provided) — XOR-based add/subtract unit |

---

## Part 1 — The Multiplier

### How binary multiplication works

Binary long multiplication reduces to AND gates and addition. For each multiplier bit `q[j]`, the partial product row is the full multiplicand `m` if `q[j]=1`, or all zeros if `q[j]=0`. Four partial product rows are then summed to produce the 8-bit result.

### mq_4bit

Generates one partial product row by replicating a single multiplier bit to 4 bits and ANDing with the multiplicand. Four instances of this module feed into the adder array.

### Carry-save array multiplier

A naive array multiplier adds partial product rows with ripple-carry adders chained top to bottom — each row waits for the carry to crawl across before the next row can start. The carry-save approach avoids this: each full adder passes its sum straight down (same weight column) and its carry diagonally (one weight higher). Carries are saved and folded in one row later rather than propagated immediately. Only the final row ripples, giving a shorter critical path.

The 4×4 multiplier uses 12 full adders arranged in three rows:
- **Rows 0 and 1** are carry-save rows — sums go down, carries go diagonally
- **Row 2** is the final ripple row — carry propagates horizontally across to produce the MSBs

`p[0]` is wired directly from the least-significant partial product bit; no adder is needed.

### Simulation

Run Behavioral Simulation with the testbench. Set the radix on `m`, `q`, and `p` to **Unsigned Decimal** before screenshotting.

Expected results:

| m  | q  | p   |
|----|----|-----|
| 0  | 10 | 0   |
| 5  | 5  | 25  |
| 9  | 5  | 45  |
| 12 | 13 | 156 |
| 15 | 10 | 150 |

![alt text](image.png)

---

## Part 2 — The Calculator

Both arithmetic units compute all the time. `op_sel` only steers the MUX output to the LEDs — `op_sel[1]` selects between the adder/subtractor result and the multiplier product, and `op_sel[0]` controls whether the adder adds or subtracts.

| op_sel | Operation  | result on LEDs     | Flag LEDs              |
|--------|------------|--------------------|------------------------|
| `00`   | Add        | LED3–0 = sum       | LED14 = carry out      |
| `01`   | Subtract   | LED3–0 = diff      | LED15 = signed overflow |
| `1x`   | Multiply   | LED7–0 = product   | (ignore — adder still running) |

<!-- embed block diagram here -->

### Pin constraints

| Signal | Board I/O | Notes |
|--------|-----------|-------|
| `x[3:0]` | SW3–SW0 | Switch up = logic 1 |
| `y[3:0]` | SW7–SW4 | |
| `op_sel[0]` | SW14 | 0 = add, 1 = subtract |
| `op_sel[1]` | SW15 | 0 = add/sub, 1 = multiply |
| `result[7:0]` | LED7–LED0 | |
| `carry_out` | LED14 | 5th sum bit / borrow indicator |
| `overflow` | LED15 | Signed overflow flag |

### Board testing checklist

- [ ] **Multiply**: set SW15=1, enter any x/y ≤ 15. LED7–0 shows product (max 225). LED14/15 may be on — ignore them.
- [ ] **Add with carry**: SW15=0, SW14=0. Try x=12, y=7 → LEDs read `0011` (3), LED14 lights.
- [ ] **Subtract negative**: SW15=0, SW14=1. Try x=3, y=5 → LEDs read `1110` (−2 in two's complement), LED14=1.
- [ ] **Signed overflow**: Try x=7, y=15 (i.e., −1), subtract → LEDs read `1000`, LED15 lights.

<!-- embed board demo video here -->

