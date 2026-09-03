module Washing_Mac_moore (
    // inputs
    input  clk,
    input  reset,
    input  start,
    input  water_fill,
    input  wash_done,
    input  drain_done,
    input  spin_done,
    input  door_open,
    input  temp_high,
    input  temp_critical,
    input  done_timer_out,

    // outputs
    output reg water_valve,
    output reg wash_motor,
    output reg drain_pump,
    output reg spin_motor,
    output reg heater,
    output reg done,
    output reg [2:0] current_state
);

    // state encoding
    localparam IDLE       = 3'b000,
               WATER_FILL = 3'b001,
               WASH       = 3'b010,
               DRAIN      = 3'b011,
               SPIN       = 3'b100,
               DONE       = 3'b101,
               PAUSE      = 3'b110,
               ERROR      = 3'b111;

    reg [2:0] next_state;
    reg [2:0] previous_state;

    // next-state combinational logic
    always @(*) begin
        next_state = current_state; // default hold
        case (current_state)
            IDLE: begin
                if (start && !door_open)
                    next_state = WATER_FILL;
            end
            WATER_FILL: begin
                if (temp_critical)
                    next_state = ERROR;
                else if (door_open)
                    next_state = PAUSE;
                else if (water_fill)
                    next_state = WASH;
            end
            WASH: begin
                if (temp_critical)
                    next_state = ERROR;
                else if (door_open)
                    next_state = PAUSE;
                else if (wash_done)
                    next_state = DRAIN;
            end
            DRAIN: begin
                if (temp_critical)
                    next_state = ERROR;
                else if (door_open)
                    next_state = PAUSE;
                else if (drain_done)
                    next_state = SPIN;
            end
            SPIN: begin
                if (temp_critical)
                    next_state = ERROR;
                else if (door_open)
                    next_state = PAUSE;
                else if (spin_done)
                    next_state = DONE;
            end
            DONE: begin
                // return to IDLE only when timer expired and door opened
                if (done_timer_out && door_open)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            PAUSE: begin
                if (!door_open)
                    next_state = previous_state;
            end
            ERROR: begin
                if (!temp_critical)
                    next_state = previous_state;
            end
            default: next_state = IDLE;
        endcase
    end

    // state register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state  <= IDLE;
            previous_state <= IDLE;
        end else begin
            if ((next_state == PAUSE || next_state == ERROR) && (current_state != PAUSE && current_state != ERROR)) begin
                previous_state <= current_state;
            end
            current_state <= next_state;
        end
    end

    // output combinational logic
    always @(*) begin
        water_valve = 1'b0;
        wash_motor  = 1'b0;
        drain_pump  = 1'b0;
        spin_motor  = 1'b0;
        heater      = 1'b0;
        done        = 1'b0;

        case (current_state)
            IDLE: begin end
            WATER_FILL: water_valve = 1'b1;
            WASH: begin
                wash_motor = 1'b1;
                if (!temp_high)
                    heater = 1'b1;
            end
            DRAIN: drain_pump = 1'b1;
            SPIN:  spin_motor = 1'b1;
            DONE:  done = 1'b1;
            PAUSE: begin end
            ERROR: begin end
            default: begin end
        endcase
    end

endmodule