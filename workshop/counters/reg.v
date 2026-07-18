module reg8 (
    input clk,
    input en,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (en)
            q <= d;
    end 

endmodule