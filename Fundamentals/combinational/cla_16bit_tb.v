`timescale 1ps/1ps
module cla_16bit_tb ;
    reg [15:0] a, b;
    reg c0;
    wire [15:0] sum;
    wire carry_out;

    cla_16bit uut (
        .a(a),
        .b(b),
        .cin(c0),
        .sum(sum),
        .cout(carry_out)
    );

    initial begin
        $dumpfile("cla_16bit_tb.vcd");
        $dumpvars(0, cla_16bit_tb);
        $display("Starting exhaustive testing of 16-bit CLA...");
        c0 = 0; // initialize c0 to 0
        repeat (1000) begin // run 1000 iterations
            a = $random; // assign random value to a
            b = $random; // assign random value to b
            #10; // wait for 10 time units

            // Check the result against the expected value
            if (sum !== (a + b + c0)) begin
                $display("Test failed for a=%h, b=%h, c0=%b: expected sum=%h, got sum=%h", a, b, c0, (a + b + c0), sum);
                $stop;
            end
        end
    
        $finish;
    end
endmodule