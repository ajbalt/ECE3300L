`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 01:31:20 PM
// Design Name: 
// Module Name: bcd_calc_signed
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bcd_calc_signed(
    input  [3:0] x, y,
    input  [1:0] op_sel,
    output [11:0] result,
    output negative,
    output carry_out,
    output overflow
);

    wire [7:0] raw;

    simple_calc calc0 (
        .x(x),         .y(y),
        .op_sel(op_sel),
        .result(raw),
        .carry_out(carry_out),
        .overflow(overflow)
    );

    // Borrow (carry_out=0) during subtraction means negative result
    assign negative = (op_sel == 2'b01) && !carry_out;

    wire [7:0] add_val = {3'b000, carry_out, raw[3:0]}; // carry extends sum to 5 bits
    wire [3:0] sub_mag = negative ? (~raw[3:0] + 4'b0001) : raw[3:0]; // absolute value
    wire [7:0] sub_val = {4'b0000, sub_mag};
    wire [7:0] bin_val = op_sel[1] ? raw      :          // multiply: full 8-bit product
                         op_sel[0] ? sub_val  :          // subtract: magnitude
                                     add_val;            // add: sum with carry

    bin2bcd bcd0 (
        .bin(bin_val),
        .bcd(result)
    );

endmodule