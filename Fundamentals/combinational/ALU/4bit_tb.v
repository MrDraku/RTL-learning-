`timescale 1ps/1ps
module ALU_4bit_tb;
    reg [3:0] a, b;
    reg [1:0] sel;
    wire [3:0] out;
    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    initial begin
        $dumpfile("ALU_4bit_tb.vcd");
        $dumpvars(0, ALU_4bit_tb);
        $monitor("Time: %0t | a: %b | b: %b | sel: %b | out: %b", $time, a, b, sel, out);
        // Test cases
        // addition
        a = 4'b0001; b = 4'b0010; sel = 3'b000; #10; // 1 + 2 = 3
        a = 4'b0101; b = 4'b0011; sel = 3'b000; #10; // 5 + 3 = 8
        // subtraction
        a = 4'b0101; b = 4'b0010; sel = 3'b001; #10; // 5 - 2 = 3
        a = 4'b0010; b = 4'b0100; sel = 3'b001; #10; // 2 - 4 = -2 (in 4-bit, this will wrap around to 14)
        // and
        a = 4'b1100; b = 4'b1010; sel = 3'b010; #10; // 1100 & 1010 = 1000
        a = 4'b1111; b = 4'b0000; sel = 3'b010; #10; // 1111 & 0000 = 0000
        // or
        a = 4'b1100; b = 4'b1010; sel = 3'b011; #10; // 1100 | 1010 = 1110
        a = 4'b1111; b = 4'b0000; sel = 3'b011; #10; // 1111 | 0000 = 1111
        // edge cases
        a = 4'b1111; b = 4'b1111; sel = 3'b000; #10; // 15 + 15 = 30 (in 4-bit, this will wrap around to 14)
        a = 4'b0000; b = 4'b0000; sel = 3'b001; #10; // 0 - 0 = 0
        a = 4'b0000; b = 4'b0000; sel = 3'b010; #10; // 0 & 0 = 0
        a = 4'b0000; b = 4'b0000; sel = 3'b011; #10; // 0 | 0 = 0
        $finish;
    end
endmodule