module demux_1x2 (
    input in,
    input [1:0] sel, // 1-bit select signal
    output reg [3:0] out // 4-bit output
);
    always @(*) begin
        // we can use sift operations to route the input to the correct output based on sel
        // y = (in << sel); // shift the input to the left by sel positions
        
        case (sel)
            2'b00: out[0] = in; // Route to output 0
            2'b01: out[1] = in; // Route to output 1
            2'b10: out[2] = in; // Route to output 2
            2'b11: out[3] = in; // Route to output 3
            default: out = 4'b0000; // Default case (should not occur)
        endcase
    end
endmodule