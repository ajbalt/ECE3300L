`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 01:14:15 PM
// Design Name: 
// Module Name: mux_2x1_struct
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


module mux_2x1_struct(
    input x, y, s,
    output m
    );
    wire ns, a0, a1;
    not g0(ns, s);
    and g1(a0, x, ns);
    and g2(a1, y , s);
    or g3(m, a0, a1);
endmodule

