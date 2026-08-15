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
    // TASK: PULSE A SIGNAL
    // =========================================================================
    // Generic transition task using signal id to avoid passing regs by reference
    // sig_id mapping: 0=start,1=water_fill,2=wash_done,3=drain_done,4=spin_done,5=done_timer_out,6=door_open
    task transition_signal(
        input integer sig_id,
        input integer pulse_width,
        input [8*16-1:0] signal_name
    );
        begin
            $display("Time=%0t: Pulsing %s", $time, signal_name);
            case (sig_id)
                0: start = 1'b1;
                1: water_fill = 1'b1;
                2: wash_done = 1'b1;
                3: drain_done = 1'b1;
                4: spin_done = 1'b1;
                5: done_timer_out = 1'b1;
                6: door_open = 1'b1;
                default: ;
            endcase

            #pulse_width;

            case (sig_id)
                0: start = 1'b0;
                1: water_fill = 1'b0;
                2: wash_done = 1'b0;
                3: drain_done = 1'b0;
                4: spin_done = 1'b0;
                5: done_timer_out = 1'b0;
                6: door_open = 1'b0;
                default: ;
            endcase

            // Allow FSM to respond
            #30;
        end
    endtask

    // =========================================================================
    // TASK: RUN NORMAL WASHING CYCLE
    // =========================================================================
    task run_full_cycle;

        begin

            $display("\n========================================");
            $display("       NORMAL WASH CYCLE");
            $display("========================================");

            // IDLE -> WATER_FILL
            transition_signal(0, 20, "start");

            // WATER_FILL -> WASH
            transition_signal(1, 20, "water_fill");

            // WASH -> DRAIN
            transition_signal(2, 20, "wash_done");

            // DRAIN -> SPIN
            transition_signal(3, 20, "drain_done");

            // SPIN -> DONE
            transition_signal(4, 20, "spin_done");

            // DONE -> IDLE
            transition_signal(5, 20, "done_timer_out");

            // DONE requires door_open as well.
            // Open the door after timer expires.
            transition_signal(6, 20, "door_open");

            $display("Time=%0t: Normal cycle complete",
                     $time);

        end

    endtask

    // =========================================================================
    // TASK: TEST DOOR-OPEN PAUSE
    // =========================================================================
    task test_door_pause;

        begin

            $display("\n========================================");
            $display("       DOOR OPEN / PAUSE TEST");
            $display("========================================");


            // IDLE -> WATER_FILL
            transition_signal(0, 20, "start");

            // WATER_FILL -> WASH
            transition_signal(1, 20, "water_fill");

            // Open door while WASH is active
            $display("Time=%0t: Opening door during WASH",
                     $time);

            door_open = 1'b1;

            #20;

            // Close door and resume WASH
            $display("Time=%0t: Closing door - RESUME",
                     $time);

            door_open = 1'b0;

            #30;

            $display("Time=%0t: Door pause test complete",
                     $time);

            // Complete the remaining cycle
            transition_signal(2, 20, "wash_done");
            transition_signal(3, 20, "drain_done");
            transition_signal(4, 20, "spin_done");

        end

    endtask

    // =========================================================================
    // TASK: TEST TEMPERATURE ERROR
    // =========================================================================
    task test_temperature_error;

        begin

            $display("\n========================================");
            $display("       TEMPERATURE ERROR TEST");
            $display("========================================");

            // IDLE -> WATER_FILL
            transition_signal(0, 20, "start");

            // WATER_FILL -> WASH
            transition_signal(1, 20, "water_fill");

            // Critical temperature occurs during WASH
            $display("Time=%0t: CRITICAL TEMPERATURE ASSERTED",
                     $time);

            temp_critical = 1'b1;

            #30;

            // Clear critical temperature
            $display("Time=%0t: CRITICAL TEMPERATURE CLEARED",
                     $time);

            temp_critical = 1'b0;

            #30;

            $display("Time=%0t: Temperature error test complete",
                     $time);

        end

    endtask

    // =========================================================================
    // TASK: TEST HIGH TEMPERATURE / HEATER
    // =========================================================================
    task test_high_temperature;

        begin

            $display("\n========================================");
            $display("       HIGH TEMPERATURE TEST");
            $display("========================================");

            // IDLE -> WATER_FILL
            transition_signal(0, 20, "start");

            // WATER_FILL -> WASH
            transition_signal(1, 20, "water_fill");

            // Normal WASH: heater should be ON
            #10;

            $display("Time=%0t: Checking heater during normal WASH",
                     $time);

            // High temperature occurs
            temp_high = 1'b1;

            #20;

            $display("Time=%0t: temp_high asserted - heater should turn OFF",
                     $time);

            // Clear high temperature
            temp_high = 1'b0;

            #20;

            $display("Time=%0t: High temperature test complete",
                     $time);

        end

    endtask

    // =========================================================================
    // MAIN TEST SEQUENCE
    // =========================================================================
    initial begin

        // ---------------------------------------------------------------------
        // Waveform dump
        // ---------------------------------------------------------------------
        $dumpfile("waves.vcd");
        $dumpvars(0, Washing_Mac_moore_tb);

        // ---------------------------------------------------------------------
        // Initial values
        // ---------------------------------------------------------------------
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

        // ---------------------------------------------------------------------
        // Reset
        // ---------------------------------------------------------------------
        #20;

        reset = 1'b0;

        #20;

        $display("\n");
        $display("============================================================");
        $display("       SMART WASHING MACHINE FSM TESTBENCH");
        $display("============================================================");

        $display("\nTime\tState\tWater\tWash\tDrain\tSpin\tHeat\tDone");

        // ---------------------------------------------------------------------
        // TEST 1: Normal operation
        // ---------------------------------------------------------------------
        run_full_cycle;

        // ---------------------------------------------------------------------
        // TEST 2: Door pause / resume
        // ---------------------------------------------------------------------
        test_door_pause;

        // ---------------------------------------------------------------------
        // TEST 3: Temperature error
        // ---------------------------------------------------------------------
        test_temperature_error;

        // ---------------------------------------------------------------------
        // TEST 4: High temperature / heater control
        // ---------------------------------------------------------------------
        test_high_temperature;

        // ---------------------------------------------------------------------
        // End simulation
        // ---------------------------------------------------------------------
        $display("\n============================================================");
        $display("              SIMULATION COMPLETE");
        $display("============================================================");

        #50;

        $finish;

    end

    // =========================================================================
    // MONITOR
    // =========================================================================
    always @(posedge clk) begin

        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                 $time,
                 current_state,
                 water_valve,
                 wash_motor,
                 drain_pump,
                 spin_motor,
                 heater,
                 done);

    end

    // =========================================================================
    // SAFETY ASSERTION 1
    // =========================================================================
    // Washing/spinning and draining must never happen simultaneously.
    // =========================================================================
    always @(posedge clk) begin

        if ((wash_motor || spin_motor) && drain_pump) begin

            $display("ASSERTION FAILED at %0t:",
                     $time);

            $display("  Motor and drain pump are active simultaneously!");

        end

    end

    // =========================================================================
    // SAFETY ASSERTION 2
    // =========================================================================
    // Heater must be OFF when temperature is high.
    // =========================================================================
    always @(posedge clk) begin

        if (heater && temp_high) begin

            $display("ASSERTION FAILED at %0t:",
                     $time);

            $display("  Heater is ON while temp_high is asserted!");

        end

    end

    // =========================================================================
    // SAFETY ASSERTION 3
    // =========================================================================
    // Critical temperature must force ERROR.
    // =========================================================================
    always @(posedge clk) begin

        if (temp_critical &&
            current_state != ERROR &&
            current_state != PAUSE) begin

            $display("WARNING at %0t:",
                     $time);

            $display("  Critical temperature asserted - FSM should enter ERROR.");

        end

    end

endmodule
