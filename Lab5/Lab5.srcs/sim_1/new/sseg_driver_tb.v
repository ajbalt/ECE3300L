`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 03:31:14 PM
// Design Name: 
// Module Name: sseg_driver_tb
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


module sseg_driver_tb;
    reg        clk;
    reg        reset_n;
    wire [6:0] sseg;
    wire [7:0] AN;
    wire       DP;

    // I format: {enable, hex[3:0], DP}
    sseg_driver #(.FINAL_VALUE(8)) uut (
        .clk(clk),
        .reset_n(reset_n),
        .I0({1'b1, 4'd0, 1'b0}),   // digit 0: show 0, no DP
        .I1({1'b1, 4'd1, 1'b0}),   // digit 1: show 1, no DP
        .I2({1'b1, 4'd2, 1'b1}),   // digit 2: show 2, DP on
        .I3({1'b1, 4'd3, 1'b0}),   // digit 3: show 3, no DP
        .I4({1'b0, 4'd0, 1'b0}),   // digit 4: disabled (blanked)
        .I5({1'b1, 4'd5, 1'b0}),   // digit 5: show 5, no DP
        .I6({1'b1, 4'd6, 1'b0}),   // digit 6: show 6, no DP
        .I7({1'b1, 4'd7, 1'b0}),   // digit 7: show 7, no DP
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial $monitor("t=%0t  sel_AN=%b  sseg=%b  DP=%b", $time, AN, sseg, DP);

    initial begin
        reset_n = 0;
        #20;
        reset_n = 1;
        // 2 full 8-digit scans: 2 × 8 × 8 cycles × 10 ns = 1280 ns
        #1280;
        $display("Simulation complete.");
        $finish;
    end
endmodule
