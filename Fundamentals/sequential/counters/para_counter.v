module para_counter #(
    parameter N = 8,
    parameter MAX = (1<<N) - 1
)(
    input clk,
    input reset,
    input en,
    output reg [N-1:0] count,
    output  tc
);
 assign tc = (count == MAX[N-1:0]) && en;

 initial begin
    count = {N{1'b0}};
 end

always @(posedge clk) begin
    if (reset)
        count <= {N{1'b0}};
    else if (tc)
        count <= {N{1'b0}};
    else if (en)
        count <= count + {{(N-1){1'b0}}, 1'b1};
end
endmodule
