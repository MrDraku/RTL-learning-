`timescale 1ps/1ps
module even_parity_tb ;
    reg [3:0] data;
    wire parity;
    //instantiate the even parity generator
    even_parity uut (
        .data(data),
        .parity(parity)
);
    initial begin
        //dump waveforms
        $dumpfile("even_parity_tb.vcd");
        $dumpvars(0, even_parity_tb);
        $monitor("time=%0t, data=%b, parity=%b",
        $time,data,parity);
        //test all cases
       for (integer i = 0; i < 16; i = i + 1) begin
            data = i; #10;
        end
        $finish;
    end
endmodule