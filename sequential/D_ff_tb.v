`timescale 1ns/1ps
module D_ff_tb;

reg clk, rst, d;
wire q;
D_ff uut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, D_ff_tb);
    $monitor($time, " clk=%b rst=%b d=%b q=%b", clk, rst, d, q);
    
    rst = 1;
    d = 0;
    #10 rst = 0;
    #10 d = 1;
    #10 d = 1;
    #10 d = 1;
    #10 d = 0;
    #10 d = 0;
    #10 $finish;
end
endmodule