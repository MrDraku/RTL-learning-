`timescale 1ps/1ps
module ALU_operation_tb;
    reg [3:0] a, b;
    reg [2:0] sel;
    wire [3:0] out;
    // Instantiate the ALU
     ALU_operation uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    initial begin
         $dumpfile("ALU_operation_tb.vcd");
        $dumpvars(0, ALU_operation_tb);
        $monitor("Time: %0t | a: %b | b: %b | sel: %b | out: %b", $time, a, b, sel, out);
        // Test cases
        // addition
        a = 4'b0001; b = 4'b0010; sel = 3'b000; #10; // 1 + 2 = 3
        // subtraction
        a = 4'b1001; b = 4'b0011; sel = 3'b001; #10; // 9 - 3 = 6
        // and
        a = 4'b1100; b = 4'b1010; sel = 3'b010; #10; // 1100 & 1010 = 1000
        // or
        a = 4'b1100; b = 4'b1010; sel = 3'b011; #10; // 1100 | 1010 = 1110
        // xor
        a = 4'b1100; b = 4'b1010; sel = 3'b100; #10; // 1100 ^ 1010 = 0110
        // not a
        a = 4'b1100; sel = 3'b101; #10; // ~1100 = 0011
        // left shift a by 1
        a = 4'b1100; sel = 3'b110; #10; // 1100 << 1 = 1000 (in 4-bit, this will wrap around to 1000)
        // compare a and b
        a = 4'b1001; b = 4'b0011; sel = 3'b111; #10; // 9 > 3, out should be 1
        a = 4'b0010; b = 4'b0100; sel = 3'b111; #10; // 2 > 4, out should be 0
        a = 4'b0100; b = 4'b0100; sel = 3'b111; #10; // 4 > 4, out should be 0
        $finish;
    end
endmodule