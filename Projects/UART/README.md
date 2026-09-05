# UART Transmitter Design

This project implements a simple 8-bit UART transmitter in Verilog. The design transmits one byte at a time using a finite-state machine (FSM), a baud-rate counter, and a shift register. It is verified using a dedicated testbench and can be linted and synthesized with open-source tools.

## Features

- 8-bit UART TX module
- 4-state FSM: IDLE, START, DATA, STOP
- Parameterized baud-rate generation using `CLK_PER_BIT`
- `tx_busy` signal to indicate active transmission
- Reset handling for safe startup
- Testbench-based verification for normal and edge-case transmission behavior

## RTL Architecture

The transmitter consists of:

- `tx_data` input register
- internal `data_reg` and `shift_reg`
- `baud_counter` for timing control
- `bit_counter` to track transmitted data bits
- control FSM to manage transmission states

The serial output is driven bit-by-bit, LSB first, in standard UART format:

- 1 start bit (`0`)
- 8 data bits (LSB first)
- 1 stop bit (`1`)

## Module Details

Main RTL file:

- `uart_tx.v`

Testbench file:

- `uart_tx_tb..sv`

Generated synthesis output:

- `uart_tx_synth.v`

Circuit diagram:

- `uart_circuit.png`
- `uart_circuit.dot`

## FSM Behavior

The transmitter state machine follows:

```text
IDLE --> START --> DATA --> STOP --> IDLE
```

Behavior summary:

- `IDLE`: waits for `tx_start`
- `START`: drives the line low for one bit period
- `DATA`: shifts out 8 bits
- `STOP`: drives the line high for one bit period

## Verification

The design is verified through a SystemVerilog testbench that checks:

- reset behavior
- normal data transmission
- TX busy signal behavior
- back-to-back transmissions
- repeated start assertions while busy

Simulation waveform output is captured as:

- `wave.vcd`

### Quick Start

```bash
verilator --lint-only -Wall uart_tx.v
```

```bash
iverilog -g2012 uart_tx_tb..sv uart_tx.v -o uart_tx_tb.out
vvp uart_tx_tb.out
```

```bash
gtkwave wave.vcd
```

## Synthesis

The design was synthesized using Yosys and the generated netlist is stored in `uart_tx_synth.v`.

## Project Tools

- Verilog
- SystemVerilog
- Verilator
- Icarus Verilog
- GTKWave
- Yosys
- Graphviz

## Status

RTL design, linting, simulation, and synthesis for the UART transmitter are complete.

## Notes

The implementation uses a baud period of approximately 434 clock cycles at 50 MHz to achieve a UART baud rate of 115200 bps, which matches the design parameter:

```verilog
parameter CLK_PER_BIT = 434;
```

This project is intended as a clean RTL design example for UART transmission and digital logic verification.
