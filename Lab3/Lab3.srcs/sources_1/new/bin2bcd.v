`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 04:48:42 PM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
    input [7:0] bin,
    output [11:0] bcd
    );

    wire [3:0] o4, o5, o6, o7, o8;
    wire [3:0] t7, t8;

    // Before shift 4: ones nibble can reach 7
    add_3 add3_o4 (.A({1'b0, bin[7], bin[6], bin[5]}), .S(o4));

    // Before shift 5: ones
    add_3 add3_o5 (.A({o4[2:0], bin[4]}),              .S(o5));

    // Before shift 6: ones
    add_3 add3_o6 (.A({o5[2:0], bin[3]}),              .S(o6));

    // Before shift 7: ones and tens
    add_3 add3_o7 (.A({o6[2:0], bin[2]}),              .S(o7));
    add_3 add3_t7 (.A({1'b0, o4[3], o5[3], o6[3]}),   .S(t7));

    // Before shift 8: ones and tens
    add_3 add3_o8 (.A({o7[2:0], bin[1]}),              .S(o8));
    add_3 add3_t8 (.A({t7[2:0], o7[3]}),               .S(t8));

    // Final result after shift 8 brings in bin[0]
    assign bcd[3:0]  = {o8[2:0], bin[0]};        // ones
    assign bcd[7:4]  = {t8[2:0], o8[3]};         // tens
    assign bcd[11:8] = {2'b00, t7[3], t8[3]};    // hundreds
    
endmodule
