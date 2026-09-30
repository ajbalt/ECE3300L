`timescale 1ns / 1ps

module accumulator
    #(parameter BITS = 4)(
        input clk,
        input reset_n,  //acctive-low: 0
        input load,
        input add_n,    // 0 = add, 1 = subtract
        input [BITS-1:0] X,
        output [BITS-1:0] Q
    );

    wire [BITS-1:0] sum;
    wire c_out, overflow;

    //Adder/subtractor:
    adder_subtractor #(.n(BITS)) alu (
        .x(Q),
        .y(X),
        .add_n(add_n),
        .s(sum),
        .c_out(c_out),
        .overflow(overflow)
    );

    //Register - two-always-block style with reset and laod enable
    reg[BITS-1:0] Q_reg, Q_next;

    always @(reset_n, load, Q_reg) begin
        if(!reset_n) Q_next = {BITS{1'b0}};
        else if (load) Q_next = sum;
        else Q_next = Q_reg;
    end

    assign Q = Q_reg;
endmodule