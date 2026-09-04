`timescale 1ps/1ps
//==================================================
// Module declaration : uart_tx_tb
//==================================================
module uart_tx_tb ;  
  reg clk ;
  reg reset ;
  reg tx_start ;
  reg [7:0] tx_data ;
  wire tx ;
  wire tx_busy ;

  localparam clk_PER_BIT  = 434,
              HALF_BIT   = clk_PER_BIT / 2 ;
        
    
  //==================================================
  // Instantiate the Unit Under Test (UUT)
  //==================================================

  uart_tx uut (
    .clk(clk),
    .reset(reset),
    .tx_data(tx_data),
    .tx_start(tx_start),
    .tx_busy(tx_busy),
    .tx(tx)
  );
  //==================================================
  // Clock generation
  //==================================================
  initial begin
    clk = 1'b0 ;
    forever #5 clk = ~clk ;
    
  end
  //==================================================
  //TEST :1 :: reset the DUT and check the output
  //==================================================
  task reset_dut ;
    begin
       $display("\n-------------TEST : 1 RESET DUT -------------- \n ") ;
       reset <= 1'b1 ;
      @(posedge clk) ;
      reset <= 1'b0 ;
      // #1 ;
      if (tx_busy !== 1'b0) begin
        $display("ERROR : DUT is busy after reset \n ", $time) ;
      end
       if (tx !== 1'b1) begin
        $display("ERROR : DUT is not idle after reset  \n ", $time) ;
       end
       // selfcheck reset 
       if (tx == 1'b1 && tx_busy == 1'b0) begin
         $display("PASS : DUT is idle after reset \n ", $time) ;
       end
    end
    endtask
  //==================================================
  //TEST :2 ::  Normal trasmission of data
  //==================================================
  task check_bit(input reg expected );
  begin 
    // Sample in the middle of the baud period to avoid edge ambiguity  434 / 2 = 217
    repeat(HALF_BIT) @(posedge clk) ;
    #1; // Avoid race conditions in simulation, sample after posedge clk


    // debug: show shift register and bit counter inside DUT
    //$display("DEBUG: time=%t, tx_start(in uut)=%b, data_reg=%b, shift_reg=%b, bit_counter=%0d, tx=%b", $time, uut.tx_start, uut.data_reg, uut.shift_reg, uut.bit_counter, tx);
    if ( tx === expected ) begin
      $display("PASS : Tx bit is correct   \n ", $time) ;
     
    end else begin
      $display("ERROR : Tx bit is incoorect , expected = %b , actual = %b  \n ", expected, tx, $time) ;
      
    end
    // wait remaining half so next call aligns to next bit period
    repeat(HALF_BIT) @(posedge clk) ;
  end
  endtask

 //=================================================
 // Monituring the DUT
 //=================================================
  initial begin
    $monitor(" \n time=%t, tx=%b, tx_busy=%b, tx_start=%b, tx_data=%h \n ", $time, tx, tx_busy, tx_start, tx_data) ;
  // =================================================
  // waveform dump
  // =================================================
    $dumpfile("wave.vcd") ;
    $dumpvars(0, uart_tx_tb) ;
  end

  //==================================================
  // Main Test  sequence
  //==================================================
  initial begin

     reset = 1'b0 ;
     tx_start = 1'b0 ;
     tx_data = 8'h00 ;

     reset_dut ;
    
 $display("\n---------TEST : 2 NORMAL TRANSMISSION --------- \n ") ;
  // send data 8'h41 
    tx_data = 8'h41 ;
    tx_start = 1'b1 ;
    @(posedge clk) ;
    #1;

    tx_start = 1'b0 ;
    // check tahat TX is busy after start
    if (tx_busy !== 1'b1)
      $display("ERROR : UART  should be busy " , $time) ;
    else 
      $display("PASS : UART is busy after start " , $time) ;
    // 8'h41 = 0100_0001
    //UART sends LSB first, so the sequence of bits sent is: 0100_0001
    check_bit(1'b0) ; // start bit
    check_bit(1'b1) ; // bit 0
    check_bit(1'b0) ; // bit 1
    check_bit(1'b0) ; // bit 2
    check_bit(1'b0) ; // bit 3
    check_bit(1'b0) ; // bit 4
    check_bit(1'b0) ; // bit 5
    check_bit(1'b1) ; // bit 6
    check_bit(1'b0) ; // bit 7
    check_bit(1'b1) ; // stop bit

//==================================================
// TEST 3 : TX_start is asserted while TX is busy
//==================================================
  $display("\n---------TEST : 3 TX_start asserted while TX is busy --------- \n ") ;
        reset_dut ;
  // start first transmission
    tx_data = 8'h41 ;
    tx_start = 1'b1 ;
    @(posedge clk) ;
    #1;
    tx_start = 1'b0 ;
    // check that TX is busy after start
    if (tx_busy !== 1'b1)
      $display("ERROR : UART  should be busy " , $time) ;
    else 
      $display("PASS : UART is busy after start " , $time) ;
     
    // while TX is busy, assert TX_start again with new data
    tx_data = 8'h55 ;
    tx_start = 1'b1 ;
    @(posedge clk) ;
    #1;
    tx_start = 1'b0 ;

    // check that TX is still busy and the data being sent is still the first one (8'h41)
    if (tx_busy !== 1'b1)
      $display("ERROR : UART should still be busy " , $time) ;
    else 
      $display("PASS : UART is still busy after second start " , $time) ;

      //==================================================
      // proof that the second data (8'h55) is not sent until the first transmission is complete
      // 8'h41 = 0100_0001 . Ignpore (8'h55 = 0101_0101)
      //==================================================
      check_bit(1'b0) ; // start bit of first transmission
      check_bit(1'b1) ; // DATA0 
      check_bit(1'b0) ; // DATA1
      check_bit(1'b0) ; // DATA2
      check_bit(1'b0) ; // DATA3
      check_bit(1'b0) ; // DATA4
      check_bit(1'b0) ; // DATA5
      check_bit(1'b1) ; // DATA6
      check_bit(1'b0) ; // DATA7
      check_bit(1'b1) ; // stop bit of first transmission

      //==================================================
      //TEST 4 : BACK TO BACK TRANSMISSION
      //==================================================
      $display("\n---------TEST : 4 BACK TO BACK TRANSMISSION --------- \n ") ;
      
      reset_dut ;
      // send first data 8'h41
      tx_data = 8'h41 ;
      tx_start = 1'b1 ;
      @(posedge clk) ;
      #1;
      tx_start = 1'b0 ;
      // wait for first transmission to complete
      while (tx_busy == 1'b1) begin
        @(posedge clk) ;
        #1;
      end
      // send second data 8'h55
      tx_data = 8'h55 ;
      tx_start = 1'b1 ;
      @(posedge clk) ;
      #1;
      tx_start = 1'b0 ;
      if (tx_busy !== 1'b1)
        $display("ERROR : UART  should be busy " , $time) ;
      else 
        $display("PASS : UART is busy after start " , $time) ;
      // 8'h55 = 0101_0101
      check_bit(1'b0) ; // start bit of second transmission
      check_bit(1'b1) ; // DATA0
      check_bit(1'b0) ; // DATA1
      check_bit(1'b1) ; // DATA2
      check_bit(1'b0) ; // DATA3
      check_bit(1'b1) ; // DATA4
      check_bit(1'b0) ; // DATA5
      check_bit(1'b1) ; // DATA6
      check_bit(1'b0) ; // DATA7
      check_bit(1'b1) ; // stop bit of second transmission

      //==================================================
      // END OF BASIC TESTS
      //==================================================
      $display("\n===========================================================\n");
      $display("UART TX BASIC TESTBENCH COMPLETE\n");
      $display("===========================================================\n");

     $finish ;
  end
endmodule