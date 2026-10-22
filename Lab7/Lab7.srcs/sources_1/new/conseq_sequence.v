`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 01:38:48 PM
// Design Name: 
// Module Name: conseq_sequence
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

// Moore FSM: y = 1 while x has been 1 (or 0) for three or more consecutive clocks
module conseq_sequence(
    input clk,
    input reset,
    input x,
    output y
    );

    localparam S0 = 3'd0,   // reset, no history
               A1 = 3'd1,   // one 1 in a row
               A2 = 3'd2,   // two 1s in a row
               A3 = 3'd3,   // three or more 1s in a row  (y = 1)
               B1 = 3'd4,   // one 0 in a row
               B2 = 3'd5,   // two 0s in a row
               B3 = 3'd6;   // three or more 0s in a row  (y = 1)
    
    reg [2:0] state, next_state;

    // state register
    always@(posedge clk) begin
        if(reset) state <= S0;
        else state <= next_state;
    end

    // next-state logic
    always @(*) begin
        case (state)
            S0: next_state = x ? A1 : B1;
            A1: next_state = x ? A2 : B1;
            A2: next_state = x ? A3 : B1;
            A3: next_state = x ? A3 : B1;
            B1: next_state = x ? A1 : B2;
            B2: next_state = x ? A1 : B3;
            B3: next_state = x ? A1 : B3;
            default: next_state = S0;
        endcase
    end

    // Moore output; depends on state only
    assign y = (state == A3) || (state == B3);

endmodule
