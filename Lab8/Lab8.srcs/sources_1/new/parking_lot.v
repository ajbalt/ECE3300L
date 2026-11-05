`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 02:41:30 PM
// Design Name: 
// Module Name: parking_lot
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


module parking_lot #(parameter FINAL_VALUE = 50000)(
    input clk,
    input CPU_RESETN,
    input BTNL,  //sensor a
    input BTNR,  //sensor b
    output [6:0] sseg,
    output [7:0] AN,
    output DP
    );

     // Synchronize the asynchronous button inputs (2-FF) before debouncing
    reg [1:0] sync_a, sync_b;
    always @(posedge clk)
    begin
        sync_a <= {sync_a[0], BTNL};
        sync_b <= {sync_b[0], BTNR};
    end

    debouncer_delayed DB_A (
        .clk(clk),
        .reset_n(CPU_RESETN),
        .noisy(sync_a[1]),
        .debounced(a)
    );

    debouncer_delayed DB_B(
        .clk(clk),
        .reset_n(CPU_RESETN),
        .noisy(sync_b[1]),
        .debounced(b)
    );

    // Entry/exit detection
    wire car_enter, car_exit;

    parking_fsm FSM0(
        .clk(clk),
        .reset_n(CPU_RESETN),
        .a(a),
        .b(b),
        .car_enter(car_enter),
        .car_exit(car_exit)
    );

    wire [7:0] count;
    wire count_en;

    assign count_en = (car_enter & (count != 8'd255)) |
                      (car_exit  & (count != 8'd0));

    udl_counter #(.BITS(8)) CNT0(
        .clk(clk),
        .reset_n(CPU_RESETN),
        .enable(count_en),
        .up(car_enter),
        .load(1'b0),
        .D(8'b0),
        .Q(count)
    );

    // Binary to BCD for display
    wire [11:0] bcd;

    bin2bcd BCD0(
        .bin(count),
        .bcd(bcd)
    );

    // Show hundreds/tens/ones on the three rightmost digits (I5, I6, I7)
    sseg_driver #(.FINAL_VALUE(FINAL_VALUE)) DISP0(
        .clk(clk),
        .reset_n(CPU_RESETN),
        .I0(6'b000000),
        .I1(6'b000000),
        .I2(6'b000000),
        .I3(6'b000000),
        .I4(6'b000000),
        .I5({1'b1, bcd[11:8], 1'b0}),
        .I6({1'b1, bcd[7:4],  1'b0}),
        .I7({1'b1, bcd[3:0],  1'b0}),
        .sseg(sseg),
        .AN(AN),
        .DP(DP)
    );

endmodule
