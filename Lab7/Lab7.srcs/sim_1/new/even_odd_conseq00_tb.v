`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 05:45:03 PM
// Design Name: 
// Module Name: even_odd_conseq00_tb
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


module even_odd_conseq00_tb();
    reg clk = 0, reset = 1, x = 0;
    wire y;

    even_odd_conseq00 uut(.clk(clk), .reset(reset), .x(x), .y(y));

    always #5 clk = ~clk;

    // test stream
    reg [15:0] stream = 16'b1010100111001001;
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
