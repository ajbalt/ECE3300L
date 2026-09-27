`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 09:00:57 PM
// Design Name: 
// Module Name: reg_file_application
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


module reg_file_application(
    input clk,
    input [15:0] SW,
    input BTND, //down pushhbutton -> WE
    output [6:0] sseg, // seven-segment 
    output [7:0] AN, // digit anodes
    output DP //decimal point
    );

    // --- Button conditioning ---
    // Converts BTND level signal to a single-cycle WE pulse
    wire WE;
    button btn_we(
        .clk(clk),
        .in(BTND),
        .out(WE)
    );

    // --- Address demux ---
    // SW[10:4] is shared between write and read address ports
    // SW15 = 0 → SW[10:4] is address_w (write mode)
    // SW15 = 1 → SW[10:4] is address_r (read mode)
    wire [6:0] address_w = (SW[15] == 1'b0) ? SW[10:4] : 7'b0;
    wire [6:0] address_r = (SW[15] == 1'b1) ? SW[10:4] : 7'b0;

    // --- Register file: 128 rows × 4 bits (N=7, BITS=4) ---
    wire [3:0] data_r;
    reg_file #(.N(7), .BITS(4)) rf (
        .clk(clk),
        .address_w(address_w),
        .data_w(SW[3:0]),
        .WE(WE),
        .address_r(address_r),
        .data_r(data_r)
    );

    hex2sseg seg_enc(
        .hex(data_r),
        .sseg(sseg)
    );

    assign AN = 8'b11111110;  // digit 0 enabled, all others off (active-low)
    assign DP = 1'b1;         // decimal point off
endmodule
