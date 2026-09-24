`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 01:38:11 PM
// Design Name: 
// Module Name: first_sseg_driver
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


module first_sseg_driver(
    input  [2:0] active_digit,  // (a) selects one of 8 digits
    input  [3:0] num,           // (b) binary number to display
    input        DP_ctrl,       // (c) decimal point on/off
    output [6:0] sseg,          // (d) segment cathodes (gfedcba, active-low)
    output [7:0] AN,            // (d) anode select (active-low)
    output       DP             // (d) decimal point (active-low)
);

    wire [7:0] dec_out;

    // decoder_generic: 3-bit active_digit → one-hot 8-bit anode select
    decoder_generic #(.N(3)) U_dec (
        .w(active_digit),
        .en(1'b1),
        .y(dec_out)
    );

    // hex2sseg: 4-bit num → 7-bit segment pat
    hex2sseg U_hex (
        .hex(num),
        .sseg(sseg)
    );

    assign AN = ~dec_out;  // invert decoder o
    assign DP = ~DP_ctrl;  // invert for active-low decimal point

endmodule
