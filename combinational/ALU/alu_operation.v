module ALU_operation (
    input [3:0] a, b,
    input [2:0] sel,// 3-bit select signal to choose the operation(controle bits = 8 operations)
    output reg [3:0] out
);
    always @(*) begin
        case (sel)
            3'b000: out = a + b; // add
            3'b001: out = a - b; // subtract
            3'b010: out = a & b; // and 
            3'b011: out = a | b; // or
            3'b100: out = a ^ b; // xor
            3'b101: out = ~a;    // not a
            3'b110: out = a << 1; // left shift a by 1
            3'b111: begin
                if (a > b)        // compare a and b, if a is greater than b, set out to 1, else set out to 0
                    out = 4'b0001;
                else
                    out = 4'b0000;
            end
            
            default: out = 4'b0000; // Default case
        endcase
    end
endmodule