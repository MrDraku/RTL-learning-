`timescale 1ns/1ps

module register_tb;
  reg clk;
  reg rst, en;
  reg [3:0] d;
  wire [3:0] q;

  register uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d),
    .q(q)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test stimulus
  initial begin
    $dumpfile("register.vcd");
    $dumpvars(0, register_tb);
    $monitor($time, " clk=%b rst=%b en=%b d=%b q=%b", clk, rst, en, d, q);

    rst = 1;
    en = 0;
    d = 4'b0000;

    #20 rst = 0;
    @(negedge clk);
    en = 1;
    d = 4'b1010;
    @(posedge clk);
    d = 4'b1100;
    @(posedge clk);
    en = 0;
    @(posedge clk);
    d = 4'b1111;
    @(posedge clk);
    en = 1;
    @(posedge clk);
    $finish;
  end
endmodule
/*
`timescale 1ns/1ps

module register_tb;
  reg clk;
  reg rst;
  reg en;    
  reg [3:0] d;
  wire [3:0] q;

  register uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d),
    .q(q)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  task expect;
    input [3:0] exp;
    begin
      #1;
      if (q !== exp) begin
        $display("ERROR at %0t: expected q=%b, got %b", $time, exp, q);
        $finish;
      end
    end
  endtask

  initial begin
    $dumpfile("register.vcd");
    $dumpvars(0, register_tb);

    // Reset test
    rst = 1;
    en = 0;
    d = 4'b0000;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    expect(4'b0000);

    // Hold test
    d = 4'b1010;
    @(posedge clk);
    expect(4'b0000);

    // Load test
    en = 1;
    @(posedge clk);
    expect(4'b1010);

    // Another load
    d = 4'b1100;
    @(posedge clk);
    expect(4'b1100);

    // Hold again
    en = 0;
    d = 4'b1111;
    @(posedge clk);
    expect(4'b1100);

    // Re-enable load
    en = 1;
    @(posedge clk);
    expect(4'b1111);

    $display("All tests passed");
    $finish;
  end
endmodule
*/