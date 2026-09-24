`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 01:43:39 PM
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


module first_sseg_driver_test(
    input  [2:0] X,     // connected to SW[2:0]
    output [6:0] sseg,
    output [7:0] AN,
    output       DP
);

    first_sseg_driver U_driver (
        .active_digit(X),
        .num({1'b0, X}),  // zero-extend 3-bit X to 4-bit num
        .DP_ctrl(1'b0),   // decimal point off
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );

endmodule