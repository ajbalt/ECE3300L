`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 02:07:44 PM
// Design Name: 
// Module Name: vending_top
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


module vending_top(
    input CLK100MHZ,
    input CPU_RESETN,
    input BTNL, BTNC, BTNR, BTNU,
    output [3:0] LED,
    output [7:0] AN,
    output [6:0] SEG,
    output DP,
    output LD16_R, LD16_G, LD16_B,
    output LD17_R, LD17_G, LD17_B
    );
    wire c5, c10, c25, item_taken;
    wire d0, d1, d2, d3, n0, n1, n2, n3, e0, e1, e2, e3;

    button B5  (.clk(CLK100MHZ), .reset_n(CPU_RESETN), .noisy(BTNL), .debounced(d0), .p_edge(c5),         .n_edge(n0), ._edge(e0));
    button B10 (.clk(CLK100MHZ), .reset_n(CPU_RESETN), .noisy(BTNC), .debounced(d1), .p_edge(c10),        .n_edge(n1), ._edge(e1));
    button B25 (.clk(CLK100MHZ), .reset_n(CPU_RESETN), .noisy(BTNR), .debounced(d2), .p_edge(c25),        .n_edge(n2), ._edge(e2));
    button BIT (.clk(CLK100MHZ), .reset_n(CPU_RESETN), .noisy(BTNU), .debounced(d3), .p_edge(item_taken), .n_edge(n3), ._edge(e3));

    wire dispense, r5, r10, r20;
    wire [5:0] total, change;
    vending_fsm FSM (.clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .c5(c5), .c10(c10), .c25(c25), .item_taken(item_taken),
        .dispense(dispense), .r5(r5), .r10(r10), .r20(r20),
        .total(total), .change(change));

    assign LED = {dispense, r20, r10, r5};

    seg7_display DISP (.clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .total(total), .change(change), .an(AN), .seg(SEG), .dp(DP));

    // ---- RGB LEDs (duty 0..256; kept low because the LEDs are very bright) ----
    localparam [8:0] ON = 9'd48;
    reg [8:0] r16, g16, b16, r17, g17, b17;
    always @(*) begin
        // LD16: status (blue = accepting coins, green = dispensing)
        r16 = 9'd0;
        g16 = dispense ? ON : 9'd0;
        b16 = dispense ? 9'd0 : ON;
        // LD17: change amount (off when none)
        r17 = 9'd0; g17 = 9'd0; b17 = 9'd0;
        if (r5 & ~r10) begin r17 = ON;       end             // 5  = red
        if (r10 & ~r5) begin r17 = ON; g17 = ON; end         // 10 = yellow
        if (r5 & r10)  begin r17 = ON; b17 = ON; end         // 15 = magenta
        if (r20)       begin g17 = ON; b17 = ON; end         // 20 = cyan
    end
    
    rgb_driver RGB16 (.clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .red_duty(r16), .green_duty(g16), .blue_duty(b16),
        .red_LED(LD16_R), .green_LED(LD16_G), .blue_LED(LD16_B));
    rgb_driver RGB17 (.clk(CLK100MHZ), .reset_n(CPU_RESETN),
        .red_duty(r17), .green_duty(g17), .blue_duty(b17),
        .red_LED(LD17_R), .green_LED(LD17_G), .blue_LED(LD17_B));
        
endmodule
