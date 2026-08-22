`timescale 1ns/1ps

module Washing_Mac_moore_tb;

    // DUT INPUTS
    reg clk;
    reg reset;
    reg start;
    reg water_fill;
    reg wash_done;
    reg drain_done;
    reg spin_done;
    reg door_open;
    reg temp_high;
    reg temp_critical;
    reg done_timer_out;

    // =========================================================================
    // DUT OUTPUTS
    // =========================================================================
    wire water_valve;
    wire wash_motor;
    wire drain_pump;
    wire spin_motor;
    wire heater;
    wire done;
    wire [2:0] current_state;

    // =========================================================================
    // STATE NAMES FOR DISPLAY
    // =========================================================================
    localparam IDLE        = 3'b000,
               WATER_FILL  = 3'b001,
               WASH        = 3'b010,
               DRAIN       = 3'b011,
               SPIN        = 3'b100,
               DONE        = 3'b101,
               PAUSE       = 3'b110,
               ERROR       = 3'b111;

       //=========================================================================        
                    // TEST COUNTERS
       //=========================================================================
       integer pass_count;
       integer fail_count;

    // =========================================================================
    // DUT INSTANTIATION
    // =========================================================================
    Washing_Mac_moore uut (

        .clk(clk),
        .reset(reset),
        .start(start),
        .water_fill(water_fill),
        .wash_done(wash_done),
        .drain_done(drain_done),
        .spin_done(spin_done),
        .door_open(door_open),
        .temp_high(temp_high),
        .temp_critical(temp_critical),
        .done_timer_out(done_timer_out),

        .water_valve(water_valve),
        .wash_motor(wash_motor),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor),
        .heater(heater),
        .done(done),
        .current_state(current_state)
    );

    // =========================================================================
    // CLOCK GENERATION
    // =========================================================================
    initial begin
        clk = 0;

        forever #5 clk = ~clk;   // 10 ns clock period
    end

    // =========================================================================
        //STATE NAME FUNCTION
    // =========================================================================
    function [8*16-1:0] state_name;  // returns a string representation of the state
        input [2:0] state;
        begin
            case (state)
                IDLE:
                    state_name = "IDLE";
                WATER_FILL:
                    state_name = "WATER_FILL";
                WASH:
                    state_name = "WASH";
                DRAIN:
                    state_name = "DRAIN";
                SPIN:
                    state_name = "SPIN";
                DONE:
                    state_name = "DONE";
                PAUSE:
                    state_name = "PAUSE";
                ERROR:
                    state_name = "ERROR";
                default:
                    state_name = "UNKNOWN";
            endcase
        end
    endfunction
    //============================================================================
        // TASK : CHECK STATE
    //============================================================================
    task check_state;
        input [2:0] expected_state;
        begin
            if (current_state == expected_state) begin
                $display("PASS | Time = %0t ns | Current State = %s", $time, state_name(current_state));
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Time = %0t ns | Expected State = %s  Actual State = %s", $time, state_name(expected_state), state_name(current_state));
                fail_count = fail_count + 1;
            end
        end
    endtask
    //============================================================================
     // TASK : CHECK OUTPUTS
    //============================================================================
    task check_outputs;
      input expected_water_valve;
      input expected_wash_motor;
      input expected_drain_pump;
      input expected_spin_motor;
      input expected_heater;
      input expected_done;
      begin
        if ((water_valve == expected_water_valve) && (wash_motor == expected_wash_motor) &&
           (drain_pump == expected_drain_pump) && (spin_motor == expected_spin_motor) &&
           (heater == expected_heater) && (done == expected_done)) begin
          $display("PASS | Time = %0t ns | Outputs are as expected", $time);
          pass_count = pass_count + 1;
        end else begin
                $display ("FAIL | Time = %0t ns | Outputs are NOT as expected", $time);
                $display("Expected: WV=%b, WM=%b, DP=%b, SM=%b, H=%b, D=%b", expected_water_valve, expected_wash_motor, expected_drain_pump, expected_spin_motor, expected_heater, expected_done);
                $display("Actual:   WV=%b, WM=%b, DP=%b, SM=%b, H=%b, D=%b", water_valve, wash_motor, drain_pump, spin_motor, heater, done);
                fail_count = fail_count + 1;
            end
        end
    endtask
    //============================================================================
       // TASK : CHECK STATE + OUTPUTS
    //============================================================================
    task check_state_and_outputs;
          input [2:0] expected_state;

            input expected_water_valve;
            input expected_wash_motor;
            input expected_drain_pump;
            input expected_spin_motor;
            input expected_heater;
            input expected_done;
        begin
            check_state(expected_state);
            check_outputs(expected_water_valve, expected_wash_motor, expected_drain_pump, expected_spin_motor, expected_heater, expected_done);
        end
    endtask
    //============================================================================
      // TASK : RESET DUT
    //============================================================================
    task reset_dut;
        begin
            $display ("\n--- Resetting DUT ---\n");
                reset      = 1'b1;
                start      = 1'b0;
                water_fill = 1'b0;
                wash_done  = 1'b0;
                drain_done = 1'b0;
                spin_done  = 1'b0;
                door_open  = 1'b0;
                temp_high  = 1'b0;
                temp_critical = 1'b0;
                done_timer_out = 1'b0;
          #15;
                check_state_and_outputs(IDLE, 
                 1'b0,    // water_valve
                 1'b0,    // wash_motor
                 1'b0,    // drain_pump
                 1'b0,    // spin_motor
                 1'b0,    // heater
                 1'b0     // done 
                 );   
           reset = 1'b0;  #10;
        end
    endtask
    //============================================================================
    // TASK :  PULSE SIGNAL
    //============================================================================
    task pulse_start;
      begin 
        start = 1'b1;
        @(posedge clk);  // wait for the next clock edge
        start = 1'b0;  #1;
      end
    endtask
    task pulse_water_fill;
      begin 
        water_fill = 1'b1;
        @(posedge clk);  
        water_fill = 1'b0;  #1;
      end
    endtask
    task pulse_wash_done;
      begin 
        wash_done = 1'b1;
        @(posedge clk);  
        wash_done = 1'b0;  #1;
      end
    endtask
    task pulse_drain_done;
      begin 
        drain_done = 1'b1;
        @(posedge clk);  
        drain_done = 1'b0;  #1;
      end
    endtask
    task pulse_spin_done;
      begin 
        spin_done = 1'b1;
        @(posedge clk);  
        spin_done = 1'b0;  #1;
      end
    endtask
    //============================================================================
    // TEST 1 
    // NORMAL COMPLETION OF WASHING CYCLE
    //============================================================================
    task test_normal_cycle;
        begin
            $display ("\n--- Test 1: Normal Completion of Washing Cycle ---\n");
             // IDEL 
             pulse_start;
             check_state_and_outputs(
                3 'b000,  // IDEL
                0,0,0,0,0,0
             );
             // IDEL -> WATER_FILL
             pulse_start;

             check_state_and_outputs(
                3'b001,   //WATER_FILL
                1,0,0,0,0,0
             );
             // WATER_FILL -> WASH
             pulse_start;

              check_state_and_outputs(
                3'b010, // WASH
                0,1,0,0,1,0
              );
              // WASH -> DRAIN
              pulse_start;

              check_state_and_outputs(
                3'b011,  //DRAIN
                0,0,1,0,0,0
              );
              // DRAIN -> SPIN
              pulse_start ;
              check_state_and_outputs(
                3'b100,  // SPIN
                0,0,0,1,0,0
              );
              // SPIN-> DONE
              pulse_start;
              check_state_and_outputs(
                3'b101,
                0,0,0,0,0,1
              );
          // -------------------------------------------------------------------------------
          // DONE -> IDLE
          // DUT requires both `done_timer_out` and `door_open` asserted together
          // -------------------------------------------------------------------------------
                done_timer_out = 1'b1;
                door_open      = 1'b1;
                @(posedge clk);
                done_timer_out = 1'b0;
                door_open      = 1'b0;
                #1;
                check_state_and_outputs(
                    3'b000,
                    0,0,0,0,0,0
                );
                $display("TEST 1 COMPLETE");
                end
    endtask
      //======================================================================
      //TEST 2 : DOOR OPEN -> PAUSE -> RESUME
      //=======================================================================
      task test_door_pause;
      begin $display("\n----------TEST 2 : DOOR PAUSE/ RESUME-----------\n");
      // START 
      pulse_start;
      check_state(WATER_FILL);
      // WATER_FILL -> WASH

      pulse_water_fill;
      check_state(WASH);
      check_outputs(
        0,1,0,0,1,0
      );
      //----------------------------------------------
       // OPEN DOOR DURING WASH
       //---------------------------------------------
       door_open = 1'b1;
       @(posedge clk);
      #1;
      check_state_and_outputs(
        PAUSE,
        0,0,0,0,0,0
      );
           //---------------------------------------------------------------------
                     // cloose door 
              // previous state = wash
           // pause -> wash

           door_open = 1'b0;
                  @(posedge clk);
                #1;
           cheak_state_and_outputs(
                     WASH,
                      0,1,0,0,1,0
           );
               $display("TEST 2 COMPLETED");
      end
 endtask



    
 
