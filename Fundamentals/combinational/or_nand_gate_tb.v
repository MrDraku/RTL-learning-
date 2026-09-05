
`timescale 1ns/1ps
module or_nand_gate_tb ;
    reg a,b;
wire y;
    or_nand_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );
    initial begin
        $dumpfile("or_nand_gate_tb.vcd");
        $dumpvars(0, or_nand_gate_tb);
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $finish;
    end
    endmodule