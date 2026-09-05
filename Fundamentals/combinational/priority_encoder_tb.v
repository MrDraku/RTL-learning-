`timescale 1ps/1ps
module priority_encoder_tb;
    reg [3:0] in;
    wire [1:0] out;
    wire valid;
    // Instantiate the priority encoder
    priority_encoder uut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    initial begin
        // Dump waveforms
        $dumpfile("priority_encoder_tb.vcd");
        $dumpvars(0, priority_encoder_tb);
        $monitor("time=%0t, in=%b, out=%b, valid=%b", $time, in, out, valid);
        // Test all input combinations
          for (integer i = 0; i < 16; i = i + 1) begin
              in = i; // assign value to input
              #10; // wait for 10 time units
          end
        $finish;
    end
endmodule