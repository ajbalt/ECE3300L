`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 03:00:07 PM
// Design Name: 
// Module Name: first_sseg_driver_test_tb
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


module first_sseg_driver_test_tb;
    reg clk;
    reg reset_n;
    wire [6:0] sseg;
    wire [7:0] AN;
    wire DP;

     first_sseg_driver_test #(.FINAL_VALUE(10)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial $monitor("t=%0t  AN=%b  sseg=%b  DP=%b", $time, AN, sseg, DP);

    initial begin
        reset_n = 0;
        #20;
        reset_n = 1;
        #1600;
        $display("Simulation complete.");
        $finish;
    end
endmodule
