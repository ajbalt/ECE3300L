`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 01:44:31 PM
// Design Name: 
// Module Name: conseq_sequence_tb
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


module conseq_sequence_tb();
    reg clk = 0, reset = 1, x = 0;
    wire y;

    conseq_sequence uut(.clk(clk), .reset(reset), .x(x), .y(y));

    always #5 clk = ~clk;

    // test stream, applied MSB first; y should be 1 after bits 4, 7, 8, 11 and 12
    reg [15:0] stream = 16'b0111000011110010;
    integer i;

    initial begin
        #12 reset = 0;
        for(i = 15; i >= 0; i = i -1) begin
            x = stream[i];
            @(negedge clk);
        end
        $finish;
    end
endmodule
