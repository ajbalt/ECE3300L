`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 01:31:04 PM
// Design Name: 
// Module Name: csa_multiplier_tb
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


module csa_multiplier_tb();
    reg [3:0] m, q;
    wire [7:0] p;

    csa_multiplier uut(.m(m), .q(q), .p(p));

     initial begin
        m =  0;  q = 10;          // t =  0 ns — 0×10 = 0
        #10 m =  5;  q =  5;      // t = 10 ns — 5×5 = 25
        #10 m =  9;  q =  5;      // t = 20 ns — 9×5 = 45
        #10 m = 12;  q = 13;      // t = 30 ns — 12×13 = 156
        #10 m = 15;  q = 10;      // t = 40 ns — 15×10 = 150
        #10 $finish;              // t = 50 ns
    end

endmodule
