`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 02:33:48 PM
// Design Name: 
// Module Name: parking_fsm_tb
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


module parking_fsm_tb();
    reg clk, reset_n;
    reg a, b;
    wire car_enter, car_exit;

    parking_fsm uut(.clk(clk), .reset_n(reset_n), .a(a), .b(b), .car_enter(car_enter), .car_exit(car_exit));

    always #5 clk = ~clk;

    // Apply one ab value and hold it for 3 clocks
    task apply(input a_in, input b_in);
    begin
        a = a_in; b = b_in;
        repeat (3) @(negedge clk);
    end
    endtask

    initial begin
        clk = 0; reset_n = 0; a= 0; b = 0;
        repeat (2) @(negedge clk);
        reset_n = 1;
        repeat (2) @(negedge clk);

        // 1. Car enters: 00 -> 10 -> 11 -> 01 -> 00
        apply(1,0); apply(1,1); apply(0,1); apply(0,0);

        // 2. Car exits: 00 -> 01 -> 11 -> 10 -> 00
        apply(0,1); apply(1,1); apply(1,0); apply(0,0);

        // 3. Pedestrian via a only: 00 -> 10 -> 00
        apply(1,0); apply(0,0);

        // 4. Pedestrian via b only: 00 -> 01 -> 00
        apply(0,1); apply(0,0);

        // 5. Car starts to enter, then backs out: 00 -> 10 -> 11 -> 10 -> 00
        apply(1,0); apply(1,1); apply(1,0); apply(0,0);

        // 6. Two cars enter back to back
        apply(1,0); apply(1,1); apply(0,1); apply(0,0);
        apply(1,0); apply(1,1); apply(0,1); apply(0,0);

        // 7. Reset mid-sequence
        apply(1,0); apply(1,1);
        reset_n = 0; repeat (2) @(negedge clk); reset_n = 1;
        apply(0,0);

        repeat (3) @(negedge clk);
        $finish;
    end
endmodule
