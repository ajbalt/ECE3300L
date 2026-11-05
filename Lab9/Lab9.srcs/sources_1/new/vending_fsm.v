`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 01:56:15 PM
// Design Name: 
// Module Name: vending_fsm
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


module vending_fsm(
    input clk, reset_n,
    input c5, c10, c25,
    input item_taken,
    output dispense,
    output r5, r10, r20,
    output [5:0] total,
    output [5:0] change
    );

    localparam COLLECT = 1'b0, DISPENSE = 1'b1;
    localparam [5:0] PRICE = 6'd25;

    reg state_reg, state_next;
    reg [5:0] credit_reg, credit_next;

    // State
    always @(posedge clk, negedge reset_n)
        if (~reset_n) begin
            state_reg  <= COLLECT;
            credit_reg <= 6'd0;
        end else begin
            state_reg  <= state_next;
            credit_reg <= credit_next;
        end
    
    // Next-state logic
    always @(*) begin
        state_next = state_reg;
        credit_next = credit_reg;
        case (state_reg)
            COLLECT: begin
                if      (c25) credit_next = credit_reg + 6'd25;
                else if (c10) credit_next = credit_reg + 6'd10;
                else if (c5)  credit_next = credit_reg + 6'd5;
                if (credit_next >= PRICE) state_next = DISPENSE;
            end
            DISPENSE: begin               // coins ignored until item is taken
                if (item_taken) begin
                    state_next  = COLLECT;
                    credit_next = 6'd0;
                end
            end
            default: begin
                state_next  = COLLECT;
                credit_next = 6'd0;
            end
        endcase
    end

    // Moore output
    assign dispense = (state_reg == DISPENSE);
    assign total = credit_reg;
    assign change = dispense ? (credit_reg - PRICE) : 6'd0;

    // change is one of {0,5,10,15,20}: 15 = nickel + dime, 20 = two dimes
    assign r5  = (change == 6'd5)  | (change == 6'd15);
    assign r10 = (change == 6'd10) | (change == 6'd15);
    assign r20 = (change == 6'd20);

endmodule
