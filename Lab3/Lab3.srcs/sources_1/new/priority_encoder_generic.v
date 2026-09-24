`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2026 07:39:06 PM
// Design Name: 
// Module Name: priority_encoder_generic
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


module priority_encoder_generic
    #(parameter N = 4)(
    input [N - 1:0] w,
    output z,
    output reg [$clog2(N) - 1:0] y
    );

    assign z = |2; //reduction OR

    integer k;

    always @(w)
    begin
        y = 'bx;
        for (k = 0; k < N; k = k + 1)
            if (w[k])
                y = k;
    end
endmodule
