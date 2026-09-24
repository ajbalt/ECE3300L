`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 01:33:13 PM
// Design Name: 
// Module Name: decoder_generic
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


module decoder_generic
    #(parameter N = 3)(
    input [N - 1:0] w,
    input en,
    output reg [0:2 ** N - 1] y
    );
    
    always @(w, en)
    begin
        y = 'b0;
        if (en)
            y[w] = 1'b1; 
        else
            y = 'b0;
    end
endmodule
