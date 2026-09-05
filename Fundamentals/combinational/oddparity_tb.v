`timescale 1ps/1ps
module odd_parity_tb ;
    reg [2:0] data;
    wire parity;
    //instantiate the odd parity generator
    odd_parity uut (
        .data(data),
        .parity(parity)
);
    initial begin
        //dump waveforms
        $dumpfile("odd_parity_tb.vcd");
        $dumpvars(0, odd_parity_tb);
        $monitor("time=%0t, data=%b, parity=%b",
        $time,data,parity);
        //test all cases
         data = 3'b000; #10;
         data = 3'b001; #10;
         data = 3'b010; #10;
         data = 3'b011; #10;
         data = 3'b100; #10;
         data = 3'b101; #10;
         data = 3'b110; #10;
         data = 3'b111; #10;

    $finish;
    end
endmodule