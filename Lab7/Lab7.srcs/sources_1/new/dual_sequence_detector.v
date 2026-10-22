`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 05:10:46 PM
// Design Name: 
// Module Name: dual_sequence_detector
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


module dual_sequence_detector(
    input clk,
    input reset,
    input x,
    output reg y
    );

    localparam S0 = 3'd0, //reset
    S1 = 3'd1, //last bit was 0
    S2 = 3'd2, // seen 01
    S3 = 3'd3, // seen 010 or 10
    S4 = 3'd4, // last bit was 1
    S5 = 3'd5; //seen 1000

    reg [2:0] state, next_state;

    // state register
    always@(posedge clk) begin
        if(reset) state <= S0;
        else state <= next_state;
    end

    // next state and mealy output logic
    always@(*) begin
        next_state = S0;
        y= 1'b0;
        case (state)
            S0: next_state = x ? S4 : S1;
            S1: next_state = x ? S2 : S1;
            S2: begin
                    if (x) next_state = S4;
                    else begin next_state = S3; y = 1'b1; end   // 010
                end
            S3: next_state = x ? S2 : S5;
            S4: next_state = x ? S4 : S3;
            S5: begin
                    if (x) begin next_state = S2; y = 1'b1; end // 1001
                    else   next_state = S1;
                end
            default: next_state = S0;
        endcase
    end
endmodule
