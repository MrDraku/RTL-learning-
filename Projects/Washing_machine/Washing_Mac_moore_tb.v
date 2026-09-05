`timescale 1ns/1ps

module Washing_Mac_moore_tb;

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

    wire water_valve;
    wire wash_motor;
    wire drain_pump;
    wire spin_motor;
    wire heater;
    wire done;
    wire [2:0] current_state;

    localparam IDLE       = 3'b000,
               WATER_FILL = 3'b001,
               WASH       = 3'b010,
               DRAIN      = 3'b011,
               SPIN       = 3'b100,
               DONE       = 3'b101,
               PAUSE      = 3'b110,
               ERROR      = 3'b111;

    integer pass_count;
    integer fail_count;

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

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
     // Foe readability in simulation output 
    function [8*16-1:0] state_name;   //  returning a text sting  => 128bits = 2^8 => 128 -1 = 127
     // 16 - char text string 
        input [2:0] state;
        begin
            case (state)
                IDLE:       state_name = "IDLE";
                WATER_FILL: state_name = "WATER_FILL";
                WASH:       state_name = "WASH";
                DRAIN:      state_name = "DRAIN";
                SPIN:       state_name = "SPIN";
                DONE:       state_name = "DONE";
                PAUSE:      state_name = "PAUSE";
                ERROR:      state_name = "ERROR";
                default:    state_name = "UNKNOWN";
            endcase
        end
    endfunction

    task check_state;  // for self cheaking
        input [2:0] expected_state;
        begin
            if (current_state == expected_state) begin
                $display("PASS | Time = %0t  | Current State = %s", $time, state_name(current_state));
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Time = %0t  | Expected State = %s  Actual State = %s", $time, state_name(expected_state), state_name(current_state));
                fail_count = fail_count + 1;
            end
        end
    endtask

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
                $display("PASS | Time = %0t  | Outputs are as expected \n", $time);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Time = %0t  | Outputs are NOT as expected \n", $time);
                $display("Expected: WV=%b, WM=%b, DP=%b, SM=%b, H=%b, D=%b \n", expected_water_valve, expected_wash_motor, expected_drain_pump, expected_spin_motor, expected_heater, expected_done);
                $display("Actual:   WV=%b, WM=%b, DP=%b, SM=%b, H=%b, D=%b \n", water_valve, wash_motor, drain_pump, spin_motor, heater, done);
                fail_count = fail_count + 1;
            end
        end
    endtask
      // verify STATE + OUTPUTS at the same time
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

    task reset_dut;
        begin
            $display("\n--- Resetting DUT ---\n");
            reset          = 1'b1;
            start          = 1'b0;
            water_fill     = 1'b0;
            wash_done      = 1'b0;
            drain_done     = 1'b0;
            spin_done      = 1'b0;
            door_open      = 1'b0;
            temp_high      = 1'b0;
            temp_critical  = 1'b0;
            done_timer_out = 1'b0;
            #15;
            check_state_and_outputs(IDLE,
                1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
            );
            reset = 1'b0;
            #10;
        end
    endtask

    task pulse_start;
        begin
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;
            #1;
        end
    endtask

    task pulse_water_fill;
        begin
            water_fill = 1'b1;
            @(posedge clk);
            water_fill = 1'b0;
            #1;
        end
    endtask

    task pulse_wash_done;
        begin
            wash_done = 1'b1;
            @(posedge clk);
            wash_done = 1'b0;
            #1;
        end
    endtask

    task pulse_drain_done;
        begin
            drain_done = 1'b1;
            @(posedge clk);
            drain_done = 1'b0;
            #1;
        end
    endtask

    task pulse_spin_done;
        begin
            spin_done = 1'b1;
            @(posedge clk);
            spin_done = 1'b0;
            #1;
        end
    endtask

    task test_normal_cycle;
        begin
            $display("\n--- Test 1: Normal Completion of Washing Cycle ---\n");

            pulse_start;
            check_state_and_outputs(
                WATER_FILL,
                1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
            );

            pulse_water_fill;
            check_state_and_outputs(
                WASH,
                1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0
            );

            pulse_wash_done;
            check_state_and_outputs(
                DRAIN,
                1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0
            );

            pulse_drain_done;
            check_state_and_outputs(
                SPIN,
                1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0
            );

            pulse_spin_done;
            check_state_and_outputs(
                DONE,
                1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1
            );

            done_timer_out = 1'b1;
            door_open      = 1'b1;
            @(posedge clk);
            done_timer_out = 1'b0;
            door_open      = 1'b0;
            #1;
            check_state_and_outputs(
                IDLE,
                1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
            );
            $display("TEST 1 COMPLETE");
        end
    endtask

    task test_door_pause;
        begin
            $display("\n----------TEST 2 : DOOR PAUSE/ RESUME-----------\n");

            pulse_start;
            check_state_and_outputs(
                WATER_FILL,
                1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
            );

            pulse_water_fill;
            check_state_and_outputs(
                WASH,
                1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0
            );

            door_open = 1'b1;
            @(posedge clk);
            #1;
            check_state_and_outputs(
                PAUSE,
                1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
            );

            door_open = 1'b0;
            @(posedge clk);
            #1;
            check_state_and_outputs(
                WASH,
                1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0
            );

            $display("***********TEST 2 COMPLETED*****************");
        end
    endtask
    task test_temperature_error;
    begin
        $display("\n-------------TEST 3: CRITICAL TEMPERATUE----------------\n");
        pulse_start;
        check_state(WATER_FILL);

        // WATER_FILL -> WASH
        pulse_water_fill;
        check_state(WASH);

        // Critical Temp
        temp_critical =1'b1;
        @(posedge clk);
        #1;
        check_state_and_outputs(
            ERROR,
            0,0,0,0,0,0
        );
        //-----------------------------------------------------------
        // clear critical_temp =>> ERROR -> Previous_state  =>> WASH
        //-----------------------------------------------------------
        temp_critical =1'b0;
        @(posedge clk);
        #1;
        check_state_and_outputs(
            WASH,
            0,1,0,0,1,0
        );
        $display("--------TEST 3 COMPLETE");
    end
    endtask
    //-----------------------------------------------------------------------------
    // TEST 4
    // HIGH TEMP -> HEATER OFF
    //-------------------------------------------------------------------------------
    task test_high_temperature;
    begin
        $display("\n---------------TEST 4: HIGH TEMPERATURE/HEATER ------------------\n");
        pulse_start;
        check_state(WATER_FILL);

        // WATER_FILL -> WASH 
        pulse_water_fill;
        check_state(WASH);
        check_outputs(
        0,1,0,0,1,0
        ); // heater initialy be ON 

        temp_high = 1'b1;  // Heater shoulde be off
        #1;
        check_outputs(
            0,1,0,0,0,0
        );
        temp_high =1'b0;
        #1;
        check_outputs(
            0,1,0,0,1,0
        );
        $display("************** TEST 4 : COMPLETE***************************");
    end
    endtask

    //=============================================================================
    // TEST 5 => DOOR_OPEN -> DURING WATER_FILL
    //=============================================================================
    task test_pause_from_water_fill;
    begin
        $display("\n------------------TEST 5: PAUSE FROM WATER_FILL----------------------\n");
        pulse_start;
        check_state(WATER_FILL);
        door_open = 1'b1; // Open door
        @(posedge clk);
        #1;
        check_state_and_outputs(
            PAUSE,
            0,0,0,0,0,0
        );
        // Close door
        door_open = 1'b0;
        @(posedge clk);
        #1;
        check_state_and_outputs(
            WATER_FILL,
            1,0,0,0,0,0
        );
        $display("***************** TEST 5 COMPLETE*****************");
    end
    endtask
    //==============================================================================
    // TEST 6 : CRITICAL TEMPERATURE DURING DRAIN
    //================================================================================
    task test_error_from_drain;
    begin
        $display("\n -----------------TEST 6 : CRITICAL TEMP DURING DRAIN--------------------\n");
        pulse_start;
        pulse_water_fill;
        pulse_wash_done;

        check_state(DRAIN);

        temp_critical = 1'b1;
        @(posedge clk );
        #1;
        check_state_and_outputs(
            ERROR,
            0,0,0,0,0,0
        );

        temp_critical = 1'b0;
        @(posedge clk );
        #1;
        check_state_and_outputs(
            DRAIN,
            0,0,1,0,0,0
        );
        $display("************************* TEST 6 COMPLETE ***********************");
    end
    endtask

    //===================================================================================
    // SAFTEY CHECK 
    // WASH/SPIN motor and DRAIN pump -> X never together 
    // HEATER must never be ON when temp_high is asserted 
    //========================================================================================
    always @(posedge clk) begin
        if ((wash_motor || spin_motor) && (drain_pump)) begin
            $display("FAIL | SAFETY | Time = %t | Motor and drain pump activated together ", $time);
            fail_count = fail_count + 1;
        end
        if (heater && temp_high) begin
            $display("FAIL | SAFETY | Time = %t | Heater on during temperature high!!", $time);
            fail_count = fail_count + 1;
        end
    end


        // MONITORE 
    always @(posedge clk) begin
        $display("MONITOR | T =%t | STATE=%s | wv =%b wm =%b DP =%b SM =%b H= %b DONE= %b ",
             $time, state_name(current_state), water_valve, wash_motor, drain_pump, spin_motor, heater, done);
    end
    initial begin 
        $dumpfile("wave.vcd");
        $dumpvars(0, Washing_Mac_moore_tb);
    end

    initial begin
      // count Initilization
        pass_count = 0;
        fail_count = 0;
        //-----------------------------------------------
        //Initial signal values
        //----------------------------------------------------
        reset            = 1'b0;
        start            = 1'b0;
        water_fill       = 1'b0;
        wash_done        = 1'b0;
        drain_done       = 1'b0;
        spin_done        = 1'b0;
        door_open        = 1'b0;
        temp_high        = 1'b0;
        temp_critical    = 1'b0;
        done_timer_out   = 1'b0;

    
        reset_dut;
        test_normal_cycle;

        reset_dut;
        test_door_pause;

        reset_dut;
        test_temperature_error;

        reset_dut;
        test_high_temperature;

        reset_dut;
        test_pause_from_water_fill;

        reset_dut;
        test_error_from_drain;


        #20;
        $display("\n -------------------          VERIFICATION SUMMARY    --------------------------      \n");
        $display(" PASS COUNT =%d ", pass_count);
        $display("FAIL COUNT =%d", fail_count);
        if (fail_count == 0) begin
            $display("");
            $display("********* TEST PASSED *************");
        end else begin
            $display("");
            $display("************* TEST FAILED **************");
        end
        $display("===========================================================");
        #10;
        $finish;
    end
    
endmodule
