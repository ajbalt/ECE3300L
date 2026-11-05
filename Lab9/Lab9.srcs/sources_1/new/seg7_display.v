`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 02:06:53 PM
// Design Name: 
// Module Name: seg7_display
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


module seg7_display(
    input clk, reset_n,
    input [5:0] total, change,
    output reg [7:0] an,
    output reg [6:0] seg,   // {g,f,e,d,c,b,a}, active low
    output dp
    );
    reg [16:0] refresh;
    always @(posedge clk, negedge reset_n)
        if (~reset_n) refresh <= 0; else refresh <= refresh + 1;
    wire [2:0] sel = refresh[16:14];

    // Values are 0..45 -> tens / ones
    wire [3:0] t_tens = total / 10,  t_ones = total % 10;
    wire [3:0] c_tens = change / 10, c_ones = change % 10;

    reg [3:0] digit;
    reg blank;
    always @(*) begin
        an = 8'hFF;
        an[sel] = 1'b0;
        digit = 4'd0;
        blank = 1'b1;
        case (sel)
            3'd5: begin digit = t_tens; blank = (t_tens == 0); end
            3'd4: begin digit = t_ones; blank = 1'b0; end
            3'd1: begin digit = c_tens; blank = (change == 0); end
            3'd0: begin digit = c_ones; blank = (change == 0); end
            default: ;
        endcase
    end

    always @(*) begin
        if (blank) seg = 7'b1111111;
        else case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
    assign dp = 1'b1;
endmodule
