module priority_encoder (
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);
     // behavioral model using case statement to determine the output based on the highest priority input
    always @(*) begin
        valid = 1'b1; // assume valid unless no input is high
        casex (in)
            4'b1xxx: out = 2'b11; // highest priority
            4'b01xx: out = 2'b10;
            4'b001x: out = 2'b01;
            4'b0001: out = 2'b00; // lowest priority
            default: begin
                out = 2'b00; // default output when no input is high
                valid = 1'b0; // not valid if no input is high
            end
        endcase
    end
endmodule