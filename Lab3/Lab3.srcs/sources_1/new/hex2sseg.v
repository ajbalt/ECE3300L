`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2026 07:52:48 PM
// Design Name: 
// Module Name: hex2sseg
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


module hex2sseg(
    input [3:0] hex,
    output reg [6:0] sseg //arragned as gfedcba
    );
    
    always @(hex)
        case(hex) //gfedcba
            0:  sseg = 7'b1000000; // 0: all segs on except g
            1:  sseg = 7'b1111001; // 1: b,c
            2:  sseg = 7'b0100100; // 2: a,b,d,e,g
            3:  sseg = 7'b0110000; // 3: a,b,c,d,g
            4:  sseg = 7'b0011001; // 4: b,c,f,g
            5:  sseg = 7'b0010010; // 5: a,c,d,f,g
            6:  sseg = 7'b0000010; // 6: a,c,d,e,f,g
            7:  sseg = 7'b1111000; // 7: a,b,c
            8:  sseg = 7'b0000000; // 8: all segs on
            9:  sseg = 7'b0010000; // 9: a,b,c,d,f,g
            10: sseg = 7'b0001000; // A: a,b,c,e,f,g
            11: sseg = 7'b0000011; // b: c,d,e,f,g
            12: sseg = 7'b1000110; // C: a,d,e,f
            13: sseg = 7'b0100001; // d: b,c,d,e,g
            14: sseg = 7'b0000110; // E: a,d,e,f,g
            15: sseg = 7'b0001110; // F: a,e,f,g
        endcase 
endmodule
