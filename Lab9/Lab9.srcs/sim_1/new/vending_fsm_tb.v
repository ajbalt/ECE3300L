`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 02:11:39 PM
// Design Name: 
// Module Name: vending_fsm_tb
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


module vending_fsm_tb;
    reg clk = 0, reset_n = 0;
    reg c5 = 0, c10 = 0, c25 = 0, item_taken = 0;
    wire dispense, r5, r10, r20;
    wire [5:0] total, change;

    vending_fsm uut(.clk(clk), .reset_n(reset_n), .c5(c5), .c10(c10), .c25(c25),
        .item_taken(item_taken), .dispense(dispense), .r5(r5), .r10(r10), .r20(r20),
        .total(total), .change(change));

    always #5 clk = ~clk;

    // one-cycle pulse: 5, 10, 25 = coin; 0 = item_taken
    task pulse(input integer which);
    begin
        @(negedge clk);
        c5 = (which == 5); c10 = (which == 10); c25 = (which == 25); item_taken = (which == 0);
        @(negedge clk);
        c5 = 0; c10 = 0; c25 = 0; item_taken = 0;
        repeat (2) @(negedge clk);
    end
    endtask

    initial begin
        #22 reset_n = 1;
        pulse(5); pulse(5); pulse(5); pulse(5); pulse(5); pulse(0);   // 25, no change
        pulse(25); pulse(0);                                          // 25, no change
        pulse(10); pulse(10); pulse(10); pulse(0);                    // 30, r5
        pulse(10); pulse(5); pulse(25); pulse(0);                     // 40, r5 + r10
        pulse(10); pulse(10); pulse(25); pulse(0);                    // 45, r20
        #20 $finish;
    end
endmodule