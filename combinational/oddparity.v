module odd_parity (
    input[2:0]data,
    output reg parity
);
    always @(*) begin
        parity = ~(data[2] ^ data[1] ^ data[0]); // XOR of all bits to determine parity
    end
endmodule