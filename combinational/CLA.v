module cla4bit_adder (
    input[3:0] a, b,
    input c0,
    output reg [3:0] sum,
    output reg carry_out
);
    reg [3:0] p, g; // propagate and generate (procedural regs)
    reg c1, c2, c3, c4; // carry signals for each bit

    // procedural combinational block
    always @(*) begin
        // calculate propagate and generate signals
        p = a ^ b; // propagate is the XOR of the inputs
        g = a & b; // generate is the AND of the inputs

        // calculate carry signals
        c1 = g[0] | (p[0] & c0); // carry for bit 1
        c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0); // carry for bit 2
        c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0); // carry for bit 3
        c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0); // carry for bit 4

        // calculate sum bits and final carry out
        sum[0] = p[0] ^ c0;
        sum[1] = p[1] ^ c1;
        sum[2] = p[2] ^ c2;
        sum[3] = p[3] ^ c3;

        carry_out = c4;
    end
endmodule
