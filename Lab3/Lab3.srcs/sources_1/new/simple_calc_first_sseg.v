`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 01:53:58 PM
// Design Name: 
// Module Name: simple_calc_first_sseg
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


module simple_calc_first_sseg(
    input  [3:0] X,           // SW3-SW0: operand x
    input  [3:0] Y,           // SW7-SW4: operand y
    input  [1:0] digit_sel,   // SW9-SW8: selects which BCD digit to display
    input  [1:0] op_sel,      // SW15-SW14: operation select
    output [6:0] sseg,
    output [7:0] AN,
    output       DP,
    output       carry_out,   // LED14
    output       overflow     // LED15
);

    wire [7:0]  calc_result;
    wire [11:0] bcd;
    wire [3:0]  mux_out;

    simple_calc U_calc (
        .x(X),          .y(Y),
        .op_sel(op_sel),
        .result(calc_result),
        .carry_out(carry_out),
        .overflow(overflow)
    );

    bin2bcd U_bcd (
        .bin(calc_result),
        .bcd(bcd)
    );

    // digit_sel 00=ones(digit4), 01=tens(digiblank(digit7)
    mux_4x1_nbit #(.N(4)) U_mux (
        .w0(bcd[11:8]),   // s=00 → hundreds → digit 4 (leftmost)
        .w1(bcd[7:4]),    // s=01 → tens     → digit 5
        .w2(bcd[3:0]),    // s=10 → ones     → digit 6 (rightmost)
        .w3(4'b0000),     // s=11 → blank    → digit 7
        .s(digit_sel),
        .f(mux_out)
    );

    // {1'b1, digit_sel} maps digit_sel 0-3 ->
    first_sseg_driver U_driver (
        .active_digit({1'b1, digit_sel}),
        .num(mux_out),
        .DP_ctrl(1'b0),
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );

endmodule
