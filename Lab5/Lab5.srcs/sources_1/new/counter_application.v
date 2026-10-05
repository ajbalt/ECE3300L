`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 03:45:58 PM
// Design Name: 
// Module Name: counter_application
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

module counter_application
    #(parameter FINAL_VALUE = 50000)(
    input        clk,
    input        CPU_RESETN,
    input        BTNU,
    input        BTND,
    input        BTNC,
    input  [7:0] SW,
    output [6:0] sseg,
    output [7:0] AN,
    output       DP
);
    // Single-cycle pulses from each button
    wire up_pulse, down_pulse, load_pulse;

    button btn_up   (.clk(clk), .in(BTNU), .out(up_pulse));
    button btn_down (.clk(clk), .in(BTND), .out(down_pulse));
    button btn_load (.clk(clk), .in(BTNC), .out(load_pulse));

    // 8-bit up/down/load counter (0–255)
    wire [7:0] count;

    udl_counter #(.BITS(8)) cnt (
        .clk(clk),
        .reset_n(CPU_RESETN),
        .enable(up_pulse | down_pulse | load_pulse),
        .up(up_pulse),
        .load(load_pulse),
        .D(SW),
        .Q(count)
    );

    // Binary → BCD
    wire [11:0] bcd;

    bin2bcd bcd_inst (
        .bin(count),
        .bcd(bcd)
    );

    // Display: hundreds on I0 (leftmost), tens on I1, ones on I2; I3–I7 blanked
    sseg_driver #(.FINAL_VALUE(FINAL_VALUE)) display (
        .clk(clk),
        .reset_n(CPU_RESETN),
        .I0({1'b1, bcd[11:8], 1'b0}),
        .I1({1'b1, bcd[7:4],  1'b0}),
        .I2({1'b1, bcd[3:0],  1'b0}),
        .I3(6'b000000),
        .I4(6'b000000),
        .I5(6'b000000),
        .I6(6'b000000),
        .I7(6'b000000),
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );
endmodule
