`timescale 1ns/1ps

module para_counter_tb;
  parameter N = 2;
  parameter MAX = (1 << N) - 1;

  reg clk;
  reg en;
  reg reset;
  wire [N-1:0] count;
  wire tc;

  para_counter #(.N(N)) uut (
      .clk(clk),
      .reset(reset),
      .en(en),
      .count(count),
      .tc(tc)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // awlauy@()
  end

  task  apply_reset;   // better to use auto task when calling same veriabel twice in the same task
    begin
      reset = 1;
      en = 0;
      @(posedge clk);
      reset = 0;
      @(posedge clk);
    end
  endtask

  task apply_counter;
    input [N-1:0] value;
    integer i;
    begin
      en = 1;
      for (i = 0; i < 5; i = i + 1) begin
        @(posedge clk);
      end
      en = 0;
    end
  endtask

  function [N-1:0] next_counter;
    input [N-1:0] current_count;
    begin
      if (current_count == MAX) begin
        next_counter = 0;
      end else begin
        next_counter = current_count + 1;
      end
    end
  endfunction
 // actual simlation
  initial begin
    $dumpfile("para_counter.vcd");  // file generation 
    $dumpvars(0, para_counter_tb);
    $monitor("time=%0t clk=%b en=%b reset=%b count=%b tc=%b", $time, clk, en, reset, count, tc);

    apply_reset();

    en = 0;
    repeat (3) @(posedge clk);

    apply_counter(5);

    en = 1;
    while (count != MAX) begin
      @(posedge clk);
    end
    while (!tc) @(posedge clk);
    $display("Counter reached MAX value: %b, tc=%b", count, tc);
    @(posedge clk);   // delay
    $display(" after wrap , count=%b, tc=%b", count, tc);  // same as printf in c 
    $display("Test completed successfully");
    $finish;   // finish the function call
  end
endmodule
