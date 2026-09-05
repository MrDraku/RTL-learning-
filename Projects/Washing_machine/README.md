# Smart Washing Machine Controller (Moore FSM)

This project implements a washing machine control unit using a Moore finite-state machine in Verilog. The controller coordinates machine operation based on sensor and user inputs such as start, door status, water level, temperature, and completion signals.

## Overview

The design models a realistic washing cycle with the following operational states:

- `IDLE`
- `WATER_FILL`
- `WASH`
- `DRAIN`
- `SPIN`
- `DONE`
- `PAUSE`
- `ERROR`

The controller responds to external inputs and drives actuator outputs such as:

- `water_valve`
- `wash_motor`
- `drain_pump`
- `spin_motor`
- `heater`
- `done`

## RTL Design

The main module is:

- `Washing_Mac_moore.v`

The testbench used for functional verification is:

- `Washing_Mac_moore_tb.v`

## State Encoding

The FSM uses a 3-bit state encoding:

```verilog
localparam IDLE       = 3'b000,
           WATER_FILL = 3'b001,
           WASH       = 3'b010,
           DRAIN      = 3'b011,
           SPIN       = 3'b100,
           DONE       = 3'b101,
           PAUSE      = 3'b110,
           ERROR      = 3'b111;
```

## Inputs and Outputs

### Inputs

- `clk`
- `reset`
- `start`
- `water_fill`
- `wash_done`
- `drain_done`
- `spin_done`
- `door_open`
- `temp_high`
- `temp_critical`
- `done_timer_out`

### Outputs

- `water_valve`
- `wash_motor`
- `drain_pump`
- `spin_motor`
- `heater`
- `done`
- `current_state`

## FSM Behavior

The controller is designed to behave as follows:

- `IDLE`: waits for the machine to start
- `WATER_FILL`: fills the drum until water is detected
- `WASH`: runs the wash motor and heater when needed
- `DRAIN`: drains the water after washing
- `SPIN`: spins the drum after draining
- `DONE`: indicates that the cycle has finished
- `PAUSE`: pauses when the door is opened
- `ERROR`: handles critical temperature faults

The design includes safe transitions for fault handling, door-open conditions, and recovery back to the previous valid state.

## Verification

The design is checked using a self-checking Verilog testbench with tasks and status displays. The testbench verifies:

- reset behavior
- state transitions
- output control for each phase
- pause handling
- error handling
- back-to-back operation

### Quick Start

```bash
verilator --lint-only -Wall Washing_Mac_moore.v
```

```bash
iverilog Washing_Mac_moore_tb.v Washing_Mac_moore.v -o washing_machine_tb
vvp washing_machine_tb
```

```bash
gtkwave wave.vcd
```

## Tools Used

- Verilog HDL
- Verilator
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git

## Project Structure

```text
Washing_machine/
├── README.md
├── Washing_Mac_moore.v
├── Washing_Mac_moore_tb.v
├── wave.vcd
├── sim/
└── ...
```

## Status

The Moore FSM controller for the washing machine has been designed, linted, and functionally verified using simulation. The project demonstrates real-world digital design concepts including sequential logic, state machines, and hardware verification.
