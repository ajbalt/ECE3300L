`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 10:03:19 PM
// Design Name: 
// Module Name: accumulator_application
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


module accumulator_application(
    input clk,
    input [15:0] SW,
    input BTND, //down pushbutton  -> load
    input CPU_RESETN,   // reset button -> reset_n
    output [6:0] sseg,
    output [7:0] AN,
    output DP
    );

    //button conditioning: converts BTND to a singel-cycle laod pulse
    wire load;
    button btn_load(
        .clk(clk),
        .in(BTND),
        .out(load)
    );

    // Accumulator
    wire [3:0] Q;
    accumulator #(.BITS(4)) acc (
        .clk(clk),
        .reset_n(CPU_RESETN),
        .load(load),
        .add_n(SW[15]),
        .X(SW[3:0]),
        .Q(Q)
    );

    // Display Q on digit 0
    hex2sseg seg_enc(
        .hex(Q),
        .sseg(sseg)
    );

    assign AN = 8'b11111110;  // digit 0 enabled (active-low)
    assign DP = 1'b1;         // decimal point off
endmodule
