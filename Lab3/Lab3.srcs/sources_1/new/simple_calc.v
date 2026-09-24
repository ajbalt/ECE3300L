`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 01:53:57 PM
// Design Name: 
// Module Name: simple_calc
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


module simple_calc(
    input [3:0] x, y,
    input [1:0] op_sel,
    output [7:0] result,
    output carry_out,
    output overflow
    );

    wire [3:0] s;
    wire [7:0] p;
    
    adder_subtractor add0 (
        .x(x),          .y(y),
        .add_n(op_sel[0]),
        .s(s),
        .c_out(carry_out),
        .overflow(overflow)
    );

    csa_multiplier mul0 (
        .m(x),  .q(y),
        .p(p)
    );

    mux_2x1_8bit mux0 (
        .x({4'b0000, s}),
        .y(p),
        .s(op_sel[1]),
        .m(result)
    );
endmodule
