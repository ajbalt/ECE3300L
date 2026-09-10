`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 01:17:37 PM
// Design Name: 
// Module Name: mux_2x1_3bit
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


module mux_2x1_3bit(
    input [2:0] x, y,
    input s,
    output [2:0] m,
    output sLED
    );
    assign sLED = s;
    mux_2x1_simple M0(x[0], y[0], s, m[0]); //bit0
    mux_2x1_simple M1(x[1], y[1], s, m[1]); //bit1
    mux_2x1_simple M2(x[2], y[2], s, m[2]); //bit2
endmodule
