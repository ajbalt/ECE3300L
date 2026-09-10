`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 01:51:16 PM
// Design Name: 
// Module Name: mux_4x1_3bit
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


module mux_4x1_3bit(
    input [2:0] x, y, z, w,
    input s0, s1,
    output [2:0] m,
    output s0LED, s1LED
    );
    assign s0LED = s0;
    assign s1LED = s1;
    
    wire [2:0] f, g;
    
    mux_2x1_3bit M0(.x(x), .y(y), .s(s0), .m(f), .sLED()); // f = s0 ? y: x
    mux_2x1_3bit M1(.x(z), .y(w), .s(s0), .m(g), .sLED()); // g = s0 ? w: z
    mux_2x1_3bit M2(.x(f), .y(g), .s(s1), .m(m), .sLED()); // m = s1 ? g: f
endmodule
