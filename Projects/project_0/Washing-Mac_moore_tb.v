`timescale 1ns/1ps
module Washing_Mac_moore_tb;
    reg clk;
    reg reset;
    reg start;
    reg water_fill, wash_done, drain_done, spin_done;
    reg door_open, temp_high, temp_critical, done_timer_out;
    wire [2:0] curret_state;
    wire water_value, wash_motor, drain_pump, spin_motor, heater, done;

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
        .water_value(water_value),
        .wash_motor(wash_motor),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor),
        .heater(heater),
        .done(done),
        .curret_state(curret_state)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_task;
        begin
            reset = 1;
            #10;
            reset = 0;
        end
    endtask

    task pulse_signal;
        input integer duration;
        inout reg  signal;  // read -write signal
        begin
            signal = 1;
            #(duration);
            signal = 0;
            #10;
        end
    endtask

    task transition;
        input integer duration;
        inout reg  signal;
        input [255:0] name;
        begin
            $display("Transitioning via %s to 1 for %0d time units", name, duration);
            pulse_signal(duration, signal);
        end
    endtask

    task run_full_cycle;
        begin
            $display("\nStarting full cycle test");
            transition(20, start, "start (IDLE to WATER_FILL)");
            transition(20, water_fill, "water_fill (WATER_FILL to WASH)");
            transition(20, wash_done, "wash_done (WASH to DRINE)");
            transition(20, drain_done, "drain_done (DRINE to SPIN)");
            transition(20, spin_done, "spin_done (SPIN to DONE)");
            transition(20, done_timer_out, "done_timer_out (DONE to IDLE)");
            $display("Time=%t: Full cycle test completed\n", $time);
        end
    endtask

    task door_open_safety_test;
        begin
            $display("\nStarting door open safety test");
            transition(20, start, "start (WATER_FILL -> WASH)");
            door_open = 1;
            #20;
            door_open = 0;
            $display("Time=%t: Door open safety check complete", $time);
        end
    endtask

    task test_temp_high;
        begin
            $display("\nStarting temp high safety test");
            transition(20, start, "start (WATER_FILL -> WASH)");
            temp_high = 1;
            #20;
            temp_high = 0;
            $display("Time=%t: temp_high test complete", $time);
        end
    endtask

    task test_temp_critical_loop;
        integer count;
        begin
            $display("\nStress test for temp_critical safety");
            transition(20, start, "start (WATER_FILL -> WASH)");
            count = 0;
            while (count < 5) begin
                $display("Time=%t: temp_critical pulse #%d", $time, count + 1);
                temp_critical = 1;
                #20;
                temp_critical = 0;
                #10;
                count = count + 1;
            end
            $display("Time=%t: temp_critical loop complete", $time);
        end
    endtask

    initial begin
        $dumpfile("Washing_Mac_moore_tb.vcd");
        $dumpvars(0, Washing_Mac_moore_tb);

        reset = 1;
        start = 0;
        water_fill = 0;
        wash_done = 0;
        drain_done = 0;
        spin_done = 0;
        door_open = 0;
        temp_high = 0;
        temp_critical = 0;
        done_timer_out = 0;

        reset_task();
        $display("===== Washing machine FSM test =====");

        run_full_cycle();
        door_open_safety_test();
        test_temp_high();
        test_temp_critical_loop();

        $display("===== Washing machine FSM test completed =====");
        $finish;
    end
endmodule
