module cla_16bit (
    input [15:0] a,b,
    input    cin,
    output [15:0] sum,
    output cout
);
    wire c4,c8,c12;
    // 4-bit CLA blocks  cla4bit_adder
    cla4bit_adder bo(a[3:0], b[3:0], cin, sum[3:0], c4);
    cla4bit_adder bo1(a[7:4], b[7:4], c4, sum[7:4], c8);
    cla4bit_adder b02(a[11:8], b[11:8], c8, sum[11:8], c12);
    cla4bit_adder b03(a[15:12], b[15:12], c12, sum[15:12], cout);
endmodule