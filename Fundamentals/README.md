# Fundamentals

This section contains the core digital design building blocks that form the foundation of RTL and verification work in this repository. It is organized into two major categories:

- Combinational logic
- Sequential logic

The purpose of this folder is to capture the essential concepts of digital electronics, starting from simple gate-level designs and progressing into state-based systems, registers, counters, and more advanced control logic.

## Contents

### Combinational Logic

This category includes designs whose outputs depend only on the current inputs, without any memory or state retention. Examples include:

- AND, OR, NAND, and OR-NAND gates
- Full adder and carry look-ahead adder
- Multiplexer and demultiplexer
- Comparator
- Priority encoder
- Parity generators
- ALU design

### Sequential Logic

This category includes systems that store information and depend on both current inputs and prior state. These modules are used to model registers, counters, and finite-state machines.

- Registers
- Parameterized counters
- State-based behavioral modeling
- Timing-aware digital design and verification

## Learning Focus

The work in this section emphasizes:

- logic gate implementation
- Boolean algebra and digital circuit design
- arithmetic and control-path building blocks
- state retention and clock-driven behavior
- simulation-based validation using Verilog testbenches

## Verification Style

Each design is typically validated with a corresponding testbench using simulation tools such as:

- Icarus Verilog
- GTKWave
- Verilator

The flow generally follows:

1. Write the RTL design
2. Create a testbench with expected behavior
3. Apply input stimulus
4. Run simulation
5. Inspect waveforms
6. Confirm functional correctness

## Repository Placement

This folder sits alongside the project-level work in the repository and is intended to represent the foundational digital design curriculum that supports more advanced implementations such as UART, FSM-based controllers, and system-level projects.

## Status

The Fundamentals directory contains the core lectures and exercises that underpin the repository's practical hardware design and verification work.
