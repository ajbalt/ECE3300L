`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 06:19:31 PM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch
    #(parameter TICK_FINAL = 999_999)(
    input clk,
    input CPU_RESETN,
    input BTNC,
    output [6:0] sseg,
    output [7:0] AN,
    output DP
    );

    wire reset_n = CPU_RESETN;

    //---START / pause / continue ---
    wire btn_pulse;
    button BTN (.clk(clk), .in(BTNC), .out(btn_pulse));

    reg run;
    always @(posedge clk, negedge reset_n)
        if(~reset_n) run <= 1'b0;
        else if (btn_pulse) run <= ~run;
    
    // timer_param done stays high while it is frozen at FINAL_VALUE
    wire timer_done;
    timer_parameter #(.FINAL_VALUE(TICK_FINAL)) TICK (
        .clk(clk), .reset_n(reset_n), .enable(run), .done(timer_done)
    );
    wire tick = timer_done & run;

    // --- digits ---
    wire [3:0] ff_ones, ff_tens, ss_ones, mm_ones;
    wire [2:0] ss_tens_q, mm_tens_q;
    wire [3:0] ss_tens = {1'b0, ss_tens_q};
    wire [3:0] mm_tens = {1'b0, mm_tens_q};

    wire d_ff1, d_ff10, d_ss1, d_ss10, d_mm1, d_mm10;   // terminal-count flags
    wire e_ff1, e_ff10, e_ss1, e_ss10, e_mm1, e_mm10;   // per-digit enables

    assign e_ff1  = tick;
    assign e_ff10 = e_ff1  & d_ff1;
    assign e_ss1  = e_ff10 & d_ff10;
    assign e_ss10 = e_ss1  & d_ss1;
    assign e_mm1  = e_ss10 & d_ss10;
    assign e_mm10 = e_mm1  & d_mm1;

    // mod-10 digits
    BCD_counter FF1  (.clk(clk), .reset_n(reset_n), .enable(e_ff1),  .done(d_ff1),  .Q(ff_ones));
    BCD_counter FF10 (.clk(clk), .reset_n(reset_n), .enable(e_ff10), .done(d_ff10), .Q(ff_tens));
    BCD_counter SS1  (.clk(clk), .reset_n(reset_n), .enable(e_ss1),  .done(d_ss1),  .Q(ss_ones));
    BCD_counter MM1  (.clk(clk), .reset_n(reset_n), .enable(e_mm1),  .done(d_mm1),  .Q(mm_ones));

    // mod-6 digits (0-5). mod_counter_input has no done port, so compare here.
    mod_counter_input #(.BITS(3)) SS10 (
        .clk(clk), .reset_n(reset_n), .enable(e_ss10),
        .FINAL_VALUE(3'd5), .Q(ss_tens_q));
    assign d_ss10 = (ss_tens_q == 3'd5);

    mod_counter_input #(.BITS(3)) MM10 (
        .clk(clk), .reset_n(reset_n), .enable(e_mm10),
        .FINAL_VALUE(3'd5), .Q(mm_tens_q));
    assign d_mm10 = (mm_tens_q == 3'd5);   // unused, kept for symmetry


    // --- display ---
    sseg_driver DISP (
        .clk(clk), .reset_n(reset_n),
        .I0(6'b0),                          // blank
        .I1({1'b1, mm_tens, 1'b0}),
        .I2({1'b1, mm_ones, 1'b1}),         // DP after minutes
        .I3({1'b1, ss_tens, 1'b0}),
        .I4({1'b1, ss_ones, 1'b1}),         // DP after seconds
        .I5({1'b1, ff_tens, 1'b0}),
        .I6({1'b1, ff_ones, 1'b0}),
        .I7(6'b0),                          // blank
        .sseg(sseg), .AN(AN), .DP(DP)
    );
endmodule
