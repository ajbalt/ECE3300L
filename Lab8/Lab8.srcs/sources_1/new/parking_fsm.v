`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 02:19:21 PM
// Design Name: 
// Module Name: parking_fsm
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


module parking_fsm(
    input clk, reset_n,
    input a, b,
    output car_enter, car_exit
    );

    // state encoding
    localparam IDLE    = 4'd0,
               E1      = 4'd1,  // enter: a only      (10)
               E2      = 4'd2,  // enter: both        (11)
               E3      = 4'd3,  // enter: b only      (01)
               ENTERED = 4'd4,  // one-cycle pulse state
               X1      = 4'd5,  // exit:  b only      (01)
               X2      = 4'd6,  // exit:  both        (11)
               X3      = 4'd7,  // exit:  a only      (10)
               EXITED  = 4'd8;  // one-cycle pulse state
    
    reg [3:0] state_reg, state_next;

    always @(posedge clk, negedge reset_n) 
    begin
        if(~reset_n)
            state_reg <= IDLE;
        else
            state_reg <= state_next;    
    end

    // Nest state
    always @(*)
    begin
        state_next = state_reg;
        case (state_reg)
            IDLE: case ({a, b})
                    2'b10:   state_next = E1;
                    2'b01:   state_next = X1;
                    default: state_next = IDLE;
                  endcase

            // ---- car entering: 00 -> 10 -> 11 -> 01 -> 00 ----
            E1: case ({a, b})
                    2'b10:   state_next = E1;
                    2'b11:   state_next = E2;
                    default: state_next = IDLE;   // 00 = pedestrian, 01 = invalid
                endcase
            E2: case ({a, b})
                    2'b11:   state_next = E2;
                    2'b01:   state_next = E3;
                    2'b10:   state_next = E1;     // car backed up
                    default: state_next = IDLE;
                endcase
            E3: case ({a, b})
                    2'b01:   state_next = E3;
                    2'b00:   state_next = ENTERED;
                    2'b11:   state_next = E2;
                    default: state_next = IDLE;
                endcase
            ENTERED: state_next = IDLE;

            // ---- car exiting: 00 -> 01 -> 11 -> 10 -> 00 ----
            X1: case ({a, b})
                    2'b01:   state_next = X1;
                    2'b11:   state_next = X2;
                    default: state_next = IDLE;
                endcase
            X2: case ({a, b})
                    2'b11:   state_next = X2;
                    2'b10:   state_next = X3;
                    2'b01:   state_next = X1;
                    default: state_next = IDLE;
                endcase
            X3: case ({a, b})
                    2'b10:   state_next = X3;
                    2'b00:   state_next = EXITED;
                    2'b11:   state_next = X2;
                    default: state_next = IDLE;
                endcase
            EXITED: state_next = IDLE;

            default: state_next = IDLE;
        endcase
    end

    //outptu logic
    assign car_enter = (state_reg == ENTERED);
    assign car_exit = (state_reg == EXITED);
endmodule
