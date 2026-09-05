`timescale 1ps/1ps
module CLA4bit_adder_tb ;
    reg [3:0] a, b;
    reg c0;
    wire [3:0] sum;
    wire carry_out;

    cla4bit_adder uut (
        .a(a),
        .b(b),
        .c0(c0),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        $dumpfile("CLA4bit_adder_tb.vcd");
        $dumpvars(0, CLA4bit_adder_tb);
        c0 = 0; // initialize c0 to 0
        $monitor("a = %b, b = %b, c0 = %b, sum = %b, carry_out = %b", a, b, c0, sum, carry_out);
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                a = i; // assign value to a
                b = j; // assign value to b
                #5; // wait for 5 time units
            end
        end
        c0 =1
         for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                a = i; // assign value to a
                b = j; // assign value to b
                #5; // wait for 5 time units
            end
        end

        $finish;
    end
endmodule
/* initial begin
self checking testbench
    if({cout,sum} !== expected) begin
        $display("Test failed for a=%b, b=%b, c0=%b: expected {carry_out,sum}=%b, got {carry_out,sum}=%b", a, b, c0, expected, {carry_out,sum});
     $stop;
     end
     $display("All tests passed!");
        $finish;
        endmodule */