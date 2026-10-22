`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 05:24:18 PM
// Design Name: 
// Module Name: dual_sequence_detector_tb
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


module dual_sequence_detector_tb();

reg clk = 0, reset = 1, x = 0;
wire y;

dual_sequence_detector uut(.clk(clk), .reset(reset), .x(x), .y(y));

always #5 clk = ~clk;

reg [15:0] stream = 16'b0101001001110001;
integer i;

initial begin
    #12 reset = 0;
    for (i = 15; i >= 0; i = i-1) begin
        x = stream[i];
        @(negedge clk);
    end
    $finish;
end

endmodule
