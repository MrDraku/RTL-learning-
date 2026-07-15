module register (clk , rst, en, d, q);
  input clk, rst, en;
  input [3:0] d;
  output reg [3:0] q;
  initial
    q = 4'b0000;

  always @(posedge clk ) begin
    if (rst)
      q <= 4'b0000;
    else if (en)
      q <= d;
  end
endmodule