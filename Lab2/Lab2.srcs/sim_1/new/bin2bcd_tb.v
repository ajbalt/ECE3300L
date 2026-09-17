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
    integer errors = 0;
    reg [3:0] exp_hundreds, exp_tens, exp_ones;

    initial begin
        for(i = 0; i <= 255; i = i +1) begin
            bin = i;
            #1; // Wait for the conversion to complete

            // Calculate expected BCD values
            exp_hundreds = (i / 100) % 10;
            exp_tens = (i / 10) % 10;
            exp_ones = i % 10;

            if (bcd[11:8] !== exp_hundreds ||
                bcd[7:4]  !== exp_tens     ||
                bcd[3:0]  !== exp_ones) begin

                $display("FAIL: bin=%0d  got %0d%0d%0d  expected %0d%0d%0d",
                         i,
                         bcd[11:8], bcd[7:4], bcd[3:0],
                         exp_hundreds, exp_tens, exp_ones);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("ALL TESTS PASSED (256/256)");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end
endmodule
