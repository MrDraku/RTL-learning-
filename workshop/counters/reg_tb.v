`timescale 1ns/1ps
module reg_tb;
    reg clk;
    reg en;
    reg reset;
    reg [7:0] d;
    wire [7:0] q;
    reg8 uut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .d(d),
        .q(q)
    );
initial begin
    clk = 0;
    d =0;
    en = 0;
   reset = 1; 

    $dumpfile("reg_tb.vcd");
    $dumpvars(0, reg_tb);
    $monitor("At time %t, d = %b, q = %b", $time, d, q);
    en = 1; reset = 0;
    d = 8'b00000001; #20;
    en = 0; reset = 0;
    d = 8'b00000010; #20;
    en = 1; reset = 1;
    d = 8'b00000100; #20;
    en = 0; reset = 1;
    d = 8'b00001000; #20;
    en = 1; reset = 1;
    d = 8'b00011111; #20;
    en = 0; reset = 1;
    d = 8'b00100000; #20;
    $finish;
end

always #10 clk = ~clk;

endmodule