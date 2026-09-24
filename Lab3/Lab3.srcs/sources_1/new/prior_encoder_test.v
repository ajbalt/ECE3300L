`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2026 08:03:28 PM
// Design Name: 
// Module Name: prior_encoder_test
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


module prior_encoder_test(
    input [15:0] SW,    //16 switch inputs
    output [6:0] sseg,  //segment ooutputs (acitve-low, GFEDCBA)
    output [7:0] AN,    //anode slect (active-low); AN[0]=0 enables digit
    output DP   //decimal point (active-low; held high = off)
    );
    
    wire [3:0] enc_out;
    wire valid;
    
    //16-input priority encoder
    priority_encoder_generic #(.N(16)) enc (
    .w(SW),
    .z(valid),
    .y(enc_out)
    );
    
    //convert 4-bit index to acitve-low seven-segement pattern
    hex2sseg seg_driver (
    .hex(enc_out),
    .sseg(sseg)
    );
    
    assign AN = 8'b1111_1110;  // digit 0 active (AN[0] low), all others off
    assign DP = 1'b1;          // decimal point off (active-low display)
endmodule
