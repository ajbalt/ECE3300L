`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 03:27:41 PM
// Design Name: 
// Module Name: sseg_driver
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


module sseg_driver 
    #(parameter FINAL_VALUE = 50000)(
    input        clk,
    input        reset_n,
    input  [5:0] I0, I1, I2, I3, I4, I5, I6, I7,
    output [6:0] sseg,
    output [7:0] AN,
    output       DP
);
    wire       done;
    wire [2:0] sel;
    wire [5:0] D_out;
    wire [7:0] dec_out;

    // Timer: pulses done every FINAL_VALUE cycles
    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) timer_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .done(done)
    );

    // 3-bit counter: sel cycles 0→7 on each done pulse
    udl_counter #(.BITS(3)) sel_cnt (
        .clk(clk),
        .reset_n(reset_n),
        .enable(done),
        .up(1'b1),
        .load(1'b0),
        .D(3'b0),
        .Q(sel)
    );

    // 8×1 6-bit MUX: select current digit's packed input
    assign D_out = (sel == 3'd0) ? I0 :
                   (sel == 3'd1) ? I1 :
                   (sel == 3'd2) ? I2 :
                   (sel == 3'd3) ? I3 :
                   (sel == 3'd4) ? I4 :
                   (sel == 3'd5) ? I5 :
                   (sel == 3'd6) ? I6 : I7;

    // 3×8 decoder: en=I[5] (digit enable); active-high output → invert for active-low AN
    decoder_generic #(.N(3)) dec_inst (
        .w(sel),
        .en(D_out[5]),
        .y(dec_out)
    );

    assign AN = ~dec_out;

    // Hex digit → segment pattern
    hex2sseg seg_inst (
        .hex(D_out[4:1]),
        .sseg(sseg)
    );

    // I[0]=1 means DP on; Nexys A7 DP is active-low
    assign DP = ~D_out[0];
    
endmodule
