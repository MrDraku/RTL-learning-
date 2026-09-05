# RTL Design and Verification Repository

This repository contains a collection of digital design and verification projects implemented in Verilog. The work focuses on building practical RTL systems, validating behavior with simulation, and developing a strong understanding of sequential and combinational digital logic.

The projects in this repository are organized around hands-on learning in hardware design, testbench development, and verification workflows. Each module is paired with a testbench to validate expected behavior under realistic timing conditions.

## Tools and Workflow

- Verilog HDL
- Icarus Verilog
- Verilator
- GTKWave
- Visual Studio Code
- Git and GitHub

## Repository Structure

### Projects

- **UART** — 8-bit UART transmitter design with a finite-state machine, baud-rate generation, and verification testbench
- **Washing Machine Controller** — Moore FSM-based controller for a smart washing machine including state transitions, safety handling, and output control

### Sequential

- **Register** — basic register implementation and validation
- **Counters** — parameterized counter design with simulation-based verification

### Combinational

- **Carry Look-Ahead Adder (CLA)** — 16-bit carry-look-ahead implementation
- **ALU** — arithmetic and logic unit design
- **Full Adder**
- **Mux / Demux**
- **Priority Encoder**
- **Comparator**
- **Parity Generators** — even and odd parity logic
- **Logic gate fundamentals** — AND, OR, NAND, and OR-NAND gate combinations

## Verification Approach

Each design follows a consistent verification flow:

1. Define the expected functional behavior
2. Write a self-checking testbench
3. Apply stimulus using clock-driven timing
4. Simulate the design
5. Inspect waveforms and validate outputs
6. Iterate until the design meets the specification

This approach emphasizes functional correctness, timing-aware verification, and disciplined digital design methodology.

## Quick Start

### Lint a design

```bash
verilator --lint-only -Wall Projects/UART/uart_tx.v
```

### Simulate a testbench

```bash
iverilog -g2012 Projects/UART/uart_tx_tb..sv Projects/UART/uart_tx.v -o uart_tx_tb.out
vvp uart_tx_tb.out
```

## Current Focus

This repository reflects an ongoing progression in RTL development and verification, covering:

- combinational logic design
- sequential logic and state machines
- protocol-oriented digital designs such as UART
- simulation and lint-based validation
- structural design review and verification discipline

## Contact

Guguloth Laxman  
Email: gugulothlaxman369@gmail.com  
LinkedIn: https://linkedin.com/in/guguloth-laxman-282a86425