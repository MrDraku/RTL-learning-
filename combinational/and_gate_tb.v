`timescale 1ns/1ps
module and_gate_tb;
reg a, b;
wire y;
and_gate uut  //what hardware iam  building
    //preferred way to connect signals(port mapping, readability, maintainability,avoiding errors
    (
    .a(a),
    .b(b),
    .y(y)
);
/* testbuilder initial begin   (how do systematically test the hardware) 
    $monitor("time=%0t, a=%b, b=%b => y=%b", $time, a, b, y);
end*/
initial begin
    $dumpfile("and_gate_tb.vcd");
    $dumpvars(0, and_gate_tb);
    $monitor("time=%0t, a=%b, b=%b => y=%b", $time, a, b, y);
    // for loop to test all combinations of a and b (scalability)
       for (integer i = 0; i < 4; i = i + 1) begin
        {a, b} = i; // Assigns the binary representation of i to a and b
        #10; // Wait for 10 time units before the next assignment
    end
    $finish;
end
endmodule
 // for better simulation 
       //a = 0; b = 0; sel = 0; #10;
        //a = 0; b = 0; sel = 1; #10;
        //a = 0; b = 1; sel = 0; #10;
       // a = 0; b = 1; sel = 1; #10;
       // a = 1; b = 0; sel = 0; #10;
       // a = 1; b = 0; sel = 1; #10;
       // a = 1; b = 1; sel = 0; #10;
       // a = 1; b = 1; sel = 1; #10;
     // using case  
    //   case(sel)
      //      0: $display("Selected input: a=%b", a);
      //      1: $display("Selected input: b=%b", b);
        //  endcase
     /*   case ({a,b,sel}).        (compact,readable,scalable)
            3'b000: $display("Selected input: a=%b", a);
            3'b001: $display("Selected input: b=%b", b);
            3'b010: $display("Selected input: a=%b", a);
            3'b011: $display("Selected input: b=%b", b);
            3'b100: $display("Selected input: a=%b", a);
            3'b101: $display("Selected input: b=%b", b);
            3'b110: $display("Selected input: a=%b", a);
            3'b111: $display("Selected input: b=%b", b);
        

        endcase */