module alu (
    input[3:0] a, b,
    input[1:0] sel,
    output reg[3:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = a + b; // add
            2'b01: out = a - b; // subtract
            2'b10: out = a & b; // and 
            2'b11: out = a|b;    // or
            
            default: out = 4'b0000; // Default case
        endcase
    end
endmodule