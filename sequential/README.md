# Sequential Logic Design

This section focuses on core sequential digital design concepts implemented in Verilog. The work introduces how registers, counters, and shift-register based circuits are modeled at the RTL level and validated through simulation.

## Core Concepts

### Synchronous Sequential Logic

```verilog
always @(posedge clk)
```

A synchronous block updates on the active clock edge. This is the most common form of sequential logic and is typically used for registers and state machines.

### Asynchronous Reset

```verilog
always @(posedge clk or posedge rst)
```

In this form, the design responds to the clock edge or to an asynchronous reset event. When `rst` is asserted, the logic resets immediately, independent of the clock.

---

## Clock Generation

### Continuous clock with `always`

```verilog
always #10 clk = ~clk;
```

This pattern creates a clock signal by toggling its value every `10` time units. It is a simple and effective method for simulation-based verification.

### Clock generation using `initial` and `forever`

```verilog
initial begin
    forever #10 clk = ~clk;
end
```

This is often used when the design needs an explicitly initialized simulation environment. The `forever` loop keeps the clock running indefinitely during the testbench execution.

---

## Registers

Registers are foundational in RTL design. A strong understanding is built progressively through the following stages:

1. Basic register
2. Register with enable
3. Register with reset
4. Register with enable and reset

This incremental approach helps clarify how data is captured and stored at each clock edge.

### Testing Strategy

During the learning process, manual input assignment is useful for debugging because it makes signal behavior easier to trace and verify.

### Shift Registers

#### Right shift

```verilog
q <= {q[WIDTH-2:0], serial_in};
```

This shifts data toward the right, discarding the MSB while inserting new serial input into the LSB position.

#### Left shift

```verilog
q <= {serial_in, q[WIDTH-1:1]};
```

This shifts data toward the left, discarding the LSB while inserting the new serial input into the MSB position.

### Bit Manipulation

Bit operations using `<<` and `>>` are useful for implementing simple and efficient shift logic in RTL descriptions.

---

## Counters

This project represents an early parameterized Verilog design and a practical application of verification techniques such as:

- tasks
- functions
- `repeat`
- `while` loops
- `for` loops

The counter design is useful for learning how design flexibility and verification quality improve together. Parameters make the circuit scalable, while testbench constructs allow structured validation of the design behavior.

### Design Principles Learned

- parameterization improves design reuse and adaptability
- self-checking testbenches reduce manual debugging effort
- clock-driven verification is more reliable than ad hoc delay-based checks
- clean stimulus and expected-result checking help validate behavior systematically

### Direction for Improvement

- use parameters consistently for reusable RTL blocks
- prefer self-checking testbenches for robust verification
- minimize unnecessary delays and rely more on clock-aligned event controls like `@(posedge clk)`

---

## Simulation Notes

The examples in this section are compiled and executed using Icarus Verilog.

### Quick Start

```bash
cd sequential/counters

iverilog -o sim reg.v reg_tb.v

vvp sim
```

This workflow is used to validate the design behavior and inspect simulation results through waveform analysis.

## Project Focus

This section emphasizes the fundamentals of sequential design, including state retention, clock-driven behavior, reset handling, and data movement through shift and counter structures. These topics form the basis for more advanced RTL and verification work in later projects.
