`timescale 1ps/1ps
module mux_2to1_tb;
reg a,b,sel;
wire y;
mux_2to1 uut(
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);

initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,mux_2to1_tb);
        $monitor("time=%0t, a=%b, b=%b, sel=%b => y=%b", $time, a, b, sel, y);
         for (integer i = 0; i < 8; i = i + 1) begin
            {a, b, sel} = i; // Assigns the binary representation of i to a, b, and sel
            #10; // Wait for 10 time units before the next assignment
        end

        $finish;

       
      
       
    end
    
endmodule