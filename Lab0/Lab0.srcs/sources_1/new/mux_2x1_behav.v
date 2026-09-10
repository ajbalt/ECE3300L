`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 01:15:34 PM
// Design Name: 
// Module Name: mux_2x1_behav
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


module mux_2x1_behav(
    input x, y, s,
    output reg m
    );
    always@(*) begin
        if(s) m = y;
        else m =x;
    end
endmodule
