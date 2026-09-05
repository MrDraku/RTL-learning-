`timescale 1ps/1ps
module comparator_2bit_tb;
    reg [3:0] a, b;
    wire gt, eq, lt;
    comparator2bit uut (
        .a(a),
        .b(b),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );
    initial begin
       $dumpfile("comparator_2bit_tb.vcd");
       $dumpvars(0, comparator_2bit_tb);
         $display("Starting exhaustive testing of 2-bit comparator...");
         $display("time=%0t, a=%b, b=%b, gt=%b, eq=%b, lt=%b", $time, a, b, gt, eq, lt);
           for (integer i = 0; i < 32; i = i + 1) begin
               for (integer j = 0; j < 32; j = j + 1) begin
                   a = i; // assign value to a
                   b = j; // assign value to b
                   #10; // wait for 10 time units
               end
           end
         $display("Exhaustive testing completed.");
         $finish;
    end
endmodule