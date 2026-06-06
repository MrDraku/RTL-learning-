`timescale 1ps/1ps
module demux_tb;
    reg in;
    reg [1:0] sel;
    wire [3:0] out;
    // Instantiate the demux
    demux_1x2 uut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    initial begin
        // Test  all case using a loop
        $dumpfile("demux_tb.vcd");
        $dumpvars(0, demux_tb);
        for (integer i = 0; i < 16; i = i + 1) begin
            {sel, in} = i; // Set sel and in based on loop index
            #10; // Wait for 10 time units
            $display("sel: %b, in: %b => out: %b", sel, in, out); // Display the results
        end
        $finish; // End the simulation
    end
endmodule