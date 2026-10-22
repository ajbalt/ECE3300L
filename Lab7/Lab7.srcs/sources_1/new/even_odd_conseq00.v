`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 05:11:31 PM
// Design Name: 
// Module Name: even_odd_conseq00
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


module even_odd_conseq00(
    input clk,
    input reset,
    input x,
    output y
    );

    localparam S0 = 3'd0,   // even 1s, no 00 yet (reset)
               S1 = 3'd1,   // odd  1s, no 00 yet
               S2 = 3'd2,   // even 1s, one 0 just seen
               S3 = 3'd3,   // even 1s, 00 seen
               S4 = 3'd4,   // odd  1s, 00 seen  (y = 1)
               S5 = 3'd5;   // odd  1s, one 0 just seen
    
    reg [2:0] state, next_state;

    // state register
    always@(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    //next state logic
    always@(*) begin
        case (state)
        S0: next_state = x ? S1 : S2;
        S1: next_state = x ? S0 : S5;
        S2: next_state = x ? S1 : S3;
        S3: next_state = x ? S4 : S3;
        S4: next_state = x ? S3 : S4;
        S5: next_state = x ? S0 : S4;
        default: next_state = S0;
        endcase
    end

    // Moore output: depends on state only
    assign y = (state === S4);

endmodule
