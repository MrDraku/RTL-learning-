module even_parity (
    input[3:0]data,
    output reg parity
);
    always @(*) begin
        parity = data[3] ^ data[2] ^ data[1] ^ data[0]; // XOR of all bits to determine parity
    end
endmodule