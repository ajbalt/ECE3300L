`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 06:44:46 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input x, y, c_in,
    output s, c_out
    );
    
    wire c1, s1, c2;
    
    half_adder HA0 (.x(x), .y(y), .c(c1), .s(s1));
    half_adder HA1 (.x(c_in), .y(s1), .c(c2), .s(s));
    
    assign c_out = c1 | c2;
endmodule
