`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 02:38:32 PM
// Design Name: 
// Module Name: first_sseg_driver_test
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


module first_sseg_driver_test #(parameter FINAL_VALUE = 50000)(
    input clk,
    input reset_n,
    output [6:0] sseg,
    output [7:0] AN,
    output DP
    );
    wire done;
    wire [2:0] sel;

    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) tiemr_inst(
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .done(done)
    );

    udl_counter #(.BITS(3)) cnt (
        .clk(clk),
        .reset_n(reset_n),
        .enable(done),
        .up(1'b1),
        .load(1'b0),
        .D(3'b0),
        .Q(sel)
    );

    first_sseg_driver U_driver(
        .active_digit(sel),
        .num({1'b0, sel}),
        .DP_ctrl(1'b0),
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );
endmodule
