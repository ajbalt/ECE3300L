`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 05:01:23 PM
// Design Name: 
// Module Name: bin2bcd_tb
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


module bin2bcd_tb();

    reg [7:0] bin;
    wire [11:0] bcd;

    bin2bcd uut (
        .bin(bin),
        .bcd(bcd)
    );

    integer i;
    reg [3:0] exp_hundreds, exp_tens, exp_ones;

    initial begin
        bin = 8'b0;
        exp_hundreds = 0;
        exp_tens = 0;
        exp_ones = 0;

        for(i = 0; i <= 255; i = i +1) begin
            bin = i;

            // Calculate expected BCD values
            exp_hundreds = (i / 100) % 10;
            exp_tens = (i / 10) % 10;
            exp_ones = i % 10;

            #1; // Wait for the conversion to complete
        end
        $finish;
    end
endmodule
