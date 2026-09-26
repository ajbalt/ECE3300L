`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 03:23:14 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file#(parameter N = 3, BITS = 4)
    (
    input clk,
    input [N-1:0] address_w,
    input [BITS-1:0] data_w,
    input WE,
    input [N-1:0] address_r,
    output [BITS-1:0] data_r
    );

    localparam DEPTH = 2 ** N;

    wire [0:DEPTH-1] write_sel;

    decoder_generic #(.N(N)) write_dec (
        .w(address_w),
        .en(WE),
        .y(write_sel)
    );

    wire [0:DEPTH-1] read_sel;

    decoder_generic #(.N(N)) read_dec(
        .w(address_r),
        .en(1'b1),
        .y(read_sel)
    );

    wire [BITS-1:0] Q [0:DEPTH-1];

    generate
        genvar i;
        for (i = 0; i < DEPTH; i = i + 1) begin : reg_array

            // Base register: loads data_w when write decoder selects it
            simple_register_load #(.N(BITS)) reg_i (
                .clk(clk),
                .load(write_sel[i]),
                .I(data_w),
                .Q(Q[i])
            );

            // Tri-state buffer: drives data_r when read decoder selects this register
            assign data_r = (read_sel[i]) ? Q[i] : {BITS{1'bz}};
        end
    endgenerate

endmodule
