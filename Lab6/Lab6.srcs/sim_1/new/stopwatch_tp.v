`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 06:42:43 PM
// Design Name: 
// Module Name: stopwatch_tb
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


module stopwatch_tb;

    // ---------------- DUT I/O ----------------
    reg         clk;
    reg         CPU_RESETN;
    reg         BTNC;
    wire [6:0]  sseg;
    wire [7:0]  AN;
    wire        DP;

    // TICK_FINAL = 3 -> one "0.01 s" = 4 clocks (smallest safe value, see
    // timer_parameter's $clog2 sizing)
    stopwatch #(.TICK_FINAL(3)) uut (
        .clk        (clk),
        .CPU_RESETN (CPU_RESETN),
        .BTNC       (BTNC),
        .sseg       (sseg),
        .AN         (AN),
        .DP         (DP)
    );

    // ---------------- clock: 100 MHz ----------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ---------------- observe digits inside uut ----------------
    // packed BCD: {MM tens, MM ones, SS tens, SS ones, FF tens, FF ones}
    wire [23:0] t = {uut.mm_tens, uut.mm_ones,
                     uut.ss_tens, uut.ss_ones,
                     uut.ff_tens, uut.ff_ones};

    integer errors = 0;
    reg [23:0] saved;

    // ---------------- helpers ----------------
    // button.v pulses after 2 consecutive high samples; hold 4 clocks
    task press_btnc;
        begin
            @(negedge clk) BTNC = 1'b1;
            repeat (4) @(negedge clk);
            BTNC = 1'b0;
            repeat (4) @(negedge clk);
        end
    endtask

    // Jump the digit counters to a chosen time (sim only). Done on negedge so
    // it never races the posedge non-blocking updates.
    task preload(input [3:0] mm10, mm1, ss10, ss1, ff10, ff1);
        begin
            @(negedge clk);
            uut.MM10.Q_reg = mm10[2:0];
            uut.MM1.Q_reg  = mm1;
            uut.SS10.Q_reg = ss10[2:0];
            uut.SS1.Q_reg  = ss1;
            uut.FF10.Q_reg = ff10;
            uut.FF1.Q_reg  = ff1;
        end
    endtask

    task expect_time(input [23:0] expected);
        begin
            if (t !== expected) begin
                errors = errors + 1;
                $display("[%0t] FAIL: got %h_%h_%h, expected %h_%h_%h",
                         $time, t[23:16], t[15:8], t[7:0],
                         expected[23:16], expected[15:8], expected[7:0]);
            end else
                $display("[%0t] PASS: time = %h_%h_%h",
                         $time, t[23:16], t[15:8], t[7:0]);
        end
    endtask

    // ---------------- watchdog (2 ms, ~200k clocks) ----------------
    initial begin
        #2_000_000;
        $display("TIMEOUT: a wait never completed. errors so far = %0d", errors);
        $stop;
    end

    // ---------------- stimulus ----------------
    initial begin
        CPU_RESETN = 1'b0;
        BTNC       = 1'b0;
        #50 CPU_RESETN = 1'b1;

        // 1. idle after reset: stays 00.00.00 until BTNC is pressed
        repeat (200) @(negedge clk);
        expect_time(24'h000000);

        // 2. start; run to 00.00.05
        press_btnc;
        wait (t == 24'h000005);
        expect_time(24'h000005);

        // 3. pause: value must hold
        press_btnc;
        saved = t;
        repeat (200) @(negedge clk);
        expect_time(saved);

        // 4. continue: count resumes
        press_btnc;
        wait (t == 24'h000010);
        expect_time(24'h000010);

        // 5. FF -> SS carry: 00.00.99 -> 00.01.00
        preload(0,0, 0,0, 9,9);
        wait (t == 24'h000100);
        expect_time(24'h000100);

        // 6. SS -> MM carry: 00.59.99 -> 01.00.00
        preload(0,0, 5,9, 9,9);
        wait (t == 24'h010000);
        expect_time(24'h010000);

        // 7. full wrap: 59.59.99 -> 00.00.00
        preload(5,9, 5,9, 9,9);
        wait (t == 24'h000000);
        expect_time(24'h000000);

        // 8. CPU reset while running: clears and stays stopped
        repeat (20) @(negedge clk);
        @(negedge clk) CPU_RESETN = 1'b0;
        @(negedge clk) CPU_RESETN = 1'b1;
        repeat (50) @(negedge clk);
        expect_time(24'h000000);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $stop;
    end

endmodule
