module Washing_Mac_moore(
    // inputs
    input clk,
    input reset,
    input start,
    input water_fill,
    input wash_done,
    input drain_done,
    input spin_done,
    input door_open,
    input temp_high,
    input temp_critical,
    input done_timer_out,

    // outputs
    output reg water_value,
    output reg wash_motor,
    output reg drain_pump,
    output reg spin_motor,
    output reg heater,
    output reg done,
    output reg [2:0] curret_state
);

    // state encoding binary
    localparam IDLE = 3'b000,
               WATER_FILL = 3'b001,
               WASH = 3'b010,
               DRINE = 3'b011,
               SPIN = 3'b100,
               DONE = 3'b101,
               paush = 3'b110,
               error = 3'b111;

    reg [2:0] next_state;
    reg [2:0] previous_state;

    // next-state logic
    always @(*) begin
        next_state = curret_state;  // default to hold state
        case (curret_state)
            IDLE: begin
                if (start && !door_open)
                    next_state = WATER_FILL;
            end
            WATER_FILL: begin
                if (temp_critical)
                    next_state = error;
                else if (door_open)
                    next_state = paush;
                else if (water_fill)
                    next_state = WASH;
            end
            WASH: begin
                if (temp_critical)
                    next_state = error;
                else if (door_open)
                    next_state = paush;
                else if (wash_done)
                    next_state = DRINE;
            end
            DRINE: begin
                if (temp_critical)
                    next_state = error;
                else if (door_open)
                    next_state = paush;
                else if (drain_done)
                    next_state = SPIN;
            end
            SPIN: begin
                if (temp_critical)
                    next_state = error;
                else if (door_open)
                    next_state = paush;
                else if (spin_done)
                    next_state = DONE;
            end
            DONE: begin
                if (done_timer_out && !door_open)
                    next_state = DONE;
                else if (done_timer_out && door_open) 
                    next_state = IDLE;
            end
            paush: begin
                if (!door_open)
                    next_state = previous_state;
            end
            error: begin
                if (!temp_critical)
                    next_state = previous_state;
            end
            default: next_state = IDLE;
        endcase
    end

    // state update (state register) store fsm states
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            curret_state <= IDLE;
            previous_state <= IDLE;  // wont be used in reset state, but we can set it to IDLE for safety
        end else if (next_state == paush ) begin
            previous_state <= curret_state;
        end else begin
            curret_state <= next_state;
        end
    end
           // output logic
    always @(*) begin
        water_value = 1'b0;
        wash_motor = 1'b0;
        drain_pump = 1'b0;
        spin_motor = 1'b0;
        heater = 1'b0;
        done = 1'b0;
          // state-based output logic
        case (curret_state)
            IDLE: begin
                water_value = 1'b1; // default case, since all outputs are 0, we can set one output to 1 to indicate the machine is idle
            end
            WATER_FILL: begin
                water_value = 1'b1;
            end
            WASH: begin
                wash_motor = 1'b1;
                if (!temp_high)
                    heater = 1'b1;
            end
            DRINE: begin                drain_pump = 1'b1;
            end
            SPIN: begin
                spin_motor = 1'b1;
            end
            DONE: begin
                done = 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule